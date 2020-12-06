
setwd("C://data")
k_index <- read.csv("K_index.csv" , header = T , stringsAsFactors = F)
s_stock <- read.csv("S_stock.csv" , header = T , stringsAsFactors = F)
h_stock <- read.csv("H_stock2.csv" , header = T , stringsAsFactors = F)
all_data <- merge(merge(k_index , s_stock) , h_stock) 
head(all_data)
str(all_data)

#100일간의 일별변동량 비교와 산점도
all_data$idx <- 1:249
attach(all_data) 
plot(idx[2:100] , k_rate[2:100] , type = "l" , xlab = "date" , ylab = "rate")
lines(idx[2:100] , s_rate[2:100] , col="red")
abline(h=mean(k_rate[2:100]) , lty=2 , col="black") 
abline(h=mean(s_rate[2:100]) , lty=2 , col="blue") 

plot(k_rate , s_rate) 
s_lm <- lm(s_rate ~ k_rate , data = all_data) 
h_lm <- lm(h_rate ~ k_rate , data = all_data) 
abline(s_lm, col="red")
plot(k_rate , h_rate) 
abline(h_lm, col="blue")
summary(s_lm) 
summary(h_lm) 

