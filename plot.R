library(reshape2)
library(ggplot2)

data <-read.csv(text=readLines("/home/raj/projects/topicModels/output_csv/TopicsInDocs.csv")[-(1:1)],sep=",",header=F)
d<-data.frame(substr(as.character(data$V2),39,42),data$V3,data$V5,data$V7)
colnames(d)<-c("year","topic1","topic2","topic3")
rownames(d)<-d$year

ggplot() +
geom_point(data=d,aes(x=year,y=topic1,col='1st topic'))+
geom_point(data=d,aes(x=year,y=topic2,col='2nd topic'))+
geom_point(data=d,aes(x=year,y=topic3,col='3rd topic'))+
ylab('Topics')+xlab('Year')+labs(col="Legend")




##### MDS
library(ggplot2)
library(grid)

add_credits = function(fontsize = 10) {
  grid.text("@mobileraj1   mobileraj.github.io",
            x = 0.99,
            y = 0.02,
            just = "right",
            gp = gpar(fontsize = fontsize, col = "#777777"))
}
data<-read.csv('Topics.csv',sep=',',header=T)
d<-data.frame(data$topic1,data$topic2,data$topic3,data$topic4,data$topic5)
rownames(d)<-data$year
dm <- dist(d)
head(dm)
fit<-cmdscale(dm,eig=T,k=2)
x <- fit$points[,1]
y <- fit$points[,2]
mds_frame <- data.frame(x,y,row.names(d))
colnames(mds_frame)<-c('x','y','yr')
png("DistPlot.png")
ggplot()+ggtitle("Chairman letter over the years")+geom_text(data=mds_frame,aes(x=x,y=y,label=yr,family="Trebucket MS"))+
theme(axis.text.y=element_blank(),axis.text.x=element_blank(),plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=12, hjust=0))+xlab("")+ylab("")
add_credits()
dev.off()

