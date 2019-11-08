library(reshape)
library(reshape2)
library(ggplot2)
library(lattice)
library(GGally)

data = read.table("finaldataset.csv",sep=",",header=TRUE)
dataset <- read.table("aanvullingprimary.csv",header=TRUE,sep=";")
x= dataset$School.enrollment..primary....net.[0:78]

data$School.enrollment..primary....net. = x
data = data[,2:10]

data = na.omit(data)
# corrdata = data[,3:10]

#remove all na data for test
data = na.omit(data)	

write.csv(data, file = "testdata.csv")
#create correlation plot between variables
ggpairs(data[,2:9], aes())

