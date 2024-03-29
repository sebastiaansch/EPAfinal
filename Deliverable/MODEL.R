library(rjags)

# broadband <- read.table("data/broadband_access1.csv",header=TRUE,sep=",")
dataset <- read.table("testdata.csv",header=TRUE,sep=",")
any(is.na(dataset))
# bbnd <- log(broadband$IT.NET.BBND)
# gdp <- log(broadband$NY.GDP.MKTP.CD)
# pop <- log(broadband$SP.POP.TOTL)
# urb <- log(broadband$AG.LND.TOTL.UR.K2)
# land <- log(broadband$AG.LND.TOTL.K2)
# rail <- log(broadband$IS.RRS.TOTL.KM)
# n <- nrow(broadband)

LPI <- log(dataset$Logistics.performance.index)
AGRI <- log(dataset$Agriculture..forestry..and.fishing..value.added....of.GDP.)
GDP <- log(dataset$GDP.per.capita)
GPI <- log(dataset$Gender.Parity.Index..GPI.)
PRM <- log(dataset$School.enrollment..primary....net.)
MRT <- log(dataset$Low.income.and.Mortality.rate.attributed.to.unsafe.water..unsafe.sanitation.and.lack.of.hygiene)
HLTH <- log(dataset$health.expenditure)
UNDR <- log(dataset$Prevalence.of.undernourishment....of.population.)
n <- nrow(dataset)


model_string1 <- "model{

# Generate priors for beta
for(j in 1:8){
    beta[j] ~ dnorm(0,0.0001)
}
  
# Priors
inv_var ~ dgamma(0.1,0.1)
std <- 1/sqrt(inv_var)

# Likelihood
for(i in 1:n){
    mu[i] <- beta[1]+beta[2]*LPI[i]+beta[3]*AGRI[i]+beta[4]*GDP[i]+beta[5]*MRT[i]+beta[6]*HLTH[i]+beta[7]*UNDR[i]+beta[8]*GPI[i]
    PRM[i] ~ dnorm(mu[i],inv_var)
}

}"
data_jags = list(LPI=LPI,AGRI=AGRI,
                 GPI=GPI,GDP=GDP,
                 PRM=PRM,MRT=MRT,
                 HLTH=HLTH
                 ,UNDR=UNDR,n=n)
model <- jags.model(textConnection(model_string1), data = data_jags, n.chains = 9)
update(model, 10000, progress.bar="none"); # Burnin for 10000 samples due to model needing startup

samp <- coda.samples(model,variable.names=c("beta[1]","beta[2]",
                                            "beta[3]","beta[4]",
                                            "beta[5]","beta[6]",
                                            "beta[7]","beta[8]",
                                            "std"), 
                     n.iter=20000, progress.bar="text")

summary(samp)

model_output<-as.matrix(samp)
saveRDS(samp,"data/modelruns.RDS")
write.csv(model_output,"data/modelruns.csv",row.names = FALSE)

summary(model)

plot(samp)

# fit <- lm(PRM~LPI+AGRI
#           +GPI+GDP
#           +MRT
#           +HLTH+UNDR)
# summary(fit)
