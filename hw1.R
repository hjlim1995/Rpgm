setwd("c://data")
ex1<-read.csv("ex.csv")
ex1
write.csv(ex1,"ex2.csv")

ex2<-read.csv("ex2.csv")
ex3<-ex2[-1]
