#load in the data
mydata = read.table("data/WDIData.csv",sep=",",header=TRUE)
country_code = read.table("data/WDICountry.csv",sep=",",header=TRUE)

mydata = mydata[,1:63]
all_var = unique(mydata[,3:4])

africa = c("DZA", "AGO", "BEN", "BWA", "BFA", "BDI","CMR","CPV",
                 "CAF","COM","COD","DJI","EGY","GNQ","ERI","ETH","GAB","GMB",
                 "GHA","GIN","GNB","CIV","KEN","LSO","LBR","LBY","MDG","MWI",
                 "MLI","MRT","MUS","MAR","MOZ","NAM","NER","NGA","COG","REU",
                 "RWA","SHN","STP","SEN","SYC","SLE","SOM","ZAF","SSD","SDN",
                 "SWZ","TZA","TGO","TUN","UGA","ESH","ZMB","ZWE")

africa_data = subset(mydata,mydata$Country.Code %in% africa)
africa_countries_in_WDI = dim(unique(africa_data[,1:2]))[1]
africa_variables = unique(africa_data[,3:4])

#see if any columns are missing any data
allmisscols = sapply(africa_data, function(x) all(is.na(x) | x == '' ))

#remove all rows without only NA values
africa_data = africa_data[rowSums(is.na(africa_data[,5:64])) != ncol(africa_data[,5:64]),]
