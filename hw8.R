setwd("c://data")
kospi <- read.csv("kospi.csv")
S <- read.csv("S_stock1.csv")
H <- read.csv("H_stock1.csv")

plot(kospi$k_rate, type="l", main="KOSPI 1년 등락률")
plot(S$S_rate, type="l", main="삼성전자 1년 등락률")
plot(H$H_rate, type="l", main="하이닉스 1년 등락률")

all_data <- merge(merge(kospi, S), H)
head(all_data)
all_data$id <-1:249
head(all_data)

plot(all_data$k_rate, type="l", xlab="date", ylab="rate")
lines(all_data$S_rate, col="red")
lines(all_data$H_rate, col="blue")

S_lm <- lm(S_rate ~ k_rate, data=all_data)
summary(S_lm)
plot(all_data$k_rate, all_data$S_rate)
abline(S_lm, col="blue")

H_lm <- lm(H_rate ~ k_rate, data=all_data)
summary(H_lm)
plot(all_data$k_rate, all_data$H_rate)
abline(H_lm, col="red")
