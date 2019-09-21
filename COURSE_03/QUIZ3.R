
#WEEK 3 Quiz
acs = read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv")
aggLogical  = ((acs$ACR == 3) & (acs$AGS == 6))
print(which(aggLogical)[1:3])

library(jpeg)
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg")

pic = readJPEG("getdata_jeff.jpg", native=TRUE)
print(quantile(pic, c(.3, .8)))



gdp = read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv")
edu = read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv")

gdp_clean = read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", header=FALSE, skip=5, nrows=190)
gdp_clean = gdp_clean[, c(1,2,4,5)]
col_names = c("Country", "Ranking", "Full_Name", "dollars_m")
names(gdp_clean) = col_names
gdp_clean$Ranking = as.numeric(gdp_clean$Ranking)
gdp_clean$dollars_m = as.numeric(gsub(",", "",gdp_clean$dollars_m))
#View(gdp_clean)

m = match(edu$CountryCode, gdp_clean$Country, 0)
s = gdp_clean[order(gdp_clean$Ranking, decreasing=TRUE), ]

print(paste0(sum(m>0), " matches, 13th country is ", s$Full_Name[13]))




combined = merge(gdp_clean, edu[, c("CountryCode", "Income.Group")], by.x="Country", by.y="CountryCode", sort=FALSE)
#View(combined)


#agg = aggregate(combined$Ranking, list(combined$Income.Group), mean)
print(
paste(
  mean(combined[combined$Income.Group=="High income: OECD", "Ranking"]), ", ",
  mean(combined[combined$Income.Group=="High income: nonOECD", "Ranking"]))
)



combined$quant = ecdf(combined$Ranking)(combined$Ranking)
print(
  nrow(combined[(combined$Ranking <=38) & (combined$Income.Group == "Lower middle income"), ])
)