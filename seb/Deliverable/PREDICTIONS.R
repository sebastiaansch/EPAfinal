library(scales)

# model parameters with noisy intercepts
model_runs <- read.table("data/modelruns.csv",header=TRUE,sep=",")

# load in the data
dataset = read.table("testdata.csv", sep = ",", header = TRUE)
code <- dataset$Country.Code
GPI <- log(dataset$Gender.Parity.Index..GPI.)
PRM <- log(dataset$School.enrollment..primary....net.)

plot(GPI,PRM,ylim =c(2,8))
text(GPI,PRM,labels=code,cex=0.75) 
for (i in 32000:32200) {
  abline(model_runs[i,1],model_runs[i,2],col=alpha("blue",0.1))
}
 
