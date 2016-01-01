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
myStopwords <- c('can', 'now','will','berkshire','say','one','way','use','berkshire','hathaway','berkshires','also','howev','tell','business','from','the','that','and','for','have','berkshir','year','years','company','last','however','many','every','made','next')
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