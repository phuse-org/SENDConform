#______________________________________________________________________________
# FILE: DM_convert.R
# DESC: Conversion of DM domain to TTL file based on ontology model
# TODO:  
#       
# IN  : DM dataframe created in driver.R
# OUT : /data/studies/STUDYNAME/ttl/DM.TTL
# NOTE:  
# TODO:  
#______________________________________________________________________________


#--- Data imputations
dm$ROWID_IM <-  (1:nrow(dm))

dm$SPECIESCD_IM <- "Rat"

#------------------------------------------------------------------------------
#--- RDF Creation Statements --------------------------------------------------
some_rdf <- rdf()  # initialize 

for(i in 1:nrow(dm))
{
  
  ## Animal Subject   
  rdf_add(some_rdf, 
    subject      = paste0(CJ16050, paste0("Animal_", dm[i,"subjid"])), 
    predicate    = paste0(RDF,  "type"), 
    object       = paste0(STUDY, "AnimalSubject")
  )
  
  rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("Animal_", dm[i,"subjid"])), 
      predicate    = paste0(SKOS,  "prefLabel"), 
      object       = paste0("Animal ", dm[i, "subjid"]),
      objectType   = "literal", 
      datatype_uri = paste0(XSD,"string")
    )
  
  rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("Animal_", dm[i,"subjid"])), 
      predicate    = paste0(STUDY,  "hasReferenceInterval"), 
      object       = paste0(CJ16050, paste0("Interval_",dm[i,"rfstdtc"], "_", dm[i,"rfendtc"]))
  )

  rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("Animal_", dm[i,"subjid"])), 
      predicate    = paste0(STUDY,  "memberOf"), 
      object       = paste0(CJ16050, paste0("Set_", dm[i,"setcd"]))
  )
  
  rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("Animal_", dm[i,"subjid"])), 
      predicate    = paste0(STUDY,  "memberOf"), 
      object       = paste0(CODE, paste0("Species_", dm[i,"SPECIESCD_IM"]))
  )
  
  rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("Animal_", dm[i,"subjid"])), 
      predicate    = paste0(STUDY,  "participtesIn"), 
      object       = paste0(CJ16050, paste0("AgeDataCollection_", dm[i,"ROWID_IM"]))
  )
  
  rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("Animal_", dm[i,"subjid"])), 
      predicate    = paste0(STUDY,  "participtesIn"), 
      object       = paste0(CJ16050, paste0("SexDataCollection_", dm[i,"ROWID_IM"]))
  )

  ## Reference Interval
  
  
  ## Age Data Collection
  
  ## Sex Data Collection
  
  
  
  
      
#  rdf_add(some_rdf, 
#    subject      = paste0(CJ16050, paste0("Subject_", dm[i,"usubjid"])), 
#    predicate    = paste0(STUDY,  "rfstdtc"), 
#    object       = paste0(dm[i,"rfstdtc"]),
#    objectType   = "literal", 
#    datatype_uri = paste0(XSD,"date")
#  )
#
#  rdf_add(some_rdf, 
#    subject      = paste0(CJ16050, paste0("Subject_", dm[i,"usubjid"])), 
#    predicate    = paste0(STUDY,  "rfendtc"), 
#    object       = paste0(dm[i,"rfendtc"]),
#    objectType   = "literal", 
#    datatype_uri = paste0(XSD,"date")
#  )
  
}


#------------------------------------------------------------------------------
# Data for error testing. 
#   Add triples to test constraints.

# Test 1

# Test 2

# Test 3


#--- Serialize the some_rdf to a TTL file ----------------------------------------
outFile <- 'data/studies/RE Function in Rats/ttl/DM.TTL'

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