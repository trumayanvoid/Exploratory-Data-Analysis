## plot3.R creates a linegraph/lineplot using 
## the values of Date and time (x) against Sub_metering (1:3) (y) from data from
## https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip

# Set working directory to where your unzipped file is then read

setwd("source")
housepower <- read.table( "household_power_consumption.txt", header = TRUE, sep= ";", na.strings = "?")

# Convert the Date column to Date type

as.Date(housepower$Date, "%d/%m/%Y") -> housepower$Date

# Open a png graphics device with filename "plot3.png" and following dimensions (480 x 480 pixels)

library(dplyr)
png("plot3.png", width = 480, height = 480, units = "px")

# Convert to df, then select rows within the following dates (2007-02-01 & 2007-02-02)

tbl_df(housepower) -> housepower
     filter(housepower,Date >= "2007-02-01" & Date <= "2007-02-02") -> filtered

# Add a new variable datetime with merged values of Date and Time column
# Filter datetime and Sub_metering (1:3), then rename

mutate(filtered, datetime = paste(filtered$Date, filtered$Time, sep =" "  ) ) -> filtered
     select(filtered, datetime, Sub_metering_1, Sub_metering_2, Sub_metering_3) -> filtered2
           colnames(filtered2) = c("datetime", "one", "two", "three")

#Convert datetime to as.POSIXct format then plot Sub_metering(1:3) (y) with datetime(x)

as.POSIXct(filtered2$datetime) -> filtered2$datetime
     plot(filtered2$one~filtered2$datetime, type = "l", xlab= "", ylab = "Energy sub metering")
           lines(filtered2$two~filtered2$datetime, col= "red")
          lines(filtered2$three~filtered2$datetime, col= "blue")

# Put legends, then close graphics device and then output file

legend("topright", col = c("black", "red", "blue"), lwd = c(2,2,2), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()