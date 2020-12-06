setwd("C://data")

library(readr)
index <- read.csv("knn1.csv")
index
colnames(index) <- c("wkend", "breakfast", "lunch", "dinner", "out" )
index
test <- data.frame(wkend=80, breakfast=15, lunch=20, dinner=90)
test


library(class)
train <- index[,-5]
group <- index[,5]
train
group
pred1 <- knn(train, test, group, k=4, prob=TRUE)
pred1
pred2 <- knn(train, test, group, k=5, prob=TRUE)
pred2
