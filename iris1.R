library(nnet)
data(iris)
iris.scaled <- cbind(scale(iris[-5]), iris[5])
index <- c(sample(1:150,105))
train <- iris.scaled[index,]
test <- iris.scaled[-index,]
model.nnet <- nnet(Species~., data=train, size=2)
pre <- predict(model.nnet, test, type="class")
actual <- test$Species
table(actual, pre)
                     