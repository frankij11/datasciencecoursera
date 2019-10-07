
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

vehicle_SCC <- SCC[grep("Vehicle", SCC$EI.Sector),c("SCC")]

library(tidyverse)
library(ggplot2)
library(scales)
NEI_group<- NEI %>%
  filter(SCC %in% vehicle_SCC, fips == "24510"|fips == "06037") %>%
  group_by(fips, year) %>%
  summarise(Total_Emissions = sum(Emissions))

NEI_max <- NEI_group %>% group_by(fips) %>% summarise(Max_Emission = max(Total_Emissions))
NEI_group <- merge(NEI_group, NEI_max)
NEI_group <- mutate(NEI_group, scaled_emissions = Total_Emissions / Max_Emission)

NEI_group$fips = factor(NEI_group$fips)


#max_y <-round(max(NEI_group$Total_Emissions), -2) +100
png("plot6.png", width=480, height=480)
fips.labs = c("Los Angeles County", "Baltimore")
names(fips.labs) = c("06037", "24510")
ggplot(NEI_group, aes(year, scaled_emissions))+
  geom_bar(stat = "sum", show.legend = FALSE) +
  facet_grid(fips~., labeller = labeller(fips = fips.labs))+
  geom_smooth(method="lm")+ 
  coord_cartesian(ylim=c(0, 1))+
  scale_y_continuous(breaks= seq(0, 1,length.out= 5), labels = format(seq(0, 1,length.out= 5), nsmall = 2, scientific=FALSE)) +
  scale_x_continuous(breaks= seq(1999, 2008,3) ) +
  
  ggtitle("Motor Vehicle Related Emissions Baltimore vs LA")

#ggplot2::ggsave("plot3.png")
dev.off()