library(rjags)

broadband <- read.table("data/broadband_access1.csv",header=TRUE,sep=",")
bbnd <- log(broadband$IT.NET.BBND)
gdp <- log(broadband$NY.GDP.MKTP.CD)
pop <- log(broadband$SP.POP.TOTL)
urb <- log(broadband$AG.LND.TOTL.UR.K2)
land <- log(broadband$AG.LND.TOTL.K2)
rail <- log(broadband$IS.RRS.TOTL.KM)
n <- nrow(broadband)


model_string1 <- "model{

# Priors
beta1 ~ dnorm(0,0.0001)
beta2 ~ dnorm(0,0.0001)
inv_var ~ dgamma(0.1,0.1)
std <- 1/sqrt(inv_var)

# Likelihood
for(i in 1:n){
    mu[i] <- beta1+beta2*urb[i] 
    bbnd[i]   ~ dnorm(mu[i],inv_var)

}

}"

model <- jags.model(textConnection(model_string1), data = list(urb=urb,bbnd=bbnd,n=n))
update(model, 10000, progress.bar="none"); # Burnin for 10000 samples
samp <- coda.samples(model,variable.names=c("beta1","beta2","std"), 
                     n.iter=20000, progress.bar="text")

summary(samp)

model_output<-as.matrix(samp)
saveRDS(samp,"data/modelrun1.RDS")
write.csv(model_output,"data/modelruns.csv",row.names = FALSE)
