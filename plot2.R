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

# Create second plot for line for Global_active_power
# with datetime using plot() label for y-coordinate using "ylab"
plot(DF$DateTime, DF$Global_active_power, type = "l", xlab="",
     ylab="Global Active Power (kilowatts)")

# Save the plot to the current working directory
dev.copy(png,'plot2.png')
dev.off()
