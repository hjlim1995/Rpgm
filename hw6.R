setwd("c://data")
cluster1 <- read.csv("ch3_cluster.csv")
cluster1
library(cluster)
hcl1 <- hclust(dist(cluster1)^2, method="single")
plot(hcl1, hang=-1, xlab="student", ylab="distance")

hcl2 <- hclust(dist(cluster1)^2, method="complete")
plot(hcl2, hang=-1, xlab="student", ylab="distance")

hcl3 <- hclust(dist(cluster1)^2, method="average")
plot(hcl3, hang=-1, xlab="student", ylab="distance")

hcl4 <- hclust(dist(cluster1)^2, method="centroid")
plot(hcl4, hang=-1, xlab="student", ylab="distance")

hcl5 <- hclust(dist(cluster1)^2, method="ward.D2")
plot(hcl5, hang=-1, xlab="student", ylab="distance")

library(graphics)
kms <- kmeans(cluster1, 5); kms
plot(cluster1, col=kms$cluster)

wss<-0
for(i in 1:10) wss[i] <- sum(kmeans(cluster1, centers=i)$withinss)
wss
plot(1:10, wss, type="b", xlab="Number of Clusters", 
     ylab="Within group sum of squares")
