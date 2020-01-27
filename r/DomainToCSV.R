#______________________________________________________________________________
# FILE: domainToCSV.R
# DESC: Convert a domain to CSV file
# SRC :
# IN  : 
# OUT : 
# REQ : 
# SRC : 
# NOTE: Check that armcd and setcd are character in the output.
# TODO: 
#______________________________________________________________________________
library(Hmisc)       # Import XPT

# Set working directory to the root of the work area
setwd("C:/_github/SENDConform")

source('r/Functions.R')  # Functions: readXPT(), encodeCol(), etc.

# sendPath="data/studies/send/FFU-Contribution-to-FDA"
sendPath="data/studies/RE Function in Rats"


srcDom <- "tx"

sendData <- readXPT(dataPath = sendPath, domain = srcDom)

csvFile = paste0(sendPath, "/csv/", srcDom, ".csv")
write.csv(sendData, file=csvFile,
   quote = TRUE,        
   row.names = F,
   na = "")
