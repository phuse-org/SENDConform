#______________________________________________________________________________
# FILE: driver.R
# DESC: Driver program that calls the other R scripts involved in the data
#         conversion process. Loads required packages, sets global options.
# SRC :
# IN  : 1. R Scripts for each domain
#       2. Functions.R  - data processing functions
#       3. Graphmeta.csv  - metadata for graph creation process.
#            written back out with new timestamp for which R scripts run.
# OUT : GraphMeta-CJ16050.TTL
# REQ : 
# SRC : 
# NOTE: Example uses study CJ16050. Change code to set this value as a variable.
# TODO: Add .csv files for SMS alternate approach.
#______________________________________________________________________________
options(stringsAsFactors = FALSE)

library(data.table)  # dcast
library(dplyr)       # Recode, mutate with pipe in Functions.R, other dplyr goodness
library(Hmisc)       # Import XPT
library(mefa)        # Easy replication of data
library(rdflib)      # Serialize to RDF
library(readxl)      # Supplemental data
library(tidyverse)

# Set working directory to the root of the work area
setwd("C:/_github/SENDConform")

source('r/Functions.R')  # Functions: readXPT(), encodeCol(), etc.

studyNameUc <- "CJ16050"  # Change for other studies.
studyNameLc <- tolower(studyNameUc)

dm_n=5;  # The first n patients from the DM domain.

# sendPath="data/studies/send/FFU-Contribution-to-FDA"
sendPath="data/studies/RE Function in Rats"

# STUDNAMEUC and STUDYNAMELC = placeholders, replace by Study name (uc,lc)
prefixList <-read.table(header = TRUE, text = "
  prefixUC       url
  'BIBO'        'http://purl.org/ontology/bibo/'
  'CJ16050'     'https://example.org/cj16050#'
  'CJPROT'      'https://example.org/cjprot#'
  'CODE'        'https://w3id.org/phuse/code#'                          
  'PAV'         'http://purl.org/pav'
  'STUDYNAMEUC' 'https://example.org/STUDYNAMELC#'
  'STUDY'       'https://w3id.org/phuse/study#'
  'DCTERMS'     'http://purl.org/dc/terms/'
  'RDF'         'http://www.w3.org/1999/02/22-rdf-syntax-ns#'
  'RDFS'        'http://www.w3.org/2000/01/rdf-schema#'
  'SKOS'        'http://www.w3.org/2004/02/skos/core#'
  'TIME'        'http://www.w3.org/2006/time#'
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
outFile <- 'data/studies/RE Function in Rats/ttl/GraphMeta-CJ16050.TTL'

rdf_serialize(some_rdf,
              outFile,
              format = "turtle",
              namespace = c( bibio   = "http://purl.org/ontology/bibo/",
                             code    = "https://w3id.org/phuse/code#",
                             dcterms = "http://purl.org/dc/terms/",
                             cjprot  = "https://example.org/cjprot#",
                             cj16050 = "https://example.org/cj16050#",
                             study   = "https://w3id.org/phuse/study#",
                             meddra  = "https://w3id.org/phuse/meddra#",
                             pav     = "http://purl.org/pav",
                             rdf     = "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
                             rdfs    = "http://www.w3.org/2000/01/rdf-schema#",
                             skos    = "http://www.w3.org/2004/02/skos/core#",
                             time    = "http://www.w3.org/2006/time#",
                             xsd     = "http://www.w3.org/2001/XMLSchema#"
              ))

# Create .CSV for alternate SMS mapping
graphMeta <- data.frame(label_graph, description_graph, title_graph, 
                        status_graph, createdOn_graph, version_graph)

# Sort column names ease of reference 
graphMeta <- graphMeta %>% select(noquote(order(colnames(graphMeta))))

write.csv(graphMeta, file="data/studies/RE Function in Rats/ttl/Graphmeta-CJ16050.csv",
  row.names = F,
  na = "")

# --- XPT Import -------------------------------------------------------------
# --- DM ----

dm <- data.frame(readXPT(dataPath = sendPath, domain = "dm"), stringsAsFactors=FALSE)

dm  <- head(dm, dm_n) #subset for development

# source('R/DM_convert.R')  # Impute values 

