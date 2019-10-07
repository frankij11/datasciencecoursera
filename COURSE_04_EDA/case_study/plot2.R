
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
png("plot2.png", width=480, height=480)
barplot(NEI_yr$total_emissions~NEI_yr$year , 
        xlab = "Year",
        ylab="Total Emissions",
        yaxt="n", 
        main="Total Emissions for Baltimore from PM2.5", col="blue")

tic_marks = seq(0, round(max(NEI_yr),-3), length.out = 4)
axis(side = 2, tic_marks, format(tic_marks,big.mark = ",",  nsmall = 0))

dev.off()