#______________________________________________________________________________
# FILE: XPTtoCSV.R
# DESC: Convert XPT domains to CSV for SMS mapping or creation of TTL by R
# SRC :
# IN  : 1. R Scripts for each domain
#       2. Functions.R  - data processing functions
#       3. Graphmeta.csv  - metadata for graph creation process.
#            written back out with new timestamp for which R scripts run.
# OUT : <domain name>.csv  
# REQ : 
# SRC : 
# NOTE: Some values are imputed  to match ontology development requirements.
# TODO: 
#______________________________________________________________________________
library(data.table)  # dcast
library(dplyr)       # Recode, mutate with pipe in Functions.R, other dplyr goodness
library(Hmisc)       # Import XPT
library(readxl)      # Supplemental data

dm_n=3;  # The first n patients from the DM domain.

# Set working directory to the root of the work area
setwd("C:/_github/CTDasRDF")

source('r/send/Functions.R')  # Functions: readXPT(), encodeCol(), etc.

# ---- Graph Metadata ---------------------------------------------------------
# Read in the source CSV, insert time stamp, and write it back out
#  Source file needed UTF-8 spec to import first column correctly. Could be artifact
#    that needs later replacement.
graphMeta <- read.csv2("data/source/send/Graphmeta.csv",
  fileEncoding="UTF-8-BOM" , header=TRUE, sep=",");

graphMeta$createdOn<-gsub("(\\d\\d)$", ":\\1",strftime(Sys.time(),"%Y-%m-%dT%H:%M:%S%z"))

write.csv(graphMeta, file="data/source/Graphmeta.csv",
  row.names = F,
  na = "")

# ---- XPT Import -------------------------------------------------------------
# DM ----
# sendPath="data/source/send/FFU-Contribution-to-FDA"
sendPath="data/source/send/CDISC-Safety-Pharmacology-POC"

dm <- readXPT(dataPath = sendPath, domain = "ts")
# dm  <- head(dm_all, dm_n) #subset for instance data testing 

# source('R/DM_imputeCSV.R')  # Impute values 

csvFile = paste0(sendPath, "/csv/ts.csv")
write.csv(dm, file=csvFile, 
   row.names = F,
   na = "")

nrow(dm)


# SUPPDM ----
#  No imputation for SUPPDM (no SUPPDM_imputeCSV.R)
suppdm  <- readXPT("suppdm")
suppdm <- suppdm[suppdm$usubjid %in% pntSubset,]  # Subset for dev

#TW write.csv(suppdm, file="data/source/SUPPDM_subset.csv", 
#TW   row.names = F,
#TW   na = "")

# EX ----
ex  <- readXPT("ex")
ex <- ex[ex$usubjid %in% pntSubset,]  # Subset for dev

# Merge in the Drug Administration interval from DM. Could also have been calculated
#  from min(exstdtc)_max(exendtc) but would involve more calcs and DM is seen as the
#  authoritative value (at least for this prototype)
ex <- merge(dmDrugInt, ex, by.x = "usubjid", by.y="usubjid")

source('R/EX_imputeCSV.R') # Impute values 

#TW write.csv(ex, file="data/source/EX_subset.csv", 
#TW row.names = F,
#TW   na = "")

# VS ----
vs  <- readXPT("vs")  
# Subset for development
# Subset to match ontology data. Expand to all of subjid 1015 later.
# VS is also used to get performed dates for patients 1023, 1028
#  for Baseline, screening, Wk2 and Wk24 dates.
#   1023 : 153,159, 165
#   1028 : 228, 234, 242, 264

vsSubset <-c(1:3, 86:88, 43, 44:46, 128, 142, 7, 13, 37, 153,159, 165, 228, 234, 242, 264)
vs <- data.frame(vs[vsSubset, ], stringsAsFactors=FALSE)  

source('R/VS_imputeCSV.R') # Impute values

#TW write.csv(vs, file="data/source/vs_subset.csv", 
#TW   row.names = F,
#TW   na = "")

# TS ----
ts  <- readXPT("ts")  

source('R/TS_imputeCSV.R') # Impute values

write.csv(tswide, file="data/source/ts.csv", 
  row.names = F,
  na = "")


# AE ----
ae  <- readXPT("ae")  
ae  <- ae[ae$usubjid %in% pntSubset,]  # Subset for dev

source('R/AE_imputeCSV.R') # Impute values

write.csv(ae, file="data/source/ae.csv", 
  row.names = F,
  na = "")
