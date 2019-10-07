
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
  filter(SCC %in% vehicle_SCC, fips == "24510") %>%
  group_by(year) %>%
  summarise(Total_Emissions = sum(Emissions))

max_y <-round(max(NEI_group$Total_Emissions), -2) +100
png("plot5.png", width=480, height=480)
ggplot(NEI_group, aes(year, Total_Emissions))+
  geom_bar(stat="sum", show.legend = FALSE) +
  geom_smooth(method="lm")+ 
  coord_cartesian(ylim=c(0, max_y))+
  scale_y_continuous(breaks= seq(0, max_y,length.out= 3), labels = format(seq(0, max_y,length.out= 3), big.mark = ",", scientific=FALSE)) +
  scale_x_continuous(breaks= seq(1999, 2008,3) ) +
  
  ggtitle("Motor Vehicle Related Emissions for Baltimore")
#ggplot2::ggsave("plot3.png")
dev.off()