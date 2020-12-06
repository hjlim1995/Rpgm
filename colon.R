library(survival)
str(colon)
colon1 <- na.omit(colon)
attach(colon1)
extent<-as.factor(extent)
str(colon1)
result <- glm(status~sex+age+obstruct+perfor+adhere+nodes+differ+extent+surg,family=binomial,data=colon1)
summary(result)
result1 <- glm(status~adhere+nodes+extent+surg,family=binomial,data=colon1)
summary(result1)

reduced.model=step(result, direction="backward")
summary(reduced.model)

#오즈비 출력함수 정의
ORtable=function(x, digits=2){
  suppressMessages(a<-confint(x))
  result = data.frame(exp(coef(x)),exp(a))
  result = round(result,digits)
  result = cbind(result,round(summary(x)$coefficient[,4],3))
  colnames(result) = c("OR","2.5%","97.5%","P")
  result
}
ORtable(reduced.model)

#오즈비 시각화
library(moonBook)
odds_ratio=ORtable(reduced.model)
odds_ratio=odds_ratio[2:nrow(odds_ratio),]
HRplot(odds_ratio, type=2, show.CI=TRUE, cex=2)

predict(reduced.model , colon1 , type = "response")
predict(reduced.model , colon1 , type = "response") > 0.5
table(colon1$status , predict(reduced.model , colon1 , type = "response") > 0.5)


predict(result, colon1 , type = "response")
predict(result , colon1 , type = "response") > 0.5
table(colon1$status , predict(result , colon1 , type = "response") > 0.5)


predict(result1, colon1 , type = "response")
predict(result1, colon1 , type = "response") > 0.5

table(colon1$status , predict(result1 , colon1 , type = "response") > 0.5)


sum(is.na(colon))
sum(is.na(colon1))

library(caret)
rn<-createDataPartition(y=colon1$status, p=0.7, list=F)
head(rn)
rn[1:10,]

train<-colon[rn,]
test<-colon[-rn,]
table(train$status)
table(test$status)


library(survival)
str(train)
train1 <- na.omit(train)
result1 <- glm(status~sex+age+obstruct+perfor+adhere+nodes+differ+extent+surg,family=binomial,data=train1)
summary(result1)
result2 <- glm(status~adhere+nodes+extent+surg,family=binomial,data=train1)
summary(result2)

reduced.model=step(result, direction="backward")
summary(reduced.model)

#test$model_prob <- predict(result2, test , type = "response")
test$model_prob1 <- round(predict(result2 , test, type = "response")) 
table(test$status , round(predict(result2 , test , type = "response")))
table(test$status , predict(result2 , test , type = "response") > 0.5)

##########################################
library(dplyr)
test<-test %>% mutate(model_pred=1*(test$model_prob>0.5)+0)
test<-test %>% mutate(accurate = 1*(test$model_pred==test$status))
a<-table(test$accurate[test$accurate==1])
sum(a)/nrow(test)
##########################################
