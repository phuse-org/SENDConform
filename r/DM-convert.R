#______________________________________________________________________________
# FILE: DM-convert.R
# DESC: Conversion of DM domain to TTL file based on ontology model
# TODO:  
#       
# IN  : DM dataframe created in driver.R
# OUT : /data/studies/STUDYNAME/ttl/DM-CJ16050-R.TTL
#                                   DM-CJ16050-R.csv
#       /SHACL/CD16050Constraints/DM-CJ16050-R.TTL  - dev/testing
# NOTE: New subjects created for Test Cases use 99T<n> for SUBJID and USUBJID 
#       SHA-1 hash values based on a random number computed for IRI creation.
#           - The hash value is re-used for IRIs that are unique to that line
#             in the source data. Eg: Animal_,  Interval_ , etc. but for values
#             that may be common to multiple submjects (eg: Age) or refer out to 
#             code lists (Set_)
#           DMROWSHORTHASH_IM can be thought of as a unique ID for that row of source
#              data, similar to ROWID in other datasets.
#       Error Testing:
#       IF statement in the RDF creation for dates with -DEC- for error testing
# TODO:  
#  Move the SHA1 creation to after merge of the error data back to the main data.
#______________________________________________________________________________

# Seed values for random number generation to create data-independent IRIs 
ranSeed1 <-  16050

#--- Data imputations
dm$SPECIESCD_IM   <- "Rat"
dm$AGEUNIT_IM     <- "Week" # to link to time namespace
dm$DURATION_IM    <- "P56D" 
numDMTestSubjects <- 11  # Number of DM Test subjects for test cases
dm$ROWID_IM <-  (1:nrow(dm)) # To match with ERR dataset. Will later be deleted.
# Necessary for later manipulation
dm <- data.frame(lapply(dm, as.character), stringsAsFactors=FALSE)


dm$ORIGSUBJID_IM <- dm$subjid  # reference for later data manip. for error testing.

#' Add errors to DM Domain for testing constraints
#' 

# Create the Errors DF using the first row of the DM DF
# reset dm to null
dmErr <- dm[1,]


#addErrDM<-function()
#{
  dmErr <- rep(dmErr, numDMTestSubjects)
  dmErr$ROWID_IM <-  (1:nrow(dmErr))
  

  # Create test data that contains errors
  # new subjid with 99T prefix + row identifier in the dmErr df
  dmErr$subjid <- paste0(gsub("00M01", "99T", dmErr$subjid ), dmErr$ROWID_IM)

  dmErr$ORIGSUBJID_IM <- dmErr$subjid  # reference for later data manip. for error testing.
  
  dmErr$usubjid <- paste0("CJ16050_", dmErr$subjid )
  
  
  # Test Case: RFENDTC prior to RFSTDTC
  dmErr[dmErr$subjid == '99T1', "rfendtc"] <- "2016-12-06"

  # Test Case: More than one RFSTDTC and RDFENDTC for a single subject
  #   Merge test subject data from 99T2, 99T3 into single subject 99T2
  #   99T2 - start=12-07, end = 12-07 
  #   99T3 - start=12-08, end = 12-08 
  #   So reassign the 99T3 subjid and usubjid to 99T2 to get duplicate dates
  # Assign the short hash from 99T2 to 99T3 to create same reference IRI in later steps.
  dmErr[dmErr$subjid == '99T3', "subjid"] <- "99T2"
  
  # set different dates on the "new" TT92 using ORIGSUBJID_IM to create a reference interval
  #  with more than one start and more than one end.
  dmErr[dmErr$ORIGSUBJID_IM == '99T3', "rfstdtc"] <- "2016-12-08"
  dmErr[dmErr$ORIGSUBJID_IM == '99T3', "rfendtc"] <- "2016-12-09"
  
  dmErr[dmErr$subjid == '99T3', "subjid"] <- "99T2"
  dmErr[dmErr$usubjid == 'CJ16050_99T3', "usubjid"] <- "CJ16050_99T2"

  # Dates as strings must have -DEC- for later regex  
  # Test Case: rfendtc as xsd:string
  dmErr[dmErr$subjid == '99T4', "rfendtc"] <- "7-DEC-16"
  # Test Case: rfendtc as xsd:string
  dmErr[dmErr$subjid == '99T10', "rfstdtc"] <- "6-DEC-16"
  
  # Test Case: Missing End date 
  dmErr[dmErr$subjid == '99T5', "rfendtc"] <- NA
  
  # Test Case: Missing Start date 
  dmErr[dmErr$subjid == '99T9', "rfstdtc"] <- NA

  
  # Test Case: Missing Start Date and Missing End date 
  dmErr[dmErr$subjid == '99T8', "rfstdtc"] <- NA
  dmErr[dmErr$subjid == '99T8', "rfendtc"] <- NA
  
  

  #--- END SD1002 -------------------------------------------------------------

  # --- SD0083
  # Duplicate USUBJID: Both 99T6 and 99T7 have USUBJID = CJ16050_99T6  
    dmErr[dmErr$subjid == '99T7', "usubjid"] <- "CJ16050_99T6"
  
  
  # --- SD0084
  #     Age cannot be less than 0
  dmErr[dmErr$subjid == '99T1', "age"] <- -10
  
  #--- 
  # Age missing where missing
  dmErr[dmErr$subjid == '99T2', "age"] <- NA
  
  # Age missing and not required to be present 
  dmErr[dmErr$subjid == '99T4', "age"] <- NA
  dmErr[dmErr$subjid == '99T4', "armcd"] <- "NOTASSGN"
  
  #--- END test data creation -------
  # Error data appended to real data.
  dm <-rbind (dm, dmErr)
 
#}
#dm <- addErrDM(dm)


  
  # Create data-independed IRI values based on random values  
  
set.seed(ranSeed1)
dm$dmRowRanVal <- runif(nrow(dm))
  
for(i in 1:nrow(dm))  
{
  dm[i,"DMROWSHORTHASH_IM"] <- strtrim(sha1(paste(dm[i,"dmRowRanVal"])), 8)  # Truncate for readabilty in the pilot
}

# kludge so the duplicate 99T2 has the same short hash (replace origin from 99T3)
#  Not possible in
dm[dm$subjid == '99T2', "DMROWSHORTHASH_IM"] <- "21316392"

# drop columns used for computations that will not become part of the graph
dm <- dm[, !names(dm) %in% c("dmRowRanVal", 'ROWID_IM')]

  
#------------------------------------------------------------------------------
#--- RDF Creation Statements --------------------------------------------------
some_rdf <- rdf()  # initialize 

for(i in 1:nrow(dm))
{
  ## Animal Subject   
  rdf_add(some_rdf, 
     subject     = paste0(CJ16050, paste0("Animal_", dm[i,"DMROWSHORTHASH_IM"])), 
     predicate   = paste0(RDF,  "type"), 
     object      = paste0(STUDY, "AnimalSubject")
  )
  rdf_add(some_rdf, 
    subject      = paste0(CJ16050, paste0("Animal_", dm[i,"DMROWSHORTHASH_IM"])), 
    predicate    = paste0(SKOS,  "prefLabel"), 
    object       = paste0("Animal ", dm[i, "subjid"]),
    objectType   = "literal", 
    datatype_uri = paste0(XSD,"string")
  )
  
  ## Reference Interval
  #  Intervals without start and end dates are valid. See AO email 2019-08-01
  #    An interval can also have a missing start or end date. 
  #  Test Case: 99T11 has no reference interval present.
  
  # Interval attached to Animal IRI  
  if( ! dm[i,"subjid"] %in% c("99T11") )
  {  
  
    rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("Animal_", dm[i,"DMROWSHORTHASH_IM"])), 
      predicate    = paste0(STUDY,  "hasReferenceInterval"), 
      object       = paste0(CJ16050, paste0("Interval_",dm[i,"DMROWSHORTHASH_IM"]))
    )
      
    # Interval Triples and subtriples
    rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("Interval_", dm[i,"DMROWSHORTHASH_IM"])),
      predicate    = paste0(RDF,  "type"), 
      object       = paste0(STUDY, "ReferenceInterval")
    )
    rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("Interval_",dm[i,"DMROWSHORTHASH_IM"])),
      predicate    = paste0(SKOS,  "prefLabel"), 
      object       = paste0("Interval ", dm[i,"rfstdtc"], " ", dm[i,"rfendtc"] ),
      objectType   = "literal", 
      datatype_uri = paste0(XSD,"string")
    )
        
    # Start Date IRI if rfstdtc is non-missing
    if( ! is.na (dm[i,"rfstdtc"]) )
    {  
      # Start date attached to the interval
      rdf_add(some_rdf, 
        subject      = paste0(CJ16050, paste0("Interval_",dm[i,"DMROWSHORTHASH_IM"])),
        predicate    = paste0(TIME,  "hasBeginning"),     
        object       = paste0(CJ16050, "Date_", dm[i,"rfstdtc"])
      )  
        
      # Start Date Triples 
      rdf_add(some_rdf, 
        subject      = paste0(CJ16050, "Date_", dm[i,"rfstdtc"]),
        predicate    = paste0(RDF,  "type"), 
        object       = paste0(STUDY, "ReferenceBegin")
      )    
      rdf_add(some_rdf, 
        subject      = paste0(CJ16050, "Date_", dm[i,"rfstdtc"]),
        predicate    = paste0(SKOS, "prefLabel"),
        object       = paste0("Date ", dm[i, "rfstdtc"]),
        objectType   = "literal", 
        datatype_uri = paste0(XSD,"string")
      )
        
      # Test Case:  
      # Hard-coded string for date when date value contains "-Dec-", 
      #  else the format is the correct xsd:date
      if (grepl("-DEC-", dm[i,"rfstdtc"], ignore.case = TRUE)) {
        rdf_add(some_rdf, 
          subject      = paste0(CJ16050, "Date_", dm[i,"rfstdtc"]),
          predicate    = paste0(TIME, "inXSDDate"),
          object       = dm[i, "rfstdtc"],
          objectType   = "literal", 
          datatype_uri = paste0(XSD,"string")
        )
      }else{
        rdf_add(some_rdf, 
          subject      = paste0(CJ16050, "Date_", dm[i,"rfstdtc"]),
          predicate    = paste0(TIME, "inXSDDate"),
          object       = dm[i, "rfstdtc"],
          objectType   = "literal", 
          datatype_uri = paste0(XSD,"date")
        )
      }  
      rdf_add(some_rdf, 
        subject      = paste0(CJ16050, "Date_", dm[i,"rfstdtc"]),
        predicate    = paste0(STUDY, "dateTimeInXSDString"),
        object       = dm[i, "rfstdtc"],
        objectType   = "literal", 
        datatype_uri = paste0(XSD,"string")
      )
    }  # End of start date IRI  
    
    # End Date IRI if rfendtc is non-missing
    if( ! is.na (dm[i,"rfendtc"]) )
    {  
      # End date attached to the interval
      rdf_add(some_rdf, 
        subject      = paste0(CJ16050, paste0("Interval_",dm[i,"DMROWSHORTHASH_IM"])),
        predicate    = paste0(TIME,  "hasEnd"),     
        object       = paste0(CJ16050, "Date_", dm[i,"rfendtc"])
      )
    
      # End Date triples
      rdf_add(some_rdf, 
        subject      = paste0(CJ16050, "Date_", dm[i,"rfendtc"]),
        predicate    = paste0(RDF,  "type"), 
        object       = paste0(STUDY, "ReferenceEnd")
      )    
      rdf_add(some_rdf, 
        subject      = paste0(CJ16050, "Date_", dm[i,"rfendtc"]),
        predicate    = paste0(SKOS, "prefLabel"),
        object       = paste0("Date ", dm[i, "rfendtc"]),
        objectType   = "literal", 
          datatype_uri = paste0(XSD,"string")
      )
        
      # Test Case:  
      #   Hard-coded string for date when date value contains "-Dec-", 
      #  else the format is the correct xsd:date
      if (grepl("-DEC-", dm[i,"rfendtc"], ignore.case = TRUE)) {
        rdf_add(some_rdf, 
          subject      = paste0(CJ16050, "Date_", dm[i,"rfendtc"]),
          predicate    = paste0(TIME, "inXSDDate"),
          object       = dm[i, "rfendtc"],
          objectType   = "literal", 
          datatype_uri = paste0(XSD,"string")
        )
      }else{
        rdf_add(some_rdf, 
          subject      = paste0(CJ16050, "Date_", dm[i,"rfendtc"]),
          predicate    = paste0(TIME, "inXSDDate"),
          object       = dm[i, "rfendtc"],
          objectType   = "literal", 
          datatype_uri = paste0(XSD,"date")
        )
      }  
      rdf_add(some_rdf, 
        subject      = paste0(CJ16050, "Date_", dm[i,"rfendtc"]),
        predicate    = paste0(STUDY, "dateTimeInXSDString"),
        object       = dm[i, "rfendtc"],
        objectType   = "literal", 
        datatype_uri = paste0(XSD,"string")
      )
    }  # End of End Date creation
  }  
  ## ---- END OF INTERVAL CREATION ------------------------------------------
  
  rdf_add(some_rdf, 
    subject     = paste0(CJ16050, paste0("Animal_", dm[i,"DMROWSHORTHASH_IM"])), 
    predicate   = paste0(STUDY,  "hasSubjectID"), 
    object      = paste0(CJ16050, "SubjectIdentifier_", dm[i,"DMROWSHORTHASH_IM"])
  )
  rdf_add(some_rdf, 
    subject     = paste0(CJ16050, paste0("Animal_", dm[i,"DMROWSHORTHASH_IM"])), 
    predicate   = paste0(STUDY,  "hasUniqueSubjectID"), 
    object      = paste0(CJ16050, "UniqueSubjectIdentifier_", dm[i,"DMROWSHORTHASH_IM"])
  )
  rdf_add(some_rdf, 
    subject      = paste0(CJ16050, paste0("Animal_", dm[i,"DMROWSHORTHASH_IM"])), 
    predicate    = paste0(STUDY,  "memberOf"), 
    object       = paste0(CJPROT, paste0("Set_", dm[i,"setcd"]))
  )
  rdf_add(some_rdf, 
    subject      = paste0(CJ16050, paste0("Animal_", dm[i,"DMROWSHORTHASH_IM"])), 
    predicate    = paste0(STUDY,  "memberOf"), 
    object       = paste0(CODE, paste0("Species_", dm[i,"SPECIESCD_IM"]))
  )
  # AgeDataCollection only when age value is present
  if( ! is.na (dm[i,"age"]))
  {
    rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("Animal_", dm[i,"DMROWSHORTHASH_IM"])), 
      predicate    = paste0(STUDY,  "participatesIn"), 
      object       = paste0(CJ16050, paste0("AgeDataCollection_", dm[i,"DMROWSHORTHASH_IM"]))
    )
  }  
  rdf_add(some_rdf, 
    subject      = paste0(CJ16050, paste0("Animal_", dm[i,"DMROWSHORTHASH_IM"])), 
    predicate    = paste0(STUDY,  "participatesIn"), 
    object       = paste0(CJ16050, paste0("SexDataCollection_", dm[i,"DMROWSHORTHASH_IM"]))
  )
 

  ## Subject Identifier
  rdf_add(some_rdf, 
      subject     = paste0(CJ16050, "SubjectIdentifier_", dm[i,"DMROWSHORTHASH_IM"]),
      predicate   = paste0(RDF,  "type"), 
      object      = paste0(STUDY, "SubjectIdentifier")
    )
    rdf_add(some_rdf, 
      subject     = paste0(CJ16050, "SubjectIdentifier_", dm[i,"DMROWSHORTHASH_IM"]),
      predicate    = paste0(SKOS, "prefLabel"),
      object       = paste0(dm[i, "subjid"]),
      objectType   = "literal", 
      datatype_uri = paste0(XSD,"string")
    )
  
  ## Unique Subject Identifier
    rdf_add(some_rdf, 
      subject     = paste0(CJ16050, "UniqueSubjectIdentifier_", dm[i,"DMROWSHORTHASH_IM"]),
      predicate   = paste0(RDF,  "type"), 
      object      = paste0(STUDY, "UniqueSubjectIdentifier")
    )
    rdf_add(some_rdf, 
      subject     = paste0(CJ16050, "UniqueSubjectIdentifier_", dm[i,"DMROWSHORTHASH_IM"]),
      predicate    = paste0(SKOS, "prefLabel"),
      object       = paste0(dm[i, "usubjid"]),
      objectType   = "literal", 
      datatype_uri = paste0(XSD,"string")
    )
  
  ## Member of Set
  # Question to AO. Not set here.
    # AgeDataCollection only when age value is present
    if( ! is.na (dm[i,"age"])){
      ## Age Data Collection
      rdf_add(some_rdf, 
        subject      = paste0(CJ16050, paste0("AgeDataCollection_", dm[i,"DMROWSHORTHASH_IM"])),
        predicate    = paste0(RDF,  "type"), 
        object       = paste0(CODE, "AgeDataCollection")
      )    
      rdf_add(some_rdf, 
        subject      = paste0(CJ16050, paste0("AgeDataCollection_", dm[i,"DMROWSHORTHASH_IM"])),
        predicate    = paste0(SKOS, "prefLabel"),
        object       = paste0("Age data collection ", dm[i, "subjid"]),
        objectType   = "literal", 
        datatype_uri = paste0(XSD,"string")
      )
      rdf_add(some_rdf, 
        subject      = paste0(CJ16050, paste0("AgeDataCollection_", dm[i,"DMROWSHORTHASH_IM"])),
        predicate    = paste0(CODE,  "outcome"), 
        object       = paste0(CJ16050, paste0("Age_", dm[i,"age"], "_", dm[i,"ageu"]))
      )    
       # Age   
       rdf_add(some_rdf, 
         subject      = paste0(CJ16050, paste0("Age_", dm[i,"age"], "_", dm[i,"ageu"])),
         predicate    = paste0(RDF,  "type"), 
         object       = paste0(STUDY, "Age")
       )    
       rdf_add(some_rdf, 
         subject      = paste0(CJ16050, paste0("Age_", dm[i,"age"], "_", dm[i,"ageu"])),
         predicate    = paste0(SKOS, "prefLabel"),
         object       = paste0("Age ", dm[i,"age"], " ", dm[i,"ageu"]),
         objectType   = "literal", 
         datatype_uri = paste0(XSD,"string")
       )    
       rdf_add(some_rdf, 
         subject      = paste0(CJ16050, paste0("Age_", dm[i,"age"], "_", dm[i,"ageu"])),
         predicate    = paste0(TIME, "hasXSDDuration"),
         object       = paste0(dm[i,"DURATION_IM"]),
         objectType   = "literal", 
         datatype_uri = paste0(XSD,"duration")
       )  
       rdf_add(some_rdf, 
         subject      = paste0(CJ16050, paste0("Age_", dm[i,"age"], "_", dm[i,"ageu"])),
         predicate    = paste0(TIME, "numericDuration"),
         object       = paste0(dm[i,"age"]),
         objectType   = "literal", 
         datatype_uri = paste0(XSD,"decimal")
       )    
       rdf_add(some_rdf, 
         subject      = paste0(CJ16050, paste0("Age_", dm[i,"age"], "_", dm[i,"ageu"])),
         predicate    = paste0(TIME, "unitType"),
         object       = paste0(TIME, "unit", dm[i,"AGEUNIT_IM"])
       )    
    }
    ## Sex Data Collection
    rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("SexDataCollection_", dm[i,"DMROWSHORTHASH_IM"])),
      predicate    = paste0(RDF,  "type"), 
      object       = paste0(CODE, "SexDataCollection")
    )    
    rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("SexDataCollection_", dm[i,"DMROWSHORTHASH_IM"])),
      predicate    = paste0(SKOS, "prefLabel"),
      object       = paste0("Sex data collection ", dm[i, "DMROWSHORTHASH_IM"]),
      objectType   = "literal", 
      datatype_uri = paste0(XSD,"string")
    )
    rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("SexDataCollection_", dm[i,"DMROWSHORTHASH_IM"])),
      predicate    = paste0(CODE,  "outcome"), 
      object       = paste0(CODE, paste0("Sex_", dm[i,"sex"]))
    ) 
    
  # Study Participants
  rdf_add(some_rdf, 
    subject      = paste0(CJPROT, paste0("Study_", dm[i,"studyid"])), 
    predicate    = paste0(STUDY,  "hasStudyParticipant"), 
    object       = paste0(CJ16050, "Animal_", dm[i,"DMROWSHORTHASH_IM"])
  )

}

#------------------------------------------------------------------------------
# Data for error testing. 
#   Add triples to test constraints.

# Test 1

# Test 2

# Test 3


#--- Serialize the some_rdf to a TTL file ----------------------------------------
outFile <- 'data/studies/RE Function in Rats/ttl/DM-CJ16050-R.TTL'
outFileDev <- 'SHACL/CJ16050Constraints/DM-CJ16050-R.TTL'  # For development purposes only

rdf_serialize(some_rdf,
              outFile,
              format = "turtle",
              namespace = c( bibio   = "http://purl.org/ontology/bibo/",
                             code    = "https://w3id.org/phuse/code#",
                             cj16050 = "https://example.org/cj16050#",
                             cjprot  = "https://example.org/cjprot#",
                             dcterms = "http://purl.org/dc/terms/",
                             study   = "https://w3id.org/phuse/study#",
                             meddra  = "https://w3id.org/phuse/meddra#",
                             pav     = "http://purl.org/pav",
                             rdf     = "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
                             rdfs    = "http://www.w3.org/2000/01/rdf-schema#",
                             skos    = "http://www.w3.org/2004/02/skos/core#",
                             time    = 'http://www.w3.org/2006/time#',
                             xsd     = "http://www.w3.org/2001/XMLSchema#"
              ))


# Dev file. Delete later.
rdf_serialize(some_rdf,
              outFileDev,
              format = "turtle",
              namespace = c( bibio   = "http://purl.org/ontology/bibo/",
                             code    = "https://w3id.org/phuse/code#",
                             cj16050 = "https://example.org/cj16050#",
                             cjprot  = "https://example.org/cjprot#",
                             dcterms = "http://purl.org/dc/terms/",
                             study   = "https://w3id.org/phuse/study#",
                             meddra  = "https://w3id.org/phuse/meddra#",
                             pav     = "http://purl.org/pav",
                             rdf     = "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
                             rdfs    = "http://www.w3.org/2000/01/rdf-schema#",
                             skos    = "http://www.w3.org/2004/02/skos/core#",
                             time    = 'http://www.w3.org/2006/time#',
                             xsd     = "http://www.w3.org/2001/XMLSchema#"
              ))

#--- Save dataframe to CSV for SMS mapping alternative ------------------------
# Sort column names ease of reference 
dm <- dm %>% select(noquote(order(colnames(dm))))

csvFile = paste0(sendPath, "/ttl/DM-CJ16050-R.csv")
write.csv(dm, file=csvFile, 
   row.names = F,
   na = "")

# reset dm to null
#dm <- dm[0,]
#dmErr <- dmErr[0,]
