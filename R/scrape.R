#
# scrape.R - scrape web data and cache to the data/ directory:
#
#			 * airline-related tweets via twitteR's searchTwitter()
#			 * ACSI scores with XML's readHTMLTable()
#

if (VERBOSE)
	print("Searching Twitter for airline tweets and saving to disk")

require(httr)
require(twitteR)
require(RCurl)

#httr 
l_proxyUrl    <-  "webproxy.merck.com"
l_proxyPort   <-  8080  

# Set proxy options
set_config( use_proxy( url  = l_proxyUrl,
                       port = l_proxyPort))

# RCurl
options(RCurlOptions = list(proxy="webproxy.merck.com:8080"))


# 1. Find OAuth settings for twitter:
#    https://dev.twitter.com/docs/auth/oauth
oauth_endpoints("twitter")

# 2. Register an application at https://apps.twitter.com/
#    Make sure to set callback url to "http://127.0.0.1:1410"
#
#    Replace key and secret below
# myapp <- oauth_app("twitter",
#                    key = "uBhxCgL1stkFsJkTLDYgzv7EY",
#                    secret = "C936et4weZiQ5QR9AF5eeb2aKEoaXiFxCgrkk257HbbwChdYZW"
# )
#
# Register an application (API) at https://apps.twitter.com/
# Once done registering, look at the values of api key, secret and token
# Insert these values below:
api_key <- "uBhxCgL1stkFsJkTLDYgzv7EY"
api_secret <- "C936et4weZiQ5QR9AF5eeb2aKEoaXiFxCgrkk257HbbwChdYZW"
access_token <- "14112649-JTFNAazaS3q1beILGeRDmytcvd9q9UPqoLQAnMKgX"
access_token_secret <- "MjvfxJjJ5UMOxzM2YzQm5IbyyeuhCvk8l9kuJYOexzDSB"
setup_twitter_oauth(api_key,api_secret)#,access_token,access_token_secret)

print("Getting American Airlines tweets...")
american.tweets = searchTwitter('@americanair', n=1500)
save(american.tweets, file=file.path(dataDir, 'american.tweets.RData' ), ascii=T)

print("Getting Delta Airlines tweets...")
delta.tweets = searchTwitter('@delta', n=1500)
save(delta.tweets, file=file.path(dataDir, 'delta.tweets.RData' ), ascii=T)

print("Getting JetBlue Airlines tweets...")
jetblue.tweets = searchTwitter('@jetblue', n=1500)
save(jetblue.tweets, file=file.path(dataDir, 'jetblue.tweets.RData' ), ascii=T)

print("Getting Soutwest Airlines tweets...")
southwest.tweets = searchTwitter('@southwestair', n=1500)
save(southwest.tweets, file=file.path(dataDir, 'southwest.tweets.RData' ), ascii=T)

print("Getting United Airlines tweets...")
united.tweets = searchTwitter('@united', n=1500)
save(united.tweets, file=file.path(dataDir, 'united.tweets.RData' ), ascii=T)

print("Getting US Airways Airlines tweets...")
us.tweets = searchTwitter('@usairways', n=1500)
save(us.tweets, file=file.path(dataDir, 'us.tweets.RData' ), ascii=T)


if (VERBOSE)
	print("Scraping ACSI airline scores and saving to disk")

require(XML)


# this assumes 2014 scores
acsi.url = 'http://www.theacsi.org/index.php?option=com_content&view=article&id=147&catid=&Itemid=212&i=Airlines'
acsi <- getURL(acsi.url)
# we want the first table (which=1) on tha page, which has column headers (header=T)
acsi.raw.df = readHTMLTable(acsi, header=T, which=1, stringsAsFactors=F)
acsi.df = acsi.raw.df[,c(1,22)]

# change the columnn names ("14" -> "score" since we're only looking at most recent)
colnames(acsi.df) = c('airline', 'score')


# add codes for later matching, and make sure score is treated as a number (not a string)
acsi.df$code <- NA
acsi.df$code[acsi.df$airline == "American"] <- "AA"
acsi.df$code[acsi.df$airline == "Delta"] <- "DL"
acsi.df$code[acsi.df$airline == "JetBlue"] <- "B6"
acsi.df$code[acsi.df$airline == "Southwest"] <- "WN"
acsi.df$code[acsi.df$airline == "United"] <- "UA"
acsi.df$code[acsi.df$airline == "US Airways"] <- "US"
acsi.df$score = as.numeric(acsi.df$score)

save(acsi.raw.df, file=file.path(dataDir, 'acsi.raw.df.RData'), ascii=T)
save(acsi.df, file=file.path(dataDir, 'acsi.df.RData'), ascii=T)
