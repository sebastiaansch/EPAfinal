# Read the data in correctly
# Removed the file encoding because it resulted in an error
mydata_utf8 = read.table("data/WDIData.csv",sep=",",header=TRUE)
country_code = read.table("data/country_code.csv",sep=",",header=TRUE)
# drop off the final blank column
mydata = mydata_utf8[,1:63]

dim(mydata)
all_code = unique(mydata[,1:2])
all_var = unique(mydata[,3:4])

# find the right variables
my_var = c("IT.NET.BBND","NY.GDP.MKTP.CD","SP.POP.TOTL","IT.CEL.SETS","IS.RRS.TOTL.KM")
# subset the data
country_data = subset(mydata,mydata$Country.Code %in% country_code$Country.Code)
main_data = subset(country_data,country_data$Indicator.Code %in% my_var)

# find the columns with the year we want
main_idx <- match(c("Country.Code","Indicator.Code","X2010"), names(mydata))
# peel off only the column we want from 2013
main_data <- main_data[,main_idx]

urban_idx <- match(c("Country.Code","Indicator.Code","X2010"), names(mydata))
urban_data = subset(country_data,country_data$Indicator.Code %in% "AG.LND.TOTL.UR.K2")
urban_data = urban_data[,urban_idx]

names(main_data) <- c('Country','Indicator','Value')
names(urban_data) <- c('Country','Indicator','Value')
combined_data = rbind(main_data,urban_data)

library('reshape')
combined_melt = melt(combined_data, id=c("Country","Indicator","Value"))
combined_cast=cast(combined_melt, value = "Value", Country ~ Indicator)

bbdata <- na.omit(combined_cast)
dim(bbdata)
row.names(bbdata) <- 1:nrow(bbdata)
names(bbdata) <- c("country","agri_land","urban","rail","bbnd","gdp","pop")

write.csv(bbdata,"data/bbdata.csv")

