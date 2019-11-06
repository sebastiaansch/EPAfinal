library(reshape)
library(reshape2)
library(ggplot2)
library(lattice)
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

main_data = subset(africa_data,africa_data$Indicator.Code %in% all_var$Indicator.Code)
inspect = main_data # Open this to quickly observe missing data

main_idx <- match(c("Country.Code","Indicator.Code","X2015","X2016","X2017","X2018"), names(main_data))

# peel off only the column we want from that year
main_data <- main_data[,main_idx]

# give columns a name to easily assess
names(main_data) <- c("Country","Indicator","2015","2016","2017","2018")
# specify the ids(indicators) and measures (variables for retrieval)
combined_melt = melt(main_data, id=c("Country","Indicator","2015","2016","2017","2018"))

##Reshape. we want country.code in rows, indicator.code in columns 
# Cast: put variables in the columns. Keep country in the rows 
# CHANGE year to select the desired year (2015-2018)
combined_cast= cast(combined_melt, value='2015', formula = Country  ~ Indicator)
names(combined_cast) <- c("CountryCode", names_indicators)


