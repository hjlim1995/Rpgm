setwd("C://data")
library(zoo) 
library(urca) 
cj <- read.zoo("cj.csv" , sep = "," ,  header = TRUE , format = "%Y-%m-%d") 
cj2 <- scale(cj) 
head(cj2)

(cj2$c_food - mean(cj2$c_food)) / sd(cj2$c_food)

simple_mod <- lm(diff(cj2$c_food) ~ diff(cj2$s_food)+0)
summary(simple_mod) 
plot(cj2$c_food , main = "FOOD STOCK" , xlab = "Date" , ylab = "Price") 
lines(cj2$s_food , col = "blue") 

c_adf <- ur.df(cj2$c_food , type = "drift") 
summary(c_adf) #--> ������ 

s_adf <- ur.df(cj2$s_food , type = "drift") 
summary(s_adf) #--> ������ 

reg1 <- summary(lm(cj2$c_food ~ cj2$s_food)) 
error <- residuals(reg1) 
error_df <- ur.df(error ,type = "none") #--> ���� 
summary(error_df)

#ECM(Error-Correction Model) ���������� 
d_c <- diff(cj2$c_food) 
d_s <- diff(cj2$s_food) 
error_lag <- lag(error , k = 1) 
reg2 <- lm(d_c ~ d_s + error_lag + 0) 
summary(reg2) 

#library(Quandl) 
#IT <- Quandl('DAROCZI/IT' , start_date = "2010-01-01" , end_date = "2016-05-22")  
#test <- IT[-1]

######################��Ʈ������ ���ڼ�#####################
cj_df <- as.data.frame(cj)
return <- log(tail(cj_df , -1) / head(cj_df , -1)) 
Q <- cov(return)
n <- ncol(cj_df) 
r <- colMeans(cj_df) 
Q1 <- rbind(Q , rep(1,n) , r) 
Q2 <- cbind(Q1 , rbind(t(tail(Q1 , 2)) , matrix(0,2,2))) 
rbase <- seq(min(r) , max(r) , length = 100) 

s <- sapply(rbase , function(x) {
  y <- head(solve(Q2 , c(rep(0,n) , 1 , x)) , n)
  y %*% Q %*% y 
})
plot(s , rbase , xlab = "Variance" , ylab = "Return")  
############################################################

library(timeSeries)
CJ <- timeSeries(cj_df , rownames(cj_df))
CJ_return <- returns(CJ) 
library(PerformanceAnalytics)
x11();chart.CumReturns(CJ_return , legend.loc = "topleft" , main = "")

library(fPortfolio) 
plot(portfolioFrontier(CJ_return))

#�ٽ� ����#
kospi <- read.zoo("kospi2.csv" , sep = "," ,  header = TRUE , format = "%Y-%m-%d") 
food <- read.zoo("food2.csv" , sep = "," ,  header = TRUE , format = "%Y-%m-%d") 
food_df <- as.data.frame(food)
plot(food) 
food2 <- scale(food) 

sampyo_adf <- ur.df(food2$sampyo , type = "drift")
summary(sampyo_adf) #-->������ 

seoul_adf <- ur.df(food2$seoul , type = "drift") 
summary(seoul_adf) #-->������ 

reg2 <- summary(lm(food2$sampyo ~ food2$seoul)) 
error2 <- residuals(reg2) 
error_df2 <- ur.df(error2 ,type = "none") #--> ���� ==> ��ǥ��ǰ�� �����ǰ�� �����а���
summary(error_df2)

return2 <- function(x) diff(x) / lag(x , -1) * 100 
food_ret <- return2(food) 
#Beta index 
samlip_beta <- lm(food_ret$samlip ~ food_ret$kospi)$coefficient[[2]]
samyang_beta <- lm(food_ret$samyang ~ food_ret$kospi)$coefficient[[2]]
sampyo_beta <- lm(food_ret$sampyo ~ food_ret$kospi)$coefficient[[2]]
seoul_beta <- lm(food_ret$seoul ~ food_ret$kospi)$coefficient[[2]]
sinsegye_beta <- lm(food_ret$sinsegye ~ food_ret$kospi)$coefficient[[2]]

library(timeSeries)
food_ts <- timeSeries(food_df , rownames(food_df))
FOOD_return <- returns(food_ts) 
library(PerformanceAnalytics)
x11();chart.CumReturns(FOOD_return , legend.loc = "topleft" , main = "")

library(fPortfolio) 
plot(portfolioFrontier(FOOD_return))


 
 

