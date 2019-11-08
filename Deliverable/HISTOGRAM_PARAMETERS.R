library(scales)
library(lattice)
# load in the coda matrix of model runs
# this consists of slope, intercept, and noise
model_runs = read.table("data/modelruns.csv", sep = ",", header = TRUE)

# load in the data
dataset <- read.table("testdata",header=TRUE,sep=",")
GPI <- log(dataset$Gender.Parity.Index..GPI.)

# compute the variance
sd<-sd(GPI)
pseudo_r2 <- 1-model_runs[,8]/sd
# set however many sample runs you want to display 
n <- 500

model_runs1 <- model_runs[1:n,1]
model_runs2 <- model_runs[1:n,8]
model_runs3 <- model_runs[1:n,9]

model_runs = rbind(model_runs1, model_runs2 ,model_runs3)
hist(model_runs[1,],col=alpha("blue",0.5),breaks=20,main="Intercept",xlab="Value",ylab="Runs")
hist(model_runs[2,],col=alpha("blue",0.5),breaks=10,main="Slope GPI",xlab="Value",ylab="Runs", xlim=c(1.0,2.0))
hist(model_runs[3,],col=alpha("blue",0.5),breaks=16,main="Error",xlab="Value",ylab="Runs")
hist(pseudo_r2,col=alpha("blue",0.5),breaks=16,main="Pseudo R Square",xlab="Value",ylab="Runs")

splom(model_runs[1:1000,])
