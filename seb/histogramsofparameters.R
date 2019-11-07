library(scales)
library(lattice)
# load in the coda matrix of model runs
# this consists of slope, intercept, and noise
model_runs = read.table("data/modelrunsprimary.csv", sep = ",", header = TRUE)

# load in the data
dataset <- read.table("testdata.csv",header=TRUE,sep=",")
LPI <- log(dataset$Logistics.performance.index)
AGRI <- log(dataset$Agriculture..forestry..and.fishing..value.added....of.GDP.)
GDP <- log(dataset$GDP.per.capita)
GPI <- log(dataset$Gender.Parity.Index..GPI.)
PRM <- log(dataset$School.enrollment..primary....net.)
MRT <- log(dataset$Low.income.and.Mortality.rate.attributed.to.unsafe.water..unsafe.sanitation.and.lack.of.hygiene)
HLTH <- log(dataset$health.expenditure)
UNDR <- log(dataset$Prevalence.of.undernourishment....of.population.)

# compute the variance
pseudo_r2 <- 1-(model_runs[,3]/sd(LPI))-(model_runs[,4]/sd(AGRI))-(model_runs[,5]/sd(GDP))-(model_runs[,6]/sd(GPI))-(model_runs[,7]/sd(MRT))-(model_runs[,8]/sd(HLTH))-(model_runs[,9]/sd(UNDR))
# set however many sample runs you want to display 
n <- 500

model_runs <- model_runs[1:n,1:3]
hist(model_runs[,1],col=alpha("blue",0.5),breaks=20,main="Intercept",xlab="Value",ylab="Runs")
hist(model_runs[,2],col=alpha("blue",0.5),breaks=10,main="Slope",xlab="Value",ylab="Runs", xlim=c(1.0,2.0))
hist(model_runs[,3],col=alpha("blue",0.5),breaks=16,main="Error",xlab="Value",ylab="Runs")
hist(pseudo_r2,col=alpha("blue",0.5),breaks=16,main="Pseudo R Square",xlab="Value",ylab="Runs")

splom(model_runs)
