library(reshape)
library(reshape2)
library(ggplot2)
library(lattice)
library(GGally)

#load in the data
mydata = read.table("data/WDIData.csv",sep=",",header=TRUE)
country = read.table("data/WDICountry.csv",sep=",",header=TRUE)

mydata = mydata[,1:63]
all_var = unique(mydata[,3:4])

low_inc = c("Low income")
middle_inc = c("Lower middle income")

#filter out lower income and lower middle income countries using data from country_data
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

#
missingvaluesforyear = sum(is.na(df_dataset$X2015))

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

#now we start to choose data, we take 2015 due to the least missing values
year = "2015"
main_idx <- match(c("Country.Code","Indicator.Code",sprintf("X%s",year)), names(df_dataset))
main_idx_2016extra <- match(c("Country.Code","Indicator.Code","X2016"), names(df_dataset))

df_dataset_year <- df_dataset[,main_idx]
df_dataset_2016extra <- df_dataset[,main_idx_2016extra]
#our chosen variables
my_var = c("NV.AGR.TOTL.ZS","SE.PRM.NENR","SE.ENR.PRIM.FM.ZS",
           "NY.GDP.PCAP.CD","SN.ITK.DEFC.ZS",
           "SH.XPD.CHEX.GD.ZS")
my_var_2016 = c("LP.LPI.INFR.XQ","SH.STA.WASH.P5")


df_dataset_analysis = subset(df_dataset_year,df_dataset_year$Indicator.Code %in% my_var)

#extract the 2016 data and add to the 2015 dataset
df_dataset_analysis_2016 = subset(df_dataset_2016extra,df_dataset_2016extra$Indicator.Code %in% my_var_2016)
names(df_dataset_analysis_2016) = names(df_dataset_analysis)
df_dataset_analysis = rbind(df_dataset_analysis,df_dataset_analysis_2016) 

#my_indicators = as.character(unique(df_dataset_analysis$Indicator.Name))

names(df_dataset_analysis) = c("Country", "Indicator.Code", year)
combined_melt_year = melt(df_dataset_analysis, id=c("Country", "Indicator.Code", year))


combined_cast_year = cast(combined_melt_year, value = year, formula = Country ~ Indicator.Code)


my_indicators = c("Logistics performance index","Agriculture, forestry, and fishing, value added (% of GDP)", "GDP per capita", "Gender Parity Index (GPI)",
                  "School enrollment, primary (% net)", "Low income and Mortality rate attributed to unsafe water, unsafe sanitation and lack of hygiene", "health expenditure",
                  "Prevalence of undernourishment (% of population)")
#rename final matrix to the right values
names(combined_cast_year) = c("Country Code", my_indicators)

#recode GDP from USD to EUR to price as of 6th November 2019
combined_cast_year$`GDP per capita` = combined_cast_year$`GDP per capita`/0.9


write.csv(combined_cast_year, file = "finaldataset.csv")



