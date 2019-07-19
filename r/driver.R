#______________________________________________________________________________
# FILE: driver.R
# DESC: Driver program that calls the other R scripts involved in the data
#         conversion process. Loads required packages, sets global options.
# SRC :
# IN  : 1. R Scripts for each domain
#       2. Functions.R  - data processing functions
#       3. Graphmeta.csv  - metadata for graph creation process.
#            written back out with new timestamp for which R scripts run.
# OUT : graphMeta.TTL
# REQ : 
# SRC : 
# NOTE: Example uses study CJ16050. Change code to set this value as a variable.
# TODO: Add .csv files for SMS alternate approach.
#______________________________________________________________________________
library(data.table)  # dcast
library(dplyr)       # Recode, mutate with pipe in Functions.R, other dplyr goodness
library(Hmisc)       # Import XPT
library(rdflib)      # serialize to RDF
library(readxl)      # Supplemental data
library(tidyverse)

studyNameUc <- "CJ16050"  # Change for other studies.
studyNameLc <- tolower(studyNameUc)

dm_n=3;  # The first n patients from the DM domain.

# Set working directory to the root of the work area
setwd("C:/_github/SENDConform")

source('r/Functions.R')  # Functions: readXPT(), encodeCol(), etc.

# STUDNAMEUC and STUDYNAMELC = placeholders, replace by Study name (uc,lc)
prefixList <-read.table(header = TRUE, text = "
  prefixUC       url
  'PAV'         'http://purl.org/pav'
  'STUDYNAMEUC' 'https://w3id.org/phuse/STUDYNAMELC#'
  'STUDY'       'https://w3id.org/phuse/study#'
  'DCTERMS'     'http://purl.org/dc/terms/'
  'RDF'         'http://www.w3.org/1999/02/22-rdf-syntax-ns#'
  'RDFS'        'http://www.w3.org/2000/01/rdf-schema#'
  'SKOS'        'http://www.w3.org/2004/02/skos/core#'
  'XSD'         'http://www.w3.org/2001/XMLSchema#'  "
)                         

prefixList <- prefixList %>% mutate(prefixUC = str_replace(prefixUC, "STUDYNAMEUC", studyNameUc), 
                      url      = str_replace(url, "STUDYNAMELC", studyNameLc))

# Transform the df of prefixes and values into variable names and their values
#   for use within the rdf_add statements.
prefixUC        <- as.list(prefixList$url)
names(prefixUC) <- as.list(prefixList$prefixUC)
list2env(prefixUC , envir = .GlobalEnv)

#------------------------------------------------------------------------------
#--- Graph Metadata
#------------------------------------------------------------------------------
# Create data for graph metadata. 
#  TODO: Create CSV and SMS map as an alternative approach.

# Create the dataframe. Use a dataframe instead of direct RDF statements to allow
#   future export to .CSV and use of SMS.
label_graph <- paste0("SEND Conformance data for ", studyNameUc)

description_graph <- paste("This graph is populated from example SEND data ",
  "provided by the FDA.")
title_graph <-"PhUSE Project: Going Translational with Linked Data (GoTWLD)"
status_graph <- " Under Construction/incomplete"
createdOn_graph <- gsub("(\\d\\d)$", ":\\1",strftime(Sys.time(),"%Y-%m-%dT%H:%M:%S%z"))
version_graph <- "0.0.1"


#--- Metadata RDF -------------------------------------------------------------
# TODO: Change the CJ16050 hard coded varname to dynamic
some_rdf <- rdf()  # initialize 

rdf_add(some_rdf, 
          subject      = paste0(CJ16050, "send-graph"), 
          predicate    = paste0(RDFS,  "label"), 
          object       = label_graph,
          objectType   = "literal", 
          datatype_uri = paste0(XSD,"string")
)
 rdf_add(some_rdf, 
         subject      = paste0(CJ16050, "send-graph"), 
         predicate    = paste0(DCTERMS,  "description"), 
         object       = description_graph,
         objectType   = "literal", 
         datatype_uri = paste0(XSD,"string")
 )
 rdf_add(some_rdf, 
         subject      = paste0(CJ16050, "send-graph"), 
         predicate    = paste0(DCTERMS,  "title"), 
         object       = title_graph,
         objectType   = "literal", 
         datatype_uri = paste0(XSD,"string")
 )
 rdf_add(some_rdf, 
         subject      = paste0(CJ16050, "send-graph"), 
         predicate    = paste0(BIBO,  "status"), 
         object       = status_graph,
         objectType   = "literal", 
         datatype_uri = paste0(XSD,"string")
 )
 rdf_add(some_rdf, 
         subject      = paste0(CJ16050, "send-graph"), 
         predicate    = paste0(PAV,  "version"), 
         object       = version_graph,
         objectType   = "literal", 
         datatype_uri = paste0(XSD,"string")
 )
 rdf_add(some_rdf, 
         subject      = paste0(CJ16050, "send-graph"), 
         predicate    = paste0(PAV,  "createdOn"), 
         object       = createdOn_graph,
         objectType   = "literal", 
         datatype_uri = paste0(XSD,"dateTime")
 )

#--- Serialize the some_rdf to a TTL file ----------------------------------------
# TODO: Rewrite this as a function
#       Make namespace value dynamic for study 
outFile <- 'data/source/RE Function in Rats/csv/CJ16050_GraphMeta.TTL'

rdf_serialize(some_rdf,
              outFile,
              format = "turtle",
              namespace = c( bibio   = "http://purl.org/ontology/bibo/",
                             dcterms = "http://purl.org/dc/terms/",
                             cj16050 = "https://w3id.org/phuse/cj16050#",
                             study   = "https://w3id.org/phuse/study#",
                             meddra  = "https://w3id.org/phuse/meddra#",
                             pav     = "http://purl.org/pav",
                             rdf     = "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
                             rdfs    = "http://www.w3.org/2000/01/rdf-schema#",
                             skos    = "http://www.w3.org/2004/02/skos/core#",
                             xsd     = "http://www.w3.org/2001/XMLSchema#"
              ))



# Create .CSV for alternate SMS mapping

graphMeta <- data.frame(label_graph, description_graph, title_graph, 
                        status_graph, createdOn_graph, version_graph)
# Sort column names ease of reference 
graphMeta <- graphMeta %>% select(noquote(order(colnames(graphMeta))))


write.csv(graphMeta, file="data/source/RE Function in Rats/csv/CJ16050_Graphmeta.csv",
  row.names = F,
  na = "")

# ---- XPT Import -------------------------------------------------------------
# DM ----
# sendPath="data/source/send/FFU-Contribution-to-FDA"
sendPath="data/source/RE Function in Rats"

dm <- readXPT(dataPath = sendPath, domain = "dm")
# dm  <- head(dm_all, dm_n) #subset for instance data testing 

# source('R/DM_imputeCSV.R')  # Impute values 

csvFile = paste0(sendPath, "/csv/dm.csv")
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
