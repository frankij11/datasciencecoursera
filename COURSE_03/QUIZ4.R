acs = read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv")
print(strsplit(names(acs), split = "wgtp")[123])


gdp_clean = read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", header=FALSE, skip=5, nrows=190)
gdp_clean = gdp_clean[, c(1,2,4,5)]
col_names = c("Country", "Ranking", "Full_Name", "dollars_m")
names(gdp_clean) = col_names
gdp_clean$Ranking = as.numeric(gdp_clean$Ranking)
gdp_clean$dollars_m = as.numeric(gsub(",", "",gdp_clean$dollars_m))

print(mean(gdp_clean$dollars_m))


print(grep("^United", gdp_clean$Full_Name))

edu = read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv")

combined = merge(gdp_clean, edu[, c("CountryCode", "Income.Group", "National.accounts.reference.year")], by.x="Country", by.y="CountryCode", sort=FALSE)


library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
library(lubridate)
amzn$Year = year(index(amzn))
sum(amzn$Year == 2012)
amzn$WDay = wday(sampleTimes)
sum((amzn$WDay == 2) & (amzn$Year == 2012))
