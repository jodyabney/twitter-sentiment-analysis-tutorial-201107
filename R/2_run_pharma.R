library(stringi)
library(scales)
library(dichromat)
asciify <- function(text) { 
    text <- stri_trans_general(text, 'Any-Latin')
    text <- stri_trans_general(text, 'Any-Publishing')
    text <- stri_trans_general(text, 'Latin-Ascii')
    text
}

cleanText <- function(text) {
    Encoding(text) <- "UTF-8"
    text <- iconv(text, "UTF-8", "UTF-8", sub='')
    text <- asciify(text)
}


if (VERBOSE)
{
	print("Extracting text from tweets & calculating sentiment scores")
	flush.console()
}

# obviously, this is not an elegant way to repeat an operation, but
# we do end up with lots of objects in memory to play with (it _is_
# a tutorial, after all :)

novartis.text = laply(novartis.tweets, function(t) t$getText() )
novartis.text <- cleanText(novartis.text)
pfizer.text = laply(pfizer.tweets, function(t) t$getText() )
pfizer.text <- cleanText(pfizer.text)
roche.text = laply(roche.tweets, function(t) t$getText() )
roche.text <- cleanText(roche.text)
sanofi.text = laply(sanofi.tweets, function(t) t$getText() )
sanofi.text <- cleanText(sanofi.text)
merck.text = laply(merck.tweets, function(t) t$getText() )
merck.text <- cleanText(merck.text)
gsk.text = laply(gsk.tweets, function(t) t$getText() )
gsk.text <- cleanText(gsk.text)
jnj.text <- laply(jnj.tweets, function(t) t$getText() )
jnj.text <- cleanText(jnj.text)
astrazeneca.text = laply(astrazeneca.tweets, function(t) t$getText() )
astrazeneca.text <- cleanText(astrazeneca.text)
eli.text = laply(eli.tweets, function(t) t$getText() )
eli.text <- cleanText(eli.text)
abbvie.text <- laply(abbvie.tweets, function(t) t$getText() )
abbvie.text <- cleanText(abbvie.text)


novartis.scores = score.sentiment(novartis.text, pos.words, neg.words, .progress='text')
pfizer.scores = score.sentiment(pfizer.text, pos.words, neg.words, .progress='text')
roche.scores = score.sentiment(roche.text, pos.words, neg.words, .progress='text')
sanofi.scores = score.sentiment(sanofi.text, pos.words, neg.words, .progress='text')
merck.scores = score.sentiment(merck.text, pos.words, neg.words, .progress='text')
gsk.scores = score.sentiment(gsk.text, pos.words, neg.words, .progress='text')
jnj.scores <- score.sentiment(jnj.text, pos.words, neg.words, .progress='text')
astrazeneca.scores = score.sentiment(astrazeneca.text, pos.words, neg.words, .progress='text')
eli.scores = score.sentiment(eli.text, pos.words, neg.words, .progress='text')
abbvie.scores = score.sentiment(abbvie.text, pos.words, neg.words, .progress='text')


novartis.scores$pharma = '01 Novartis (Switzerland)'
pfizer.scores$pharma = '02 Pfizer (USA)'
roche.scores$pharma = '03 Roche Holding (Switzerland)'
sanofi.scores$pharma = '04 Sanofi (France)'
merck.scores$pharma = '05 Merck & Co., Inc. (USA)'
gsk.scores$pharma = '06 GlaxoSmithKline (UK)'
jnj.scores$pharma <- '07 Johnson & Johnson (USA)'
astrazeneca.scores$pharma = '08 AstraZeneca (UK)'
eli.scores$pharma = '09 Eli Lilly & Co. (USA)'
abbvie.scores$pharma = '10 AbbVie (USA)'


all.scores = rbind( novartis.scores, pfizer.scores, roche.scores,
                    sanofi.scores, merck.scores, gsk.scores,
                    jnj.scores, astrazeneca.scores, eli.scores, 
                    abbvie.scores )

if (VERBOSE)
	print("Plotting score distributions")

# ggplot works on data.frames, always
g.hist = ggplot(data=all.scores, mapping=aes(x=score, fill=pharma) )

# add a bar graph layer. Let it bin the data and compute frequencies
# (set binwidth=1 since scores are integers)
g.hist = g.hist + geom_bar( binwidth=1 )

# make a separate plot for each airline
g.hist = g.hist + facet_grid(pharma~.)

# plain display, nice colorblind-safe colors
g.hist = g.hist + theme_bw() + scale_fill_brewer(palette="Paired") +
    ggtitle("Top 10 Global Pharma Companies Twitter Sentiment Analysis\nbased on last 500 tweets as of 22-May-2015 approx. 7:00 AM ET")

print(g.hist)
ggsave(file.path(outputDir, 'twitter_score_histograms.pdf'), g.hist, width=7.5, height=10)


g.merck <- ggplot(data=merck.scores, mapping=aes(x=score))
g.merck <- g.merck + geom_bar( binwidth=1 )
g.merck <- g.merck + theme_bw()
print(g.merck)
ggsave(file.path(outputDir, 'twitter_score_merck.pdf'), g.merck, width=7.5, height=10)


# if (VERBOSE)
# 	print("Comparing Twitter & ACSI data")
# 
# all.scores$very.pos.bool = all.scores$score >= 2
# all.scores$very.neg.bool = all.scores$score <= -2
# 
# all.scores$very.pos = as.numeric( all.scores$very.pos.bool )
# all.scores$very.neg = as.numeric( all.scores$very.neg.bool )
# 
# twitter.df = ddply(all.scores, c('airline', 'code'), summarise, 
#                    very.pos.count=sum( very.pos ), 
#                    very.neg.count=sum( very.neg ) )
# 
# twitter.df$very.tot = twitter.df$very.pos.count + 
#                         twitter.df$very.neg.count
# 
# twitter.df$score = round( 100 * twitter.df$very.pos.count / 
#                                 twitter.df$very.tot )
# 
# require(doBy)
# orderBy(~-score, twitter.df)
# 
# compare.df = merge(twitter.df, acsi.df, by=c('code', 'airline'), 
#                    suffixes=c('.twitter', '.acsi'))
# 
# 
# # build scatter plot
# g.scatter = ggplot( compare.df, aes(x=score.twitter, y=score.acsi) ) + 
# 			      geom_point( aes(color=airline), size=5 ) + 
# 			      theme_bw() + theme( legend.position=c(0.2, 0.85) )
# 
# # have ggplot2 fit and plot a linear model with R's lm() function
# g.fit = g.scatter + geom_smooth(aes(group=1), se=F, method="lm")
# 
# print(g.scatter)
# print(g.fit)
# 
# ggsave(file.path(outputDir, 'twitter_acsi_comparison.pdf'), g.scatter, width=7, height=7)
# ggsave(file.path(outputDir, 'twitter_acsi_comparison_with_fit.pdf'), g.fit, width=7, height=7)
