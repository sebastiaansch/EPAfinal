library(scales)
#the data consists of total broadband accounts across 93 countries
broadband = read.table("data/broadband_access1.csv", sep = ",", header = TRUE, stringsAsFactors = FALSE)
code <- broadband$Country.Code
urb <- log(broadband$AG.LND.TOTL.UR.K2)
n <- length(urb)

intercept <- rep(1,n)

# 200 runs by 2 parameters
model_runs = read.table("data/noisymodelruns.csv", sep = ",", header = TRUE)
model_runs <- as.matrix(model_runs)

# 2 parameters by 93 nations
design_matrix <- t(cbind(intercept, urb))

p <- model_runs %*% design_matrix
posteriors <- as.data.frame(p)
names(posteriors) <- code

write.csv(posteriors,"data/posteriors.csv",row.names = FALSE)
