library(scales)
library(lattice)
# load in the coda matrix of model runs
# this consists of slope, intercept, and noise
model_runs = read.table("data/modelruns.csv", sep = ",", header = TRUE)

# load in the data
broadband <- read.table("data/broadband_access1.csv",header=TRUE,sep=",")
bbnd <- log(broadband$IT.NET.BBND)

# compute the variance
sd<-sd(bbnd)
pseudo_r2 <- 1-model_runs[,3]/sd
# set however many sample runs you want to display 
n <- 500

model_runs <- model_runs[1:n,1:3]
hist(model_runs[,1],col=alpha("blue",0.5),breaks=20,main="Intercept",xlab="Value",ylab="Runs")
hist(model_runs[,2],col=alpha("blue",0.5),breaks=10,main="Slope",xlab="Value",ylab="Runs", xlim=c(1.0,2.0))
hist(model_runs[,3],col=alpha("blue",0.5),breaks=16,main="Error",xlab="Value",ylab="Runs")
hist(pseudo_r2,col=alpha("blue",0.5),breaks=16,main="Pseudo R Square",xlab="Value",ylab="Runs")

splom(model_runs)
