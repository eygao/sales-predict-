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

# wunderground key (Nina): dc1f7cb13c35da6d
# wunderground key (Emily): c52d7ad36cc9d20f
# wunderground key (Jon): 27e1fb02aa0bc179

#######################################################################
################## YEAR 1: NEW YORK, NEW YORK #########################
#######################################################################

# create date range
date.range <- seq.Date(from=as.Date('2015-4-20'), 
                       to=as.Date('2016-4-20'), by='1 day')

# remove "-" from date range
date.range <- str_replace_all(date.range, "[[:punct:]]", "")

# create empty vector to store dates
ny <- vector(mode='list', length=length(date.range))

# pull weather data from wunderground for all dates in date range
# pause for 10 seconds after each iteration (API only allows 10 requests per minute)
# city = New York
for (i in seq_along(date.range)) {
  print(date.range[i])
  ny[[i]] <- history_daily(set_location(
    territory = "New York", city = "New York"), date.range[i])
  Sys.sleep(10)
}

# stack loop responses for weather data
weather_NewYork <- ldply(ny)

# save new york data as .csv
write.csv(weather_NewYork, file = "weather_NewYork_04-04_2015-16.csv", row.names=FALSE)

#######################################################################
################## YEAR 2: NEW YORK, NEW YORK #########################
#######################################################################

# create date range
date.range <- seq.Date(from=as.Date('2014-4-20'), 
                       to=as.Date('2015-4-19'), by='1 day')

# remove "-" from date range
date.range <- str_replace_all(date.range, "[[:punct:]]", "")

# create empty vector to store dates
ny <- vector(mode='list', length=length(date.range))

# pull weather data from wunderground for all dates in date range
# pause for 10 seconds after each iteration (API only allows 10 requests per minute)
# city = New York
for (i in seq_along(date.range)) {
  print(date.range[i])
  ny[[i]] <- history_daily(set_location(
    territory = "New York", city = "New York"), date.range[i])
  Sys.sleep(10)
}

# stack loop responses for weather data
weather_NewYork <- ldply(ny)

# save new york data as .csv
write.csv(weather_NewYork, file = "weather_NewYork_04-04_2014-15.csv", row.names=FALSE)
