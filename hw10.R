setwd("C://data")
kprice <- read.csv("kprice.csv")
kprice

library(forecast)
fit <- auto.arima(ts((kprice$k_price), frequency=52), seasonal=TRUE)
fit
plot(forecast(fit, h=50))

k_price <- as.integer(kprice$k_price)
k_log <- log(k_price)
head(k_log)

library(KernSmooth)
gridsize1 <- length(k_price)
bw1 <- dpill(1:gridsize1, k_price, gridsize=gridsize1)
lp1 <- locpoly(x=1:gridsize1, y=k_price, bandwidth=bw1,
               gridsize=gridsize1)
smooth1 <- lp1$y
plot(k_price, type="l")
lines(smooth1, lty=2)

gridsize <- length(k_log)
bw <- dpill(1:gridsize, k_log, gridsize=gridsize)
lp <- locpoly(x=1:gridsize, y=k_log, bandwidth=bw,
               gridsize=gridsize)
smooth <- lp$y
plot(k_log, type="l")
lines(smooth, lty=2)
