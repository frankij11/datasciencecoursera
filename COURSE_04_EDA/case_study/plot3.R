
zipFile <-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
if(!file.exists("data")){dir.create("data")}

if(!file.exists("data/summarySCC_PM25.rds")){
  download.file(zipFile, "data/data.zip")
  unzip("data/data.zip", exdir = "data")
  file.remove("data/data.zip")
}

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

#Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (\color{red}{\verb|fips == "24510"|}fips=="24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.
NEI_ba <- subset(NEI,fips=="24510")
NEI_yr <-aggregate(NEI_ba$Emissions, by=list(NEI_ba$year), sum)
names(NEI_yr) <- c("year", "total_emissions")

library(tidyverse)
library(ggplot2)
NEI_group<- NEI %>%
  filter(fips =="24510") %>%
  group_by(type, year) %>%
  summarise(Total_Emissions = sum(Emissions))

png("plot3.png", width=480, height=480)
ggplot(NEI_group, aes(year, Total_Emissions))+
  geom_bar(stat="sum", show.legend = FALSE) +
  geom_smooth(method="lm")+ facet_grid(.~type) +
  theme(axis.text.x = element_text(angle = 90)) +
  coord_cartesian(ylim=c(0, round(max(NEI_group$Total_Emissions), -2)))+
  ggtitle("Total Emission for Baltimore")
#ggplot2::ggsave("plot3.png")
dev.off()