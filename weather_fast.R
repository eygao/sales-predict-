# set working directory
# Nina
setwd("~/Documents/HSPH/DataScience/sales-predict-")

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
library(rwunderground)

# wunderground key (Nina Elevated Access): dc1f7cb13c35da6d

## Data Over 3 Years (April 2013 - April 2016)
#######################################################################

# create date range
date.range <- seq.Date(from=as.Date('2013-4-20'), 
                       to=as.Date('2016-4-20'), by='1 day')

# remove "-" from date range
date.range <- str_replace_all(date.range, "[[:punct:]]", "")


#######################################################################
###################### NEW YORK, NEW YORK #############################
#######################################################################

# create empty vector to store dates
ny <- vector(mode='list', length=length(date.range))

# pull weather data from wunderground for all dates in date range
for (i in seq_along(date.range)) {
  ny[[i]] <- history_daily(set_location(
    territory = "New York", city = "New York"), date.range[i])
}

# stack loop responses for weather data
weather_NewYork <- ldply(ny)

# save new york data as .csv
write.csv(weather_NewYork, file = "weather_NewYork_2013-2016.csv", row.names=FALSE)

#######################################################################
##################### LOS ANGELES, CALIFORNIA #########################
#######################################################################

# create empty vector to store dates
ca <- vector(mode='list', length=length(date.range))

# pull weather data from wunderground for all dates in date range
for (i in seq_along(date.range)) {
  ca[[i]] <- history_daily(set_location(
    territory = "California", city = "Los Angeles"), date.range[i])
}

# stack loop responses for weather data
weather_LA <- ldply(ca)

# save los angeles data as .csv
write.csv(weather_LA, file = "weather_LA_2013-2016.csv", row.names=FALSE)

#######################################################################
######################## CHICAGO, ILLINOIS ############################
#######################################################################

# create empty vector to store dates
il <- vector(mode='list', length=length(date.range))

# pull weather data from wunderground for all dates in date range
for (i in seq_along(date.range)) {
  il[[i]] <- history_daily(set_location(
    territory = "Illinois", city = "Chicago"), date.range[i])
}

# stack loop responses for weather data
weather_Chicago <- ldply(il)

# save chicago data as .csv
write.csv(weather_Chicago, file = "weather_Chicago_2013-2016.csv", row.names=FALSE)

#######################################################################
########################## HOUSTON, TEXAS #############################
#######################################################################

# create empty vector to store dates
tx <- vector(mode='list', length=length(date.range))

# pull weather data from wunderground for all dates in date range
for (i in seq_along(date.range)) {
  print(date.range[i])
  tx[[i]] <- history_daily(set_location(
    territory = "Texas", city = "Houston"), date.range[i])
}

# stack loop responses for weather data
weather_Houston <- ldply(tx)

# save houston data as .csv
write.csv(weather_Houston, file = "weather_Houston_2013-2016.csv", row.names=FALSE)

## Weather Wrangling
#######################################################################

new_york <- read_csv("weather_NewYork_2013-2016.csv")
los_angeles <- read_csv("weather_LA_2013-2016.csv")
chicago <- read_csv("weather_Chicago_2013-2016.csv")
houston <- read_csv("weather_Houston_2013-2016.csv")

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

weather_joined <- full_join(new_york, los_angeles, chicago, houston, by = "date")