###############################################################################
# FILE: fullTripleComp.R
# DESC: Compare all triples in two TTL files. 
#       Eg Usage: Compare TTL file generated from TopBraid with one created using R
# IN  : Hard coded input files AOFile, RFile
#       cj16050.ttl 
#       DM-CJ16050-R.TTL
# OUT : datatable
# REQ : 
# NOTE: 
# TODO: 
###############################################################################
library(plyr)    # rename
library(dplyr)   # anti_join. Must load dplyr AFTER plyr!!
library(reshape) # melt
library(rdflib)  # new for testing 
library(DT)
setwd("C:/_github/SENDConform")

AOFile <- "data\\studies\\RE Function in Rats\\ttl\\cj16050.ttl"
RFile <- "data\\studies\\RE Function in Rats\\ttl\\DM-CJ16050-R.TTL"

# With a named Subject, remove s,p,o that are artifacts from TopBraid
removeSubjects <- c("https://example.org/cj16050")  # Placeholder

# List of prefixes from config file
allPrefix <- "data/config/prefixes.csv"  # List of prefixes

prefixes <- as.data.frame( read.csv(allPrefix,
  header=T,
  sep=',' ,
  strip.white=TRUE))

# Create individual PREFIX statements
prefixes$prefixDef <- paste0("PREFIX ", prefixes$prefix, ": <", prefixes$namespace,">")

# All s,p,o from both files. 
queryString = paste0(paste(prefixes$prefixDef, collapse=""),
  "SELECT ?s ?p ?o 
   WHERE {?s ?p ?o .}
  ORDER BY ?s ?p ?o")

#---- Ontology Triples 
rdf <- rdf_parse(paste(AOFile,sep=""), format = "turtle")
triplesOnt <- rdf_query(rdf, queryString)

# Remove cases where O is missing in the Ontology source(atrifact from TopBraid)
triplesOnt <-triplesOnt[!(triplesOnt$o==""),]
triplesOnt <- triplesOnt[complete.cases(triplesOnt), ]

# Remove extra test data from the ont triples
triplesOnt <- triplesOnt[ ! triplesOnt$s %in% removeSubjects, ]

#-- R Triples
rdf_R <- rdf_parse(paste(RFile,sep=""), format = "turtle")
triplesR <- rdf_query(rdf_R, queryString)

#--- In R and not in Ontology 
RNotOnt <-anti_join(triplesR, triplesOnt)
RNotOnt <-RNotOnt[with(RNotOnt, order(s,p,o)), ]  # Not needed...

OntNotR <- anti_join(triplesOnt, triplesR)
OntNotR <- OntNotR[with(OntNotR, order(s,p,o)), ]  # Not needed...

datatable(OntNotR)

datatable(RNotOnt)
