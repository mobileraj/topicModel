library(tm)
setwd("/home/raj/projects/topicModels/topics")
fi <- list.files(getwd(),pattern="*.txt")
foo <- lapply(fi,readLines)
docs<-Corpus(VectorSource(foo))
writeLines(as.character(docs[[3]]))
docs<-tm_map(docs,content_transformer(tolower))
toSpace<- content_transformer(function(x,pattern) { return (gsub(pattern," ",x))})
docs<-tm_map(docs,toSpace,"-")
docs<-tm_map(docs,toSpace,"'")
docs<-tm_map(docs,toSpace,".")
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removeWords, stopwords(“english”))
docs <- tm_map(docs, stripWhitespace)
writeLines(as.character(docs[[30]]))
docs <- tm_map(docs,stemDocument)
myStopwords <- c('can', "will","berkshire",'say','one','way','use','berkshire',"hathaway","berkshires",'also','howev','tell','business','from','the','that','and','for','have','berkshir')
docs <- tm_map(docs, removeWords, myStopwords)
writeLines(as.character(docs[[30]]))
dtm <- DocumentTermMatrix(docs)
rownames(dtm) <- filenames
freq <- colSums(as.matrix(dtm))
length(freq)
ord <- order(freq,decreasing=TRUE)
freq[ord]
write.csv(freq[ord],”word_freq.csv”)

library(topicmodels)
burnin <- 400
iter <- 200
thin <- 500
seed <-list(2003,5,63,100001,765)
nstart <- 5
best <- TRUE
k <- 5

ldaOut <-LDA(dtm,k, method=”Gibbs”, control=list(nstart=nstart, seed = seed, best=best, burnin = burnin, iter = iter, thin=thin))

ldaOut.topics <- as.matrix(topics(ldaOut))
write.csv(ldaOut.topics,file=paste('LDAGibbs',k,'DocsToTopics.csv'))
ldaOut.terms <- as.matrix(terms(ldaOut,6))
write.csv(ldaOut.terms,file=paste('LDAGibbs',k,'TopicsToTerms.csv'))
topicProbabilities <- as.data.frame(ldaOut@gamma)
write.csv(topicProbabilities,file=paste('LDAGibbs',k,'TopicProbabilities.csv'))

### visualizing ###
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")

setwd("/home/raj/projects/topicModels/topics")
fi <- list.files(getwd(),pattern="*.txt")
foo <- lapply(fi,readLines)
docs<-Corpus(VectorSource(foo))

docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, stripWhitespace)
myStopwords <- c('can', 'will','berkshire','say','one','way','use','berkshire','hathaway','berkshires','also','howev','tell','business','from','the','that','and','for','have','berkshir','year','years','company','last')
docs<- tm_map(docs,removeWords,myStopwords)

dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)

set.seed(1234)
png(filename="wordcloud.png")
wcloud<-wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

dev.off()

png(filename='wordbars.png')
barplot(d[1:10,]$freq, las = 2, names.arg = d[1:10,]$word,
        col ="lightblue", main ="Most frequent words",
        ylab = "Word frequencies")
dev.off()