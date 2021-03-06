#______________________________________________________________________________
# FILE: DM_RowByCol-StraightConvert.R
# DESC: Straight conversion to TTL for SHACL examples, not for use in project 
#       data conversion because it does not follow the ontology approach.
# DO  :  
#       
# IN  : SENDConform\data\studies\RE Function in Rats\csv\dm.csv
# OUT : data\studies\RE Function in Rats\csv\CD16050_DM.TTL
# NOTE: Manually change locations and names for conversion as needed.
# TODO:  
#______________________________________________________________________________
library(rdflib)
setwd("C:/_github/SENDConform")

# Dataframe of prefix assignments . Dataframe used for ease of data entry. 
#   May later change to external file?
prefixList <-read.table(header = TRUE, text = "
  prefixUC  url
  'CJ16050' 'https://w3id.org/phuse/cd16050#'
  'STUDY'   'https://w3id.org/phuse/study#'
  'DCTERMS' 'http://purl.org/dc/terms/'
  'RDF'     'http://www.w3.org/1999/02/22-rdf-syntax-ns#'
  'RDFS'    'http://www.w3.org/2000/01/rdf-schema#'
  'SKOS'    'http://www.w3.org/2004/02/skos/core#'
  'XSD'     'http://www.w3.org/2001/XMLSchema#'  "
)                         

# Transform the df of prefixes and values into variable names and their values
#   for use within the rdf_add statements.
prefixUC        <- as.list(prefixList$url)
names(prefixUC) <- as.list(prefixList$prefixUC)
list2env(prefixUC , envir = .GlobalEnv)

#--- Read (and optionally subset) Source Data ---------------------------------
sendPath="data/studies/RE Function in Rats/csv"

dm <- read.csv(file = "data/studies/RE Function in Rats/csv/dm_errors.csv",
               header = TRUE,
               sep = "," )


#------------------------------------------------------------------------------
#--- RDF Creation Statements --------------------------------------------------
some_rdf <- rdf()  # initialize 

for(i in 1:nrow(dm))
{
  rdf_add(some_rdf, 
    subject      = paste0(CJ16050, paste0("Subject_", dm[i,"usubjid"])), 
    predicate    = paste0(RDF,  "type"), 
    object       = paste0(STUDY, "StudySubject")
  )
  
  rdf_add(some_rdf, 
    subject      = paste0(CJ16050, paste0("Subject_", dm[i,"usubjid"])), 
    predicate    = paste0(STUDY,  "rfstdtc"), 
    object       = paste0(dm[i,"rfstdtc"]),
    objectType   = "literal", 
    datatype_uri = paste0(XSD,"date")
  )

  rdf_add(some_rdf, 
    subject      = paste0(CJ16050, paste0("Subject_", dm[i,"usubjid"])), 
    predicate    = paste0(STUDY,  "rfendtc"), 
    object       = paste0(dm[i,"rfendtc"]),
    objectType   = "literal", 
    datatype_uri = paste0(XSD,"date")
  )
  
}

# Additional ERROR Data for testing.
#  Subject_TEST-10  : xsd:string for rfendtc instead of xsd:date
#  
rdf_add(some_rdf, 
        subject      = paste0(CJ16050, paste0("Subject_TEST-10")), 
        predicate    = paste0(RDF,  "type"), 
        object       = paste0(STUDY, "StudySubject")
)

rdf_add(some_rdf, 
        subject      = paste0(CJ16050, paste0("Subject_TEST-10")), 
        predicate    = paste0(STUDY,  "rfstdtc"), 
        object       = "2019-01-29",
        objectType   = "literal", 
        datatype_uri = paste0(XSD,"date")
)

rdf_add(some_rdf, 
        subject      = paste0(CJ16050, paste0("Subject_TEST-10")), 
        predicate    = paste0(STUDY,  "rfendtc"), 
        object       = "2019-01-30",
        objectType   = "literal", 
        datatype_uri = paste0(XSD,"string")
)




#--- Serialize the some_rdf to a TTL file ----------------------------------------
outFile <- 'data/studies/RE Function in Rats/csv/CJ16050_DM_errors.TTL'

rdf_serialize(some_rdf,
              outFile,
              format = "turtle",
              namespace = c( bibio   = "http://purl.org/ontology/bibo/",
                             dcterms = "http://purl.org/dc/terms/",
                             cj16050 = "https://w3id.org/phuse/cd16050#",
                             study   = "https://w3id.org/phuse/study#",
                             meddra  = "https://w3id.org/phuse/meddra#",
                             pav     = "http://purl.org/pav",
                             rdf     = "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
                             rdfs    = "http://www.w3.org/2000/01/rdf-schema#",
                             skos    = "http://www.w3.org/2004/02/skos/core#",
                             xsd     = "http://www.w3.org/2001/XMLSchema#"
              ))