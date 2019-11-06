library(GGally)

ggpairs(combined_cast_year[2:7], aes())
# need to attach variable IncomeGroup in combined cast
# toevoegen: aes(colour = IncomeGroup, alpha = 0.4)