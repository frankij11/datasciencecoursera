
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

#Have total emissions from PM2.5 decreased in the United States
#from 1999 to 2008? Using the base plotting system, make a plot
#showing the total PM2.5 emission from all sources for each of
#the years 1999, 2002, 2005, and 2008.

NEI_yr <-aggregate(NEI$Emissions, by=list(NEI$year), sum)
names(NEI_yr) <- c("year", "total_emissions")
png("plot1.png", width=480, height=480)
barplot(NEI_yr$total_emissions~NEI_yr$year , 
        xlab = "Year",
        ylab="Total Emissions (Billions)",
        yaxt="n", 
        main="Total Emissions from PM2.5", col="blue")

tic_marks = seq(0, round(max(NEI_yr),-6), length.out = 4)
axis(side = 2, tic_marks, format(tic_marks/1000000, digits =  2))

dev.off()