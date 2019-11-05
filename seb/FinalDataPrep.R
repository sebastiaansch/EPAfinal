library(reshape)
library(reshape2)
library(ggplot2)
library(lattice)
#load in the data
mydata = read.table("data/WDIData.csv",sep=",",header=TRUE)
country = read.table("data/WDICountry.csv",sep=",",header=TRUE)

mydata = mydata[,1:63]
all_var = unique(mydata[,3:4])

low_inc = c("Low income")
middle_inc = c("Lower middle income")

country_low = subset(country,country$Income.Group %in% low_inc)
country_lowmid = subset(country, country$Income.Group %in% middle_inc)

country_low_codes = country_low$Country.Code
country_lowmid_codes = country_lowmid$Country.Code

country_low_data = subset(mydata, mydata$Country.Code %in% country_low_codes)
country_lowmid_data = subset(mydata, mydata$Country.Code %in% country_lowmid_codes)

country_low_data$Income.Group = "Low income"

df_low_data = data.frame(country_low_data)
df_lowmid_data = data.frame(country_lowmid_data)

df_low_data$Income.Group = "Low income"
df_lowmid_data$Income.Group = "Lower middle income"

#final dataset for data mining
df_dataset = rbind(df_low_data,df_lowmid_data)

missingin2015 = sum(is.na(df_dataset$X2015))

main_idx <- match(c("Country.Code","Indicator.Code","X2015"), names(df_dataset))

df_testset <- df_dataset[,main_idx]

names(df_testset) <- c("Country","Indicator","Value")

combined_melt = melt(df_testset, id=c("Country","Indicator","Value"))
combined_cast= cast(combined_melt, value='Value', formula = Country  ~ Indicator)
names(combined_cast)[0] <- c("CountryCode")
combined_cast = combined_cast[,2:1600]
combined_cast = data.frame(combined_cast)

missingvalues <- data.frame("Indicator code" = names(combined_cast)[2:1600],"Missingvalues"=0)
count = 0

for (i in names(combined_cast)){
  missingvalues$Missingvalues[count]=sum(is.na(combined_cast[,count]))
  count = count + 1
}

#now we start to choose data
year = "2015"
main_idx <- match(c("Country.Code","Indicator.Code",sprintf("X%s",year)), names(df_dataset))

df_dataset_year <- df_dataset[,main_idx]

my_var = c("NV.AGR.TOTL.ZS","SE.PRM.NENR","SE.ENR.PRIM.FM.ZS",
           "NY.GDP.PCAP.CD","SN.ITK.DEFC.ZS",
           "SH.XPD.CHEX.GD.ZS")


df_dataset_analysis = subset(df_dataset_year,df_dataset_year$Indicator.Code %in% my_var)
#my_indicators = as.character(unique(df_dataset_analysis$Indicator.Name))

names(df_dataset_analysis) = c("Country", "Indicator.Code", year)
combined_melt_year = melt(df_dataset_analysis, id=c("Country", "Indicator.Code", year))


combined_cast_year = cast(combined_melt_year, value = year, formula = Country ~ Indicator.Code)
my_indicators = c("agriculte and fish", "GDP PER CAPITA", "Gendery parity index",
                  "school enrolmment priamry", "health expenditure","undernourish")
names(combined_cast_year) = c("Country Code", my_indicators)

my_matrix = combined_cast_year[,my_indicators]

splom(my_matrix)
