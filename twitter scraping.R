#install.packages("twitteR")
library(twitteR)
library(dplyr)
library (lubridate)
#MINE
consumerKey = "YoP9WK1cvm2f3Kvp853l1mul1"   # from your app name
consumerSecret = "1ainGfw5BgDP9In8OHh0NTwuQXOxU2UELIKM4TQi7ENTaowS8f"
accessToken = "388312259-nmDrGpvpMoIUshN8kOxput9adglpxs5ArMZc62bj"
accessSecret = "Izh67YOPYLPfPNfa5U10qqbZVFofUDH2Sfyqa5X4jpSHw"
options(httr_oauth_cache=TRUE) # skip question appearing on console
setup_twitter_oauth(consumer_key = consumerKey, consumer_secret = consumerSecret,
                    access_token = accessToken, access_secret = accessSecret)

#EMILY
options(twitter_consumer_key = "6Kcw6wYKGwEceDCugXTkNGa0E")
options(twitter_consumer_secret = "5BPFwb5cnMbKJrCnqPTh8RIBGR2709y84kT5oEOCRncahmRgOb")
options(twitter_access_token = '385217925-9JOlq5duwAUjW4ytunUDf2oRRi5YSOnu8NYhBdZG')
options(twitter_access_token_secret = "LCu9khjY8PKzA1DRYiM6Zv2xZxqbm5pvaWpoGaA88R6Ta")
setup_twitter_oauth(getOption("twitter_consumer_key"),
                    getOption("twitter_consumer_secret"),
                    getOption("twitter_access_token"),
                    getOption("twitter_access_token_secret"))

#NINA
options(twitter_consumer_key = "5vJDasKI4ZSUTq2I55kTY1zDT")
options(twitter_consumer_secret = "PGo7miqFwVLakEJ75ahZsrSUFX2akLX2npeMsFQWuiuSllJ675")
options(twitter_access_token = '1145484565-Uit9nc8ZGCOUqzF7t0iKTcJHHN45t9G8FwyGrlD')
options(twitter_access_token_secret = "3CjrJYFJswCbgMqxPxti9CJaXRL1x6Tdaqfe2CJvR9hLY")
setup_twitter_oauth(getOption("twitter_consumer_key"),
                    getOption("twitter_consumer_secret"),
                    getOption("twitter_access_token"),
                    getOption("twitter_access_token_secret"))

#EXPRESS
express_tweets = userTimeline("expresslife",n=3200,excludeReplies=TRUE)
expresstweets_df <- bind_rows(lapply(express_tweets, as.data.frame))
expresstweets_df<-expresstweets_df%>%select(text, created)
max(expresstweets_df$created)
min(expresstweets_df$created)
minid_e <- min(expresstweets_df$id)
older_express <- userTimeline("expresslife", n=3200, maxID = minid_e, excludeReplies=TRUE)
older_expressdf <- bind_rows(lapply(older_express, as.data.frame))
older_expressdf<-older_expressdf%>%select(text, created)
min(older_expressdf$created)
max(older_expressdf$created)

#LOFT 
#pull 1
loft_tweets=userTimeline("LOFT",n=3200)
lofttweets_df<-bind_rows(lapply(loft_tweets,as.data.frame))
lofttweets_df<-lofttweets_df%>%select(text, created)
#pull 2
minid_l <- min(lofttweets_df$id)
older_loft <- userTimeline("LOFT", n=3200, maxID = minid_l, excludeReplies=TRUE)
older_loftdf <- bind_rows(lapply(older_loft, as.data.frame))
older_loftdf<-older_loftdf%>%select(text, created)
min(lofttweets_df$created)
max(lofttweets_df$created)
min(older_loftdf$created)
max(older_loftdf$created)
#pull 3
minid_l2 <- min(older_loftdf$id)
older_loft2 <- userTimeline("LOFT", n=3200, maxID = minid_l2, excludeReplies=TRUE)
older_loftdf2 <- bind_rows(lapply(older_loft2, as.data.frame))
older_loftdf2<-older_loftdf2%>%select(text, created)
min(older_loftdf2$created)
max(older_loftdf2$created)
#pull 4
minid_l3 <- min(older_loftdf2$id)
older_loft3 <- userTimeline("LOFT", n=3200, maxID = minid_l3, excludeReplies=TRUE)
older_loftdf3 <- bind_rows(lapply(older_loft3, as.data.frame))
older_loftdf3<-older_loftdf3%>%select(text, created)
min(older_loftdf3$created)
max(older_loftdf3$created)
#pull 5
minid_l4 <- min(older_loftdf3$id)
older_loft4 <- userTimeline("LOFT", n=3200, maxID = minid_l4, excludeReplies=TRUE)
older_loftdf4 <- bind_rows(lapply(older_loft4, as.data.frame))
older_loftdf4<-older_loftdf4%>%select(text, created)
min(older_loftdf4$created)
max(older_loftdf4$created)
#pull 6
minid_l5 <- min(older_loftdf4$id)
older_loft5 <- userTimeline("LOFT", n=3200, maxID = minid_l5, excludeReplies=TRUE)
older_loftdf5 <- bind_rows(lapply(older_loft5, as.data.frame))
older_loftdf5<-older_loftdf5%>%select(text, created)
min(older_loftdf5$created)
max(older_loftdf5$created)

#GAP
#pull 1
gap_tweets=userTimeline("Gap",n=3200)
gaptweets_df<-bind_rows(lapply(gap_tweets,as.data.frame))
gaptweets_df<-gaptweets_df%>%select(text, created)
min(gaptweets_df$created)
max(gaptweets_df$created)
#pull 2
minid_g <- min(gaptweets_df$id)
older_gap <- userTimeline("Gap", n=3200, maxID = minid_g, excludeReplies=TRUE)
older_gapdf <- bind_rows(lapply(older_gap, as.data.frame))
older_gapdf<-older_gapdf%>%select(text, created)
min(older_gapdf$created)
max(older_gapdf$created)
#pull 3
minid_g2 <- min(older_gapdf$id)
older_gap2 <- userTimeline("Gap", n=3200, maxID = minid_g2, excludeReplies=TRUE)
older_gapdf2 <- bind_rows(lapply(older_gap2, as.data.frame))
older_gapdf2<-older_gapdf2%>%select(text, created)
min(older_gapdf2$created)
max(older_gapdf2$created)

#JCREW
jcrew_tweets=userTimeline("jcrew",n=3200)
jcrewtweets_df<-bind_rows(lapply(jcrew_tweets,as.data.frame))
jcrewtweets_df<-jcrewtweets_df%>%select(text,created)
min(jcrewtweets_df$created)
max(jcrewtweets_df$created)
#Don't need to do another one because this pull goes back to 2011

#URBAN OUTFITTERS
#pull 1
urban_tweets=userTimeline("UrbanOutfitters",n=3200)
urbantweets_df<-bind_rows(lapply(urban_tweets,as.data.frame))
urbantweets_df<-urbantweets_df%>%select(text,created)
min(urbantweets_df$created)
max(urbantweets_df$created)
#pull 2
minid_u <- min(urbantweets_df$id)
older_urban <- userTimeline("UrbanOutfitters", n=3200, maxID = minid_u, excludeReplies=TRUE)
older_urbandf <- bind_rows(lapply(older_urban, as.data.frame))
older_urbandf<-older_urbandf%>%select(text,created)
min(older_urbandf$created)
max(older_urbandf$created)

#ANTHROPOLOGIE
#pull 1
anthro_tweets=userTimeline("Anthropologie",n=3200)
anthrotweets_df<-bind_rows(lapply(anthro_tweets,as.data.frame))
anthrotweets_df<-anthrotweets_df%>%select(text,created)
min(anthrotweets_df$created)
max(anthrotweets_df$created)
#pull 2
minid_a <- min(anthrotweets_df$id)
older_anthro <- userTimeline("Anthropologie", n=3200, maxID = minid_a, excludeReplies=TRUE)
older_anthrodf <- bind_rows(lapply(older_anthro, as.data.frame))
older_anthrodf<-older_anthrodf%>%select(text,created)
min(older_anthrodf$created)
max(older_anthrodf$created)
#pull 3
minid_a2 <- min(older_anthrodf$id)
older_anthro2 <- userTimeline("Anthropologie", n=3200, maxID = minid_a2, excludeReplies=TRUE)
older_anthrodf2 <- bind_rows(lapply(older_anthro2, as.data.frame))
older_anthrodf2<-older_anthrodf2%>%select(text,created)
min(older_anthrodf2$created)
max(older_anthrodf2$created)
#pull 4
minid_a3 <- min(older_anthrodf2$id)
older_anthro3 <- userTimeline("Anthropologie", n=3200, maxID = minid_a3, excludeReplies=TRUE)
older_anthrodf3 <- bind_rows(lapply(older_anthro3, as.data.frame))
older_anthrodf3<-older_anthrodf3%>%select(text,created)
min(older_anthrodf3$created)
max(older_anthrodf3$created)
#pull 5
minid_a4 <- min(older_anthrodf3$id)
older_anthro4 <- userTimeline("Anthropologie", n=3200, maxID = minid_a4, excludeReplies=TRUE)
older_anthrodf4 <- bind_rows(lapply(older_anthro4, as.data.frame))
older_anthrodf4<-older_anthrodf4%>%select(text,created)
min(older_anthrodf4$created)
max(older_anthrodf4$created)

## Join Twitter Data
#######################################################################

#Express
expresstweets<-bind_rows(expresstweets_df, older_expressdf)
expresstweets <- expresstweets %>% mutate (date = as.Date(expresstweets$created, format = "%Y/%m/%d"))
expresstweets<-expresstweets%>%select(text,date)
expresstweets<-expresstweets%>%rename(expresstext=text)
write.csv(expresstweets, file = "expresstweets.csv", row.names=FALSE)

#Gap
gaptweets<-bind_rows(gaptweets_df,older_gapdf,older_gapdf2)
gaptweets <- gaptweets %>% mutate (date = as.Date(gaptweets$created, format = "%Y/%m/%d"))
gaptweets<-gaptweets%>%select(text,date)
gaptweets<-gaptweets%>%rename(gaptext=text)
write.csv(gaptweets, file = "gaptweets.csv", row.names=FALSE)

#LOFT
lofttweets<-bind_rows(lofttweets_df,older_loftdf, older_loftdf2, older_loftdf3, older_loftdf4, older_loftdf5)
lofttweets <- lofttweets %>% mutate (date = as.Date(lofttweets$created, format = "%Y/%m/%d"))
lofttweets<-lofttweets%>%select(text,date)
lofttweets<-lofttweets%>%rename(lofttext=text)
write.csv(lofttweets, file = "lofttweets.csv", row.names=FALSE)

#Urban Outfitters
urbantweets<-bind_rows(urbantweets_df,older_urbandf,older_urbandf2)
urbantweets <- urbantweets %>% mutate (date = as.Date(urbantweets$created, format = "%Y/%m/%d"))
urbantweets<-urbantweets%>%select(text,date)
urbantweets<-urbantweets%>%rename(urbantext=text)
write.csv(urbantweets, file = "urbantweets.csv", row.names=FALSE)

#JCrew
jcrewtweets<-jcrewtweets_df
jcrewtweets <- jcrewtweets %>% mutate (date = as.Date(jcrewtweets$created, format = "%Y/%m/%d"))
jcrewtweets<-jcrewtweets%>%select(text,date)
jcrewtweets<-jcrewtweets%>%rename(jcrewtext=text)
write.csv(jcrewtweets, file = "jcrewtweets.csv", row.names=FALSE)
