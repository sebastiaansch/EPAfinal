library(reshape)
library(reshape2)
library(ggplot2)
library(lattice) # matrix scatterplot

#set working directory
getwd()

#remove variables in environment 
rm(list=ls())

# Read the data
mydata_utf8 = read.table("data/WDIData.csv",sep=",",fileEncoding="UTF-8-BOM",header=TRUE)  
#country_code = read.table("country_code.csv",sep=",",header=TRUE)

# drop off the final blank column
mydata = mydata_utf8[,1:63]

# show scale of the data
dim(mydata)
all_code = unique(mydata[,1:2])
all_var = unique(mydata[,3:4])

# create a list with the desired variables. To do: How to keep the order?
my_var = c('AG.LND.ARBL.HA.PC', "NY.GDP.PCAP.KD", "SE.COM.DURS", "SE.PRM.ENRR", "SE.PRM.NENR","SL.AGR.0714.FE.ZS","SL.AGR.0714.MA.ZS","SL.AGR.0714.ZS","SL.TLF.0714.MA.ZS", "SL.TLF.0714.SW.TM")

# Make a list with the corresponding names of the variables (to match columns with variable names after reshaping the data)
names_indicators = c('Arable Land','GDP','PriS_1', 'PriS_2', 'Comp_Edu', 'Agri_F', 'Agri_M', 'Agri_All','Children employment male', 'Average working hours children')

# To do: Would be easier to automatically match indicator code with desired indicator name
#"SE.PRM.ENRR" = primary school,
#"SE.PRM.NENR" = primary school 2
#"SL.AGR.0714.ZS" = agri all -->MISSING DATA
#"SL.AGR.0714.MA.ZS" = agri male -> MISSING DATA
#"SL.AGR.0714.FE.ZS" = agri female --> MISSING DATA
#"SL.TLF.0714.MA.ZS") = male children employment
#"SE.COM.DURS") = compulsory education (duration, years)
#"SL.TLF.0714.SW.TM" = average working hours male
#"NY.GDP.PCAP.KD" = GDP
#'AG.LND.ARBL.HA.PC' = arable land

# create a list with all african countries
my_countries = c("DZA", "AGO", "BEN", "BWA", "BFA", "BDI","CMR","CPV","CAF","COM","COD","DJI","EGY","GNQ","ERI","ETH","GAB","GMB","GHA","GIN","GNB","CIV","KEN","LSO","LBR","LBY","MDG","MWI","MLI","MRT","MUS","MAR","MOZ","NAM","NER","NGA","COG","REU","RWA","SHN","STP","SEN","SYC","SLE","SOM","ZAF","SSD","SDN","SWZ","TZA","TGO","TUN","UGA","ESH","ZMB","ZWE")

# subset the data 
# select only african countries
country_data = subset(mydata,mydata$Country.Code %in% my_countries)

# select only variables of interest. 
# Find out how to keep order of Var.
main_data = subset(country_data,country_data$Indicator.Code %in% my_var)
inspect = main_data # Open this to quickly observe missing data

# find the columns with the year we want. match returns index of columns of interest
main_idx <- match(c("Country.Code","Indicator.Code","X2015"), names(mydata))

# peel off only the column we want from that year
main_data <- main_data[,main_idx]

# give columns a name to easily assess
names(main_data) <- c("Country","Indicator","Value")
# specify the ids(indicators) and measures (variables for retrieval)
combined_melt = melt(main_data, id=c("Country","Indicator","Value"))

##Reshape. we want country.code in rows, indicator.code in columns 
# Cast: put variables in the columns. Keep country in the rows 
combined_cast= cast(combined_melt, value='Value', formula = Country  ~ Indicator)
names(combined_cast) <- c("CountryCode", names_indicators)

# create a matrix of scatter plot to inspect correlation between selected variables

# select the desired variables (defined in names_indicators)
my_matrix <- combined_cast[,names_indicators]

# create a scatter plot matrix
splom(my_matrix)

# create a barplot to visualize data:GDP
p<-ggplot(data= combined_cast, aes(x=CountryCode, y=GDP)) +
  geom_bar(stat="identity") +
  theme(axis.text.x = element_text(angle = 90))
p

# create a barplot to visualize data: Primary School
p<-ggplot(data= combined_cast, aes(x=CountryCode, y=PriS_1)) +
  geom_bar(stat="identity") +
  theme(axis.text.x = element_text(angle = 90))
p

# create scatter plot to check correlation between variables
p<-ggplot(data= combined_cast, aes(x=PriS_1, y=GDP)) +
  geom_point(stat="identity") 
p

##  To do: addressing missing data
## Use when for example one variable has data in 2010 and another in 2011
#pri_school_idx <- match(c("Country.Code","Indicator.Code","X2016"), names(mydata))
#pri_school_data = subset(country_data,country_data$Indicator.Code %in% "SE.PRM.ENRR")
#pri_school_data = pri_school_data[,pri_school_idx]

## combine two data sets
#names(pri_school_data) <- c("Country","Indicator","Value")
#combined_data = rbind(main_data, pri_school_data)

#bbdata <- na.omit(combined_cast) 
#dim(bbdata)

#row.names(bbdata) <- 1:nrow(bbdata)
#names(bbdata) <- names_indicators

#write data to CSV file
#write.csv(bbdata,"bbdata.csv")







