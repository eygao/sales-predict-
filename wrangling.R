library(httr)
library(plyr)
library(dplyr)
library(knitr)
library(readr)
library(tidyr)
library(stringr)
library(ggplot2)
library(gridExtra)
library(ggrepel)
library(lubridate)
library(rwunderground)
library(tidytext)

setwd("~/Documents/HSPH/DataScience/sales-predict-")

## Weather Wrangling
#######################################################################

# read in weather csv files for 4 cities
new_york <- read_csv("weather_NewYork_2013-2016.csv")
los_angeles <- read_csv("weather_LA_2013-2016.csv")
chicago <- read_csv("weather_Chicago_2013-2016.csv")
houston <- read_csv("weather_Houston_2013-2016.csv")

# keep date, snow, mean_temp, max_temp, min_temp, rename columns
new_york <- new_york %>% select(date, snow, mean_temp, max_temp, min_temp) %>%
  rename (ny_snow = snow, ny_mean_temp = mean_temp, 
          ny_max_temp = max_temp, ny_min_temp = min_temp)

los_angeles <- los_angeles %>% select(date, snow, mean_temp, max_temp, min_temp) %>%
  rename (la_snow = snow, la_mean_temp = mean_temp, 
          la_max_temp = max_temp, la_min_temp = min_temp)

chicago <- chicago %>% select(date, snow, mean_temp, max_temp, min_temp) %>%
  rename (chi_snow = snow, chi_mean_temp = mean_temp, 
          chi_max_temp = max_temp, chi_min_temp = min_temp)

houston <- houston %>% select(date, snow, mean_temp, max_temp, min_temp) %>%
  rename (hou_snow = snow, hou_mean_temp = mean_temp, 
          hou_max_temp = max_temp, hou_min_temp = min_temp)

# join 4 cities together
ny_la <- full_join(new_york, los_angeles, by = "date")
ny_la_chi <- full_join(ny_la, chicago, by = "date")
weather <- full_join(ny_la_chi, houston, by = "date")

## Stock Wrangling
#######################################################################

# read in LOFT stock data
loft_URL <- "http://ichart.finance.yahoo.com/table.csv?s=ASNA"
loft <- read.csv(loft_URL)

# convert the date from a string to a Date type
loft$Date <- as.Date(loft$Date, "%Y-%m-%d")

# rename columns
loft_stocks <- loft %>%  rename (date = Date, loft_open = Open, loft_high = High, loft_low = Low, 
                          loft_close = Close, loft_volume = Volume, 
                          loft_adj_close = Adj.Close)

####

# read in Express stock data 
exp_URL <- "http://ichart.finance.yahoo.com/table.csv?s=EXPR"
exp <- read.csv(exp_URL)

# convert the date from a string to a Date type
exp$Date <- as.Date(exp$Date, "%Y-%m-%d")

# rename columns
exp_stocks <- exp %>%  rename (date = Date, expr_open = Open, expr_high = High, expr_low = Low, 
                        expr_close = Close, expr_volume = Volume, 
                        expr_adj_close = Adj.Close)

####

# read in Gap stock data 
gap_URL <- "http://ichart.finance.yahoo.com/table.csv?s=GPS"
gap <- read.csv(gap_URL)

# convert the date from a string to a Date type
gap$Date <- as.Date(gap$Date, "%Y-%m-%d")

# rename columns
gap_stocks <- gap %>%  rename (date = Date, gap_open = Open, gap_high = High, gap_low = Low, 
                        gap_close = Close, gap_volume = Volume, 
                        gap_adj_close = Adj.Close)

## Unemployment Wrangling
#######################################################################

# read in unemployment data
unemp_wide <- read_csv("Unemployment_Labor_ByMonth.csv")

# rename month columns from abbreviations to numbers
unemp_wide <- unemp_wide %>% rename("01" = Jan, "02" = Feb, "03" = Mar, "04" = Apr,
                                    "05" = May, "06" = Jun, "07" = Jul, "08" = Aug,
                                    "09" = Sep, "10" = Oct,"11" = Nov, "12" = Dec)

# convert unemployement data from wide to long
unemp <- unemp_wide %>% gather(month, unemployment, 2:13)

# create column for year-month
unemp$date_month = paste(unemp$Year, unemp$month, sep="-")

# rename date column and select only year-month and unemployment columns
unemp <- unemp %>% rename(date_y_m = date_month) %>% select(date_y_m, unemployment) %>%
  mutate(date_y_m = as.character(date_y_m))

## Join Unemployment Data + Stock Data + Weather
#######################################################################

# remove time from weather date column
weather <- weather %>% mutate (date = as.Date(date, format = "%Y/%m/%d"))

# create column in weather to join with unemployment data (year-month)
weather <- weather %>% mutate(date2 = date) %>% 
  separate(date2, c("year", "month", "day"), sep = "-", convert = TRUE, fill = "right") %>% 
  mutate(month = ifelse(month < 10, paste(0, month, sep = ""), month)) %>%
  mutate(date_y_m = paste(as.character(year), as.character(month), sep = "-")) %>%
  select(-c(year, month, day))

# join weather data and unemployment data
weather_unemp <- left_join(weather, unemp, by = "date_y_m")

# remove year-month column
weather_unemp <- weather_unemp %>% select(-date_y_m)

# JOIN for EXPRESS
express <- full_join(exp_stocks, weather_unemp, by= "date")
exp_tweets <- read_csv("expresstweets.csv")
express <- full_join(exp_tweets, express, by = "date")

write.csv(express, file = "express_joined.csv", row.names=FALSE)

# JOIN for GAP
gap <- full_join(gap_stocks, weather_unemp, by= "date")
gap_tweets <- read_csv("gaptweets.csv")
gap <- full_join(gap_tweets, gap, by = "date")

write.csv(gap, file = "gap_joined.csv", row.names=FALSE)

# JOIN for JCREW
jcrew <- weather_unemp
jcrew_tweets <- read_csv("jcrewtweets.csv")
jcrew <- full_join(jcrew_tweets, jcrew, by = "date")

write.csv(jcrew, file = "jcrew_joined.csv", row.names=FALSE)

# JOIN for LOFT
loft <- full_join(loft_stocks, weather_unemp, by= "date")
loft_tweets <- read_csv("lofttweets.csv")
loft <- full_join(loft_tweets, loft, by = "date")

write.csv(loft, file = "loft_joined.csv", row.names=FALSE)


## Wrangle Tweets -- Separate tweets into individual words
#######################################################################

# create list of words to identify sales
sale_words = c("off", "sale")

# create outcome column for sales at EXPRESS
express <- express %>%
  unnest_tokens(word, expresstext) %>%
  group_by(word) %>%
  mutate (sale = ifelse(word %in% sale_words, 1, 0))

# create outcome column for sales at GAP
gap <- gap %>%
  unnest_tokens(word, gaptext) %>%
  group_by(word) %>%
  mutate (sale = ifelse(word %in% sale_words, 1, 0))

# create outcome column for sales at JCREW
jcrew <- jcrew %>%
  unnest_tokens(word, jcrewtext) %>%
  group_by(word) %>%
  mutate (sale = ifelse(word %in% sale_words, 1, 0))

# create outcome column for sales at LOFT
loft <- loft %>%
  unnest_tokens(word, lofttext) %>%
  group_by(word) %>%
  mutate (sale = ifelse(word %in% sale_words, 1, 0))

## Create a joined file for visualization
#######################################################################

# filter express for only sale dates
express_filtered <- express %>% filter(sale == 1)

# filter gap for only sale dates
gap_filtered <- gap %>% filter(sale == 1)

# filter jcrew for only sale dates
jcrew_filtered <- jcrew %>% filter(sale == 1)

# filter loft for only sale dates
loft_filtered <- loft %>% filter(sale == 1)

joined <- full_join(express_filtered, gap_filtered, by = "date")
joined <- full_join(joined, jcrew_filtered, by = "date")
joined <- full_join(joined, loft_filtered, by = "date")

