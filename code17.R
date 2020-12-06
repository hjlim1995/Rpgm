setwd("C://data")
cardh <- read.csv('card_history.csv' , header = T , stringsAsFactors = F) 

a = hist(cardh$�ķ�ǰ,freq=F)
a
x <- a$density #density=relative frequency/class interval(5000)
y <- a$counts/sum(a$counts) #relative frequency
x
y

hist(cardh$�ķ�ǰ)
hist(cardh$�ķ�ǰ, freq=F)

par(mfrow=c(3,2)) 
plot(density(cardh$�ķ�ǰ) , main = "�ķ�ǰ")
plot(density(cardh$�Ǻ�) , main = "�Ǻ�")
plot(density(cardh$�ܽĺ�) , main = "�ܽĺ�")
plot(density(cardh$å��) , main = "å��")
plot(density(cardh$�¶��μҾװ���) , main = "�¶��μҾװ���")
plot(density(cardh$�Ƿ��) , main = "�Ƿ��")

cardh[abs(mean(cardh$�ķ�ǰ) - cardh$�ķ�ǰ) > sd(cardh$�ķ�ǰ),]
cardh[abs(mean(cardh$�¶��μҾװ���) - cardh$�¶��μҾװ���) > 1.5 * sd(cardh$�¶��μҾװ���),]

card_history <- read.csv('card_history2.csv' , header = T , stringsAsFactors = F) 
head(card_history)

library(reshape2) 
card_history <- card_history[-1] 

card2 <- melt(id = 1 , card_history , na.rm = TRUE) 
card2 <- subset(card2 , value != 'N') 
colnames(card2)[2:3] <- c("WEEK" , "FOOD")
card2$FOOD
card2[card2$FOOD == 'Y',"FOOD"] <- "N"

card2[card2$FOOD == 'F',"FOOD"] <- "Y" 
head(card2) 

library(class)
card2$WEEK <- as.integer(card2$WEEK)
knnpred1 <- knn(card2[1:2] , card2[1:2] , card2$FOOD , k=2 , prob = TRUE) 
table(knnpred1 , card2$FOOD)

test <- data.frame(TIME=c(15,16,17) , WEEK = c(4,4,4))
knnpred2 <- knn(card2[1:2] , test , card2$FOOD , k=5 , prob = TRUE) 
attributes(knnpred2)$prob > 0.65

library(corrplot)
prob <- read.csv('prob3.csv' , header = T , stringsAsFactors = F)
prob <- prob[-1]
cor(prob) 
corrplot(cor(prob))

prob$total_score <- prob$������ + prob$�����
hist(prob$total_score, freq=F)
lines(density(prob$total_score))
plot(density(prob$total_score) , main ="TOTAL SCORE")
prob[abs(mean(prob$total_score) - prob$total_score) > sd(prob$total_score),]

m1 <- lm(������ ~ ����� , data = prob) 
rstudent(m1)

library(car) 
outlier.test(m1)
outlierTest(m1)

write.csv(prob, "prob3.csv")