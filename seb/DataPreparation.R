#load in the data
mydata = read.table("data/WDIData.csv",sep=",",header=TRUE)
country_code = read.table("data/WDICountry.csv",sep=",",header=TRUE)

all_code = unique(mydata[,1:2])
all_var = unique(mydata[,3:4])

africa = c("DZA", "AGO", "BEN", "BWA", "BFA", "BDI","CMR","CPV",
                 "CAF","COM","COD","DJI","EGY","GNQ","ERI","ETH","GAB","GMB",
                 "GHA","GIN","GNB","CIV","KEN","LSO","LBR","LBY","MDG","MWI",
                 "MLI","MRT","MUS","MAR","MOZ","NAM","NER","NGA","COG","REU",
                 "RWA","SHN","STP","SEN","SYC","SLE","SOM","ZAF","SSD","SDN",
                 "SWZ","TZA","TGO","TUN","UGA","ESH","ZMB","ZWE")
