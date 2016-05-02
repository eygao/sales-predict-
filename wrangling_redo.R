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
library(timeDate)

setwd("~/Documents/HSPH/DataScience/sales-predict-")

## Weather Wrangling - Creates One File for Weather
#######################################################################

# read in weather csv files for 4 cities
new_york <- read_csv("weather_NewYork_2013-2016.csv")
los_angeles <- read_csv("weather_LA_2013-2016.csv")
chicago <- read_csv("weather_Chicago_2013-2016.csv")
houston <- read_csv("weather_Houston_2013-2016.csv")

# keep date, snow, mean_temp, precipitation columns, rename columns
new_york <- new_york %>% select(date, snow, mean_temp, precip) %>%
  rename (ny_snow = snow, ny_mean_temp = mean_temp, 
          ny_precip = precip)

los_angeles <- los_angeles %>% select(date, snow, mean_temp, precip) %>%
  rename (la_snow = snow, la_mean_temp = mean_temp, 
          la_precip = precip)

chicago <- chicago %>% select(date, snow, mean_temp, precip) %>%
  rename (chi_snow = snow, chi_mean_temp = mean_temp, 
          chi_precip = precip)

houston <- houston %>% select(date, snow, mean_temp, precip) %>%
  rename (hou_snow = snow, hou_mean_temp = mean_temp, 
          hou_precip = precip)

# join weather data from 4 cities together
ny_la <- full_join(new_york, los_angeles, by = "date")
ny_la_chi <- full_join(ny_la, chicago, by = "date")
weather <- full_join(ny_la_chi, houston, by = "date")

## Stock Wrangling - Create individual store files for stock prices
#######################################################################

# read in LOFT stock data
loft_URL <- "http://ichart.finance.yahoo.com/table.csv?s=ASNA"
loft <- read.csv(loft_URL)

# convert the date from a string to a Date type
loft$Date <- as.Date(loft$Date, "%Y-%m-%d")

# rename columns
loft_stocks <- loft %>% select(Date, Adj.Close) %>% 
  rename (date = Date, loft_adj_close = Adj.Close)

####

# read in Express stock data 
exp_URL <- "http://ichart.finance.yahoo.com/table.csv?s=EXPR"
exp <- read.csv(exp_URL)

# convert the date from a string to a Date type
exp$Date <- as.Date(exp$Date, "%Y-%m-%d")

# rename columns
exp_stocks <- exp %>% select(Date, Adj.Close) %>% 
  rename (date = Date, expr_adj_close = Adj.Close)

####

# read in Gap stock data 
gap_URL <- "http://ichart.finance.yahoo.com/table.csv?s=GPS"
gap <- read.csv(gap_URL)

# convert the date from a string to a Date type
gap$Date <- as.Date(gap$Date, "%Y-%m-%d")

# rename columns
gap_stocks <- gap %>% select(Date, Adj.Close) %>%
  rename (date = Date, gap_adj_close = Adj.Close)

## Unemployment Wrangling - Create one file for unemployment data
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

## Join Unemployment Data + Weather + Holidays
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

# add in holiday data

# create vector of US holidays from 2013 - 2016
holidays <- c(
  USChristmasDay(2012:2016),
  ChristmasEve(2012:2016),
  Easter(2012:2016),
  USGoodFriday(2012:2016),
  USLaborDay(2012:2016),
  USNewYearsDay(2012:2016),
  USColumbusDay(2012:2016),
  USMemorialDay(2012:2016),
  USElectionDay(2012:2016),
  USIndependenceDay(2012:2016),
  USMLKingsBirthday(2012:2016),
  USPresidentsDay(2012:2016),
  USThanksgivingDay(2012:2016),
  USVeteransDay(2012:2016)
)

# convert holiday vector into data frame & create indicator column
holidays <- as.data.frame(holidays) %>% mutate(holiday = 1)

# rename first column as date
colnames(holidays)[1] <- "date"

# convert date column into date format
holidays[1] <- as.Date(holidays$date)

weather_unemp <- left_join(weather_unemp, holidays, by = "date")

weather_unemp <- weather_unemp %>% mutate(holiday = ifelse(is.na(holiday),0,holiday))


## Wrangle Tweets -- Separate tweets into individual words 
#######################################################################

# create list of words to identify sales
sale_words = c("off", "sale")

# EXPRESS
# get tweets
express_tweets <- read_csv("expresstweets.csv")

# create outcome column for sales at EXPRESS
express_outcome <- express_tweets %>%
  unnest_tokens(word, expresstext) %>%
  group_by(word) %>%
  mutate (sale = ifelse(word %in% sale_words, 1, 0)) %>%
  filter(sale == 1)

# join with weather, stock, unemployment, data
express <- left_join(weather_unemp, express_outcome, by = "date")
express <- full_join(express, exp_stocks, by = "date")

# create 0 in outcome column for sales
express <- express %>% 
  mutate(sale = ifelse(is.na(sale),0,sale)) %>%
  select(-word) %>%
  unique()

###

# GAP
# get tweets
gap_tweets <- read_csv("gaptweets.csv")

# create outcome column for sales at GAP
gap_outcome <- gap_tweets %>%
  unnest_tokens(word, gaptext) %>%
  group_by(word) %>%
  mutate (sale = ifelse(word %in% sale_words, 1, 0)) %>%
  filter(sale == 1)

# join with weather, stock, unemployment, data
gap <- left_join(weather_unemp, gap_outcome, by = "date")
gap <- full_join(gap, gap_stocks, by = "date")

# create 0 in outcome column for sales
gap <- gap %>% 
  mutate(sale = ifelse(is.na(sale),0,sale)) %>%
  select(-word) %>%
  unique()

###

# JCREW
# get tweets
jcrew_tweets <- read_csv("jcrewtweets.csv")

# create outcome column for sales at JCREW
jcrew_outcome <- jcrew_tweets %>%
  unnest_tokens(word, jcrewtext) %>%
  group_by(word) %>%
  mutate (sale = ifelse(word %in% sale_words, 1, 0)) %>%
  filter(sale == 1)

# join with weather, stock, unemployment, data
jcrew <- left_join(weather_unemp, jcrew_outcome, by = "date")

# create 0 in outcome column for sales
jcrew <- jcrew %>% 
  mutate(sale = ifelse(is.na(sale),0,sale)) %>%
  select(-word) %>%
  unique()

###

# LOFT
# get tweets
loft_tweets <- read_csv("lofttweets.csv")

# create outcome column for sales at LOFT
loft_outcome <- loft_tweets %>%
  unnest_tokens(word, lofttext) %>%
  group_by(word) %>%
  mutate (sale = ifelse(word %in% sale_words, 1, 0)) %>%
  filter(sale == 1)

# join with weather, stock, unemployment, data
loft <- left_join(weather_unemp, loft_outcome, by = "date")
loft <- full_join(loft, loft_stocks, by = "date")

# create 0 in outcome column for sales
loft <- loft %>% 
  mutate(sale = ifelse(is.na(sale),0,sale)) %>%
  select(-word) %>%
  unique()


## Create a joined file for visualization
#######################################################################

# EXPRESS
# filter express for only sale dates
express_vis <- express_outcome %>%
  rename(expresssale = sale)

express_vis <- within(express_vis, rm(word))

# GAP
# filter gap for only sale dates
gap_vis <- gap_outcome %>%
  rename(gapsale = sale)

gap_vis <- within(gap_vis, rm(word))

# JCREW
# filter jcrew for only sale dates
jcrew_vis <- jcrew_outcome %>%
  rename(jcrewsale = sale)

jcrew_vis <- within(jcrew_vis, rm(word))

#LOFT
# filter loft for only sale dates
loft_vis <- loft_outcome %>% 
  rename(loftsale = sale)

loft_vis <- within(loft_vis, rm(word))

# join filtered data sets together -- only word & outcome columns
joined <- full_join(express_vis, gap_vis, by = "date")
joined <- full_join(joined, jcrew_vis, by = "date")
joined <- full_join(joined, loft_vis, by = "date")

# join with weather & unemployment
joined <- left_join(weather_unemp, joined, by = "date")

# join with stocks
joined <- full_join(joined, exp_stocks, by = "date")
joined <- full_join(joined, loft_stocks, by = "date")
joined <- full_join(joined, gap_stocks, by = "date")

# replace NAs with 0s
joined <- joined %>% 
  mutate(expresssale = ifelse(is.na(expresssale),0,expresssale)) %>%
  mutate(gapsale = ifelse(is.na(gapsale),0,gapsale)) %>%
  mutate(jcrewsale = ifelse(is.na(jcrewsale),0,jcrewsale)) %>%
  mutate(loftsale = ifelse(is.na(loftsale),0,loftsale))

# save joined dataset for visualizations as a .csv
write.csv(joined, file = "joined_for_visualization.csv", row.names=FALSE)
