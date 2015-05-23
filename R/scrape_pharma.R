#
# scrape.R - scrape web data and cache to the data/ directory:
#
#			 * airline-related tweets via twitteR's searchTwitter()
#			 * ACSI scores with XML's readHTMLTable()
#
TWEET_LIMIT <- 500

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

print("Getting Novartis tweets...")
novartis.tweets = searchTwitter('@Novartis', n=TWEET_LIMIT)
save(novartis.tweets, file=file.path(dataDir, 'novartis.tweets.RData' ), ascii=T)

print("Getting Pfizer tweets...")
pfizer.tweets = searchTwitter('@pfizer', n=TWEET_LIMIT)
save(pfizer.tweets, file=file.path(dataDir, 'pfizer.tweets.RData' ), ascii=T)

print("Getting Roche Holding tweets...")
roche.tweets = searchTwitter('@Roche', n=TWEET_LIMIT)
save(roche.tweets, file=file.path(dataDir, 'roche.tweets.RData' ), ascii=T)

print("Getting Sanofi tweets...")
sanofi.tweets = searchTwitter('@sanofi', n=TWEET_LIMIT)
save(sanofi.tweets, file=file.path(dataDir, 'sanofi.tweets.RData' ), ascii=T)

print("Getting Merck tweets...")
merck.tweets = searchTwitter('@Merck', n=TWEET_LIMIT)
save(merck.tweets, file=file.path(dataDir, 'merck.tweets.RData' ), ascii=T)

print("Getting GlaxoSmithKline tweets...")
gsk.tweets = searchTwitter('@gsk', n=TWEET_LIMIT)
save(gsk.tweets, file=file.path(dataDir, 'gsk.tweets.RData' ), ascii=T)

print("Getting Johnson & Johnson tweets...")
jnj.tweets = searchTwitter('@JNJNews', n=TWEET_LIMIT)
save(jnj.tweets, file=file.path(dataDir, 'jnj.tweets.RData' ), ascii=T)

print("Getting AstraZeneca tweets...")
astrazeneca.tweets = searchTwitter('@AstraZeneca', n=TWEET_LIMIT)
save(astrazeneca.tweets, file=file.path(dataDir, 'astrazeneca.tweets.RData' ), ascii=T)

print("Getting Eli Lilly tweets...")
eli.tweets = searchTwitter('@LillyPad', n=TWEET_LIMIT)
save(eli.tweets, file=file.path(dataDir, 'eli.tweets.RData' ), ascii=T)

print("Getting Abbvie tweets...")
abbvie.tweets = searchTwitter('@abbvie', n=TWEET_LIMIT)
save(abbvie.tweets, file=file.path(dataDir, 'abbvie.tweets.RData' ), ascii=T)


