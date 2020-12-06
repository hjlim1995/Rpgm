setwd("C://data")
ch1 <- read.csv("ch1_things.csv")
head(ch1)
ch2<-ch1[-1]
head(ch2)
m<-t(as.matrix(ch2)) %*% as.matrix(ch2)
m
dist_ch2<-dist(m, method="euclidean")
dist_ch2
two_coord<-cmdscale(dist_ch2)
two_coord
plot(two_coord, type="n")
text(two_coord, rownames(m))
