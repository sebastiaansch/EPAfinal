library(rjags)
samp=readRDS("data/modelruns.rds")

summary(samp)
#traceplot(samp)

# sometimes the gelman plot won't fit on a screen
# we have to reduce the margins
par(mar=c(.4,.4,.4,.4))
gelman.plot(samp)
gelman.diag(samp)
densplot(samp)
acfplot(samp)

# get the effective sample size
effectiveSize(samp)

