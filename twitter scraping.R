#install.packages("twitteR")
library(twitteR)
library(dplyr)
consumerKey = "YoP9WK1cvm2f3Kvp853l1mul1"   # from your app name
consumerSecret = "1ainGfw5BgDP9In8OHh0NTwuQXOxU2UELIKM4TQi7ENTaowS8f"
accessToken = "388312259-nmDrGpvpMoIUshN8kOxput9adglpxs5ArMZc62bj"
accessSecret = "Izh67YOPYLPfPNfa5U10qqbZVFofUDH2Sfyqa5X4jpSHw"
options(httr_oauth_cache=TRUE) # skip question appearing on console
setup_twitter_oauth(consumer_key = consumerKey, consumer_secret = consumerSecret,
                    access_token = accessToken, access_secret = accessSecret)

express_tweets = userTimeline("expresslife",n=3200)
head(express_tweets)
as.data.frame.list(express_tweets)

expresstweets_df <- bind_rows(lapply(express_tweets, as.data.frame))

loft_tweets=userTimeline("LOFT",n=3200)
lofttweets_df<-bind_rows(lapply(loft_tweets,as.data.frame))

gap_tweets=userTimeline("Gap",n=3200)
gaptweets_df<-bind_rows(lapply(gap_tweets,as.data.frame))

jcrew_tweets=userTimeline("jcrew",n=3200)
jcrewtweets_df<-bind_rows(lapply(jcrew_tweets,as.data.frame))

