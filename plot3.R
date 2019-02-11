##--Load neccessary packages 
setup <- function() {
    
    if (!require("dplyr",quietly = TRUE)) {
        install.packages("dplyr")
        library(dplyr)
    }
    
    if (!require("lubridate",quietly = TRUE)) {
        install.packages("lubridate");
        library(lubridate)
    }
    
    if (!require("stringr",quietly = TRUE)) {
        install.packages("stringr");
        library(stringr)
    }
    
    if (!require("here")) {
        install.packages("here")
        library(here)
    }
    
    if (!require("tictoc")) {
        install.packages("tictoc")
        library(openxlsx)
    }
    
    '%!in%' <- function(x,y)!('%in%'(x,y))
    
}

setup()
##--------------------------------------------------------------------------------------------------
##--Load Dataset
##--------------------------------------------------------------------------------------------------

##--Note--->Ensure working directory matches the directory where household_power_consumption.txt resides. 
tic()
data <- read.table(here::here(file.path("household_power_consumption.txt")), header = TRUE, sep = ";")
toc()

tic()
##--Convert column formats
data <- data %>% 
    mutate(Date = as.Date(Date,format = "%d/%m/%Y"),
           DateTime = as.POSIXct(paste(Date,Time)),
           Global_active_power = as.numeric(as.character(Global_active_power)),
           Global_reactive_power = as.numeric(as.character(Global_reactive_power)),
           Voltage = as.numeric(as.character(Voltage)),
           Global_intensity = as.numeric(as.character(Global_intensity)),
           Sub_metering_1 = as.numeric(as.character(Sub_metering_1)),
           Sub_metering_2 = as.numeric(as.character(Sub_metering_2)),
           Sub_metering_3 = as.numeric(as.character(Sub_metering_3))) %>%
    ##--Extract only the relevant dates
    filter(Date >= '2007-02-01' & Date <= '2007-02-02')
toc()

##--Test for correct date range
range(data$Date)

##--Create folder to save graphs
if(!file.exists('graphs')) dir.create('graphs')
##--Open png device
png(filename = './graphs/plot3.png',
    width = 480, 
    height = 480, 
    units='px')

##--Plot3
with(data, 
     plot(DateTime, Sub_metering_1, 
                xlab = '', 
                ylab = 'Energy sub metering',
                type = 'l'))
with(data,
     lines(DateTime, Sub_metering_2, 
           col = 'red'))
with(data,
     lines(DateTime, Sub_metering_3, 
           col = 'blue'))
with(data,
     legend('topright', 
            col = c('black', 'red', 'blue'),
            legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'),
            lwd = 1))

##--Close device    
dev.off()
