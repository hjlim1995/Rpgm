#1
f=function(n){
  sum<-0
  for (i in 1:n)
  sum=sum+i
sum}

f(100)

#2
setwd("c://data")
data1<-read.csv("academy.csv", header=T)
ac<-data1[data1$수학점수평균>=90 & data1$영어점수평균>=90,]
ac

#3
data2<-read.csv("iq.csv")
hist(data2$VIQ, breaks=10, xlab="")
hist(data2$VIQ, breaks=10, xlab="", main="Histogram of VIQ")
hist(data2$VIQ, breaks=10, xlab="VIQ", main="Histogram of VIQ")

#4
boxplot(data2[,c(-1,-2,-6,-7,-8)], main="Boxplots of FSIQ, VIQ, and PIQ")
data2[,c(-1,-2,-6,-7,-8)]
