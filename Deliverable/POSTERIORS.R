library(scales)
#43 countries
dataset = read.table("testdata.csv", sep = ",", header = TRUE, stringsAsFactors = FALSE)
code <- dataset$Country.Code
PRM <- log(dataset$School.enrollment..primary....net.)
n <- length(PRM)

intercept <- rep(1,n)

# 200 runs by 2 parameters
model_runs = read.table("data/modelruns.csv", sep = ",", header = TRUE)
model_runs <- as.matrix(model_runs)

# 2 parameters by 43 nations
design_matrix <- t(cbind(intercept, PRM))

p <- model_runs %*% design_matrix
posteriors <- as.data.frame(p)
names(posteriors) <- code

write.csv(posteriors,"posteriors.csv",row.names = FALSE)
