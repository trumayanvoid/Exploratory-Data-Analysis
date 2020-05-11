## plot4.R creates a linegraph/lineplot using 
## the values of Date and time (x) against multiple variables( Voltage, Global_active_power... 
## ..., Sub_metering (1:3), Global_reactive_power) (y) in separate plots from data from
## https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip

# Set working directory to where your unzipped file is then read

setwd("source")
housepower <- read.table( "household_power_consumption.txt", header = TRUE, sep= ";", na.strings = "?")

# Convert the Date column to Date type

as.Date(housepower$Date, "%d/%m/%Y") -> housepower$Date

# Open a png graphics device with filename "plot4.png" and following dimensions (480 x 480 pixels)

library(dplyr)
png("plot4.png", width = 480, height = 480, units = "px")

# Convert to df, then select rows within the following dates (2007-02-01 & 2007-02-02)

tbl_df(housepower) -> housepower
     filter(housepower,Date >= "2007-02-01" & Date <= "2007-02-02") -> filtered

# Add a new variable datetime with merged values of Date and Time column
# Filter datetime, Global_active_power, Voltage, Sub_metering(1:3), Global_reactive_power 

mutate(filtered, datetime = paste(filtered$Date, filtered$Time, sep =" "  ) ) -> filtered
     select(filtered, datetime, Global_active_power, Voltage,
            Sub_metering_1, Sub_metering_2, Sub_metering_3, Global_reactive_power) -> filtered2

#Convert datetime to as.POSIXct format then plot Sub_metering(1:3) (y) with datetime(x) then rename

as.POSIXct(filtered2$datetime) -> filtered2$datetime
colnames(filtered2) = c("datetime", "gap", "voltage", "one", "two", "three", "grp")

# Set mfrow to 2x2, then plot datetime as (x) against multiple (y) in separate plots

par(mfrow= c(2,2))
     plot(filtered2$gap~filtered2$datetime, type= "l", xlab="", ylab = "Global Active Power") 
     plot(filtered2$voltage~filtered2$datetime, type= "l", xlab="datetime", ylab = "Voltage") 

     {plot(filtered2$one~filtered2$datetime, type = "l", xlab= "", ylab = "Energy sub metering")
           lines(filtered2$two~filtered2$datetime, col= "red")
           lines(filtered2$three~filtered2$datetime, col= "blue")
      legend("topright", bty= "n", col = c("black", "red", "blue"), lwd = c(2,2,2), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
     }

      plot(filtered2$grp~filtered2$datetime, type= "l", xlab="datetime", ylab = "Global_reactive_power") 

# Close graphics device and then output file

dev.off()