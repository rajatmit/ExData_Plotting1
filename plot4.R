# Set the working directory and place the text file in that directory
setwd("C:/Users/rgarg/Desktop/workdir")

# Estimate the memory requirement by loading only first 5 rows using nrows
# and object.size function. Multiple size value by 2075259 and dividing by 5

tab5rows <- read.table("household_power_consumption.txt", header = TRUE,
                       nrows = 5, sep = ";")
TotalMemory <- (2075259)*(object.size(tab5rows)) / 5
TotalMemory

# Add sqldf package
install.packages("sqldf")
library(sqldf)

# Read the data only for 2007-02-01 and 2007-02-02 using sqldf
# Input File is seperated by semicolon
wp <- file("household_power_consumption.txt") 
DF <- sqldf("select * from wp where
            Date = '1/2/2007' or Date = '2/2/2007'", 
            file.format = list(sep = ";", header = TRUE) )

# Convert date to "yyyy-mm-dd" format using as.Date()
DF$Date <- as.character(as.Date(as.character(DF$Date), format = "%d/%m/%Y")) 

# Combine date and time using paste() and strptime
DF$DateTime <- strptime(paste(DF$Date, DF$Time, sep=" "),
                        "%Y-%m-%d %H:%M:%S")

# Plot 4 is created to incorporate multiple plots into a
# single frame of 2*2 using the function par()
par(mfrow=c(2,2))

plot(DF$DateTime, DF$Global_active_power, type = "l", xlab="",
     ylab="Global Active Power")

plot(DF$DateTime, DF$Voltage, type = "l", xlab="datetime",
     ylab="Voltage")

plot(DF$DateTime,DF$Sub_metering_1,type="l",col="black", xlab="",
     ylab="Energy sub metering")
lines(DF$DateTime,DF$Sub_metering_2,col="red")
lines(DF$DateTime,DF$Sub_metering_3,col="blue")
legend("topright",lwd=0.5, col=c("black", "red", "blue"),
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), bty="n")

plot(DF$DateTime, DF$Global_reactive_power, type = "l", xlab="datetime",
     ylab="Global_reactive_power")

# Save the plot to the current working directory
dev.copy(png,'plot4.png')
dev.off()
