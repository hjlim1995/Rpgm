
setwd("C://data")
prob <- read.csv("problem.csv" , header=T , stringsAsFactors = F)

for(i in 1:30) { 
  #0에서 1사이의 값으로 바꾼다. 
  prob[i] <- prob[i] * (1/5)
  
}

#정규화 함수
normalize <- function(x) {
  return((x-min(x)) / diff(range(x))) 
}

#sigmoid 
sigmoid <- function(x) {
  return(1 / (1 + exp(-x)))
}

prob$accident2 <- with(prob , ifelse(accident=="suicide" | accident=="violence" , 1 , 0))
head(prob) 

library(nnet) 
#prob <- prob[-31]
m1 <- nnet(accident2 ~ . , data = prob , size=10) 
r1 <- predict(m1 , prob)
head(r1)

cbind(prob$accident2 , r1>0.5)
sum(as.numeric(r1>0.5) != prob$accident2)

###############################################again~!
library(nnet)
prob$accident2 <- with(prob , ifelse(accident=="suicide" | accident=="violence" , 1 , 0))
prob1 <-prob[-31]

index <- c(sample(1:50, 35))
train <- prob1[index,]
test <- prob1[-index,]

m1 <- nnet(accident2 ~ ., data=train, size=10)
r1 <- predict(m1, test)
r11<-ifelse(r1>=0.5,1,0)
rr<-cbind(r1, r11)

act <- test$accident2
table(act, r11)


#같은 방법(다른 패키지) 
install.packages("neuralnet")
library(neuralnet)
xnam <- paste0("ans", 1:30)
fmla <- as.formula(paste("accident2 ~ ", paste(xnam, collapse= "+")))
m2 <- neuralnet(fmla , data = prob , hidden = 10)
plot(m2) 


