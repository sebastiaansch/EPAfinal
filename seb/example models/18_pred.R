library(scales)

# model parameters with noisy intercepts
model_runs <- read.table("data/noisymodelruns.csv",header=TRUE,sep=",")

# load in the data
broadband = read.table("data/broadband_access1.csv", sep = ",", header = TRUE)
code <- broadband$Country.Code
bbnd <- log(broadband$IT.NET.BBND)
urb <- log(broadband$AG.LND.TOTL.UR.K2)

plot(urb,bbnd,ylim =c(5,20))
text(urb,bbnd-1,labels=code,cex=0.75) 
for (i in 1:200) {
  abline(model_runs[i,1],model_runs[i,2],col=alpha("blue",0.1))
}
 