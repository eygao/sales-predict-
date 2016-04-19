rm(list = ls())

#install.packages("streamR")
#install.packages("ROAuth")
library(ROAuth)
library(streamR)

#sets your working directory - Rachel 
setwd('/Users/rachelbrigell/Dropbox/HSPH/Spring 2 2016/BIO 260/sales-predict-')
#sets your working directory - Emily
setwd("~/Dropbox (Personal)/Spring 2015/Data Science/sales-predict-")

#create your OAuth credential-Rachel
credential <- OAuthFactory$new(consumerKey='YoP9WK1cvm2f3Kvp853l1mul1',
                               consumerSecret='1ainGfw5BgDP9In8OHh0NTwuQXOxU2UELIKM4TQi7ENTaowS8f',
                               requestURL='https://api.twitter.com/oauth/request_token',
                               accessURL='https://api.twitter.com/oauth/access_token',
                               authURL='https://api.twitter.com/oauth/authorize')
#create your OAuth credential-Emily
credential <- OAuthFactory$new(consumerKey='0c9bYRN6ZIVGjBVQQB9eXuzuQ',
                               consumerSecret='SImuevFXUWSU6RtwUtl0qwTwfdGNJCPO1dzJl85TQglBHz45YS',
                               requestURL='https://api.twitter.com/oauth/request_token',
                               accessURL='https://api.twitter.com/oauth/access_token',
                               authURL='https://api.twitter.com/oauth/authorize')



#authentication process
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
download.file(url="http://curl.haxx.se/ca/cacert.pem", destfile="cacert.pem")
credential$handshake(cainfo="cacert.pem")

#function to actually scrape Twitter
filterStream( file.name="express_tweets_1.json",
              follow="251294686", oauth=credential, tweets=10, timeout=30, lang='en' )

#Parses the tweets
tweet_df <- parseTweets(tweets='express_tweets_1.json')

#using the Twitter dataframe
tweet_df$created_at
tweet_df$text


plot(tweet_df$friends_count, tweet_df$followers_count) #plots scatterplot
cor(tweet_df$friends_count, tweet_df$followers_count) #returns the correlation coefficient


# TRYING twitteR
#install.packages("twitteR")
library(twitteR)

#Rachel credentials
consumerKey = "YoP9WK1cvm2f3Kvp853l1mul1"   # from your app name
consumerSecret = "1ainGfw5BgDP9In8OHh0NTwuQXOxU2UELIKM4TQi7ENTaowS8f"
accessToken = "388312259-nmDrGpvpMoIUshN8kOxput9adglpxs5ArMZc62bj"
accessSecret = "Izh67YOPYLPfPNfa5U10qqbZVFofUDH2Sfyqa5X4jpSHw"
options(httr_oauth_cache=TRUE) # skip question appearing on console

#Emily credentials
consumerKey = "0c9bYRN6ZIVGjBVQQB9eXuzuQ"   # from your app name
consumerSecret = "SImuevFXUWSU6RtwUtl0qwTwfdGNJCPO1dzJl85TQglBHz45YS"
accessToken = "85217925-0zxobdY5cZoLOe5JpyP8H6JKd8iMsVdUljF5lMe8"
accessSecret = "vIsWGoKTpB9yvBAyjIONdjZ8NsYVJmfGx2vHZSu9PrXDg"
options(httr_oauth_cache=TRUE) # skip question appearing on console

#authentication process
setup_twitter_oauth(consumer_key = consumerKey, consumer_secret = consumerSecret,
                    access_token = accessToken, access_secret = accessSecret)

#function to actually scrape Twitter
express_tweets = userTimeline("expresslife",n=3200)
express_tweets
head(express_tweets)
as.data.frame.list(express_tweets)
