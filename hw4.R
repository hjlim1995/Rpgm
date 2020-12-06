setwd("c://data")
entropy21<-read.csv("21entropy.csv")
head(entropy21)
entropy22<-read.csv("22entropy.csv")
head(entropy22)


#정보엔트로피를 구하는 함수 
info_entropy <- function(x) { 
  
  factor_x <- factor(x) 
  entropy <- 0 
  for(str in levels(factor_x)) {
    pro <- sum(x == str) / length(x) 
    entropy <- entropy - pro * log2(pro) 
  }
  return (entropy)
}

x1<-entropy21$나이
y1<-entropy21$차량보유여부
x2<-entropy22$나이
y2<-entropy22$차량보유여부

info_entropy(x1)
info_entropy(y1)
info_entropy(x2)
info_entropy(y2)

tree<-read.csv("Decision Tree.csv")
#install.packages("rpart")
library(rpart)
head(tree)

tree1<-rpart(담배여부~., data=tree, control=rpart.control(minsplit=2))
tree1
plot(tree1, compress=T, uniform=T, margine=0.1)
text(tree1, use.n=T, col="blue")
