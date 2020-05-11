## plot1.R creates a histogram using 
## the values of Global_active_power(x) against Frequency(y) from data from
## https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip

# Set working directory to where your unzipped file is then read

setwd("source")
housepower <- read.table( "household_power_consumption.txt", header = TRUE, sep= ";", na.strings = "?")

# Convert the Date column to Date type

as.Date(housepower$Date, "%d/%m/%Y") -> housepower$Date

# Using lubridate package, convert the Time column to hms format

library(lubridate)
hms(housepower$Time) -> housepower$Time

# Open a png graphics device with filename "plot1.png" and following dimensions (480 x 480 pixels)

library(dplyr)
png("plot1.png", width = 480, height = 480, units = "px")

# Convert to df, then select rows within the following dates (2007-02-01 & 2007-02-02)

tbl_df(housepower) -> housepower
     filter(housepower, Date >= "2007-02-01" & Date <= "2007-02-02") -> filtered

# Create histogram with Global_active_power column as x and Frequency as y(default)

hist(filtered$Global_active_power, col = "red", main = "Global Active Power", ylab = "Frequency", xlab = "Global Active Power (kilowatts)")

# Close graphics device and then output file

dev.off()
