broadband <- read.table("data/broadband_access1.csv",header=TRUE,sep=",")

linearMod <- lm(bbnd ~ urb, data=broadband)  # build linear regression model on full data
print(linearMod)
summary(linearMod)
