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

#EXPRESS
express_tweets = userTimeline("expresslife",n=3200,excludeReplies=TRUE)
expresstweets_df <- bind_rows(lapply(express_tweets, as.data.frame))
minid_e <- min(expresstweets_df$id)
older_express <- userTimeline("expresslife", n=3200, maxID = minid_e, excludeReplies=TRUE)
older_expressdf <- bind_rows(lapply(older_express, as.data.frame))
max(expresstweets_df$created)
min(expresstweets_df$created)
min(older_expressdf$created)
max(older_expressdf$created)

older_express2 <- userTimeline("expresslife", n=3200, maxID = minid_e2)
older_expressdf2 <- bind_rows(lapply(older_express2, as.data.frame))
 
loft_tweets=userTimeline("LOFT",n=3200)
lofttweets_df<-bind_rows(lapply(loft_tweets,as.data.frame))

gap_tweets=userTimeline("Gap",n=3200)
gaptweets_df<-bind_rows(lapply(gap_tweets,as.data.frame))

jcrew_tweets=userTimeline("jcrew",n=3200)
jcrewtweets_df<-bind_rows(lapply(jcrew_tweets,as.data.frame))

#Looping IDs


minid_l <- min(lofttweets_df$id)
minid_l

older_loft <- userTimeline("LOFT", n=3200, maxID = minid_l)
older_loftdf <- bind_rows(lapply(older_loft, as.data.frame))

minid_l2<-min(older_loftdf$id)

older_loft2 <- userTimeline("LOFT", n=3200, maxID = minid_l2)
older_loftdf2 <- bind_rows(lapply(older_loft2, as.data.frame))

#LOOP
storehandles<-c("expresslife","jcrew","LOFT","Gap")
for(i in 1:3) {
  min_id<-min(sample(1:100,5))
  mini_max<-mini+10
  print(mini:mini_max)
}

#FUNCTION
get_tweets<-function(s){
  (s)_tweets=userTimeline("LOFT",n=3200)
  lofttweets_df<-bind_rows(lapply(loft_tweets,as.data.frame))
  
}