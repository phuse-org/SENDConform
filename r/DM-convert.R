#______________________________________________________________________________
# FILE: DM-convert.R
# DESC: Conversion of DM domain to TTL file based on ontology model
# TODO:  
#       
# IN  : DM dataframe created in driver.R
# OUT : /data/studies/STUDYNAME/ttl/DM-CJ16050-R.TTL
#                                   DM-CJ16050-R.csv
# NOTE: New subjects created for Test Cases use 99T<n> for SUBJID and USUBJID 
# TODO:  
# 
#______________________________________________________________________________

#--- Data imputations
dm$ROWID_IM <-  (1:nrow(dm))

dm$SPECIESCD_IM <- "Rat"
dm$AGEUNIT_IM   <- "Week" # to link to time namespace
dm$DURATION_IM  <- "P56D" 

# Necessary for later manipulation
dm <- data.frame(lapply(dm, as.character), stringsAsFactors=FALSE)

#' Add errors to DM Domain for testing constraints
#' 

# Create the Errors DF using the first row of the DM DF
# reset dm to null
dmErr <- dm[1,]

numDMTestSubjects <- 7  # Number of DM Test subjects for test cases

dmErr <- rep(dmErr, numDMTestSubjects)
dmErr$ROWID_IM <-  (1:nrow(dmErr))

#TWaddErrDM<-function()
#TW{
  # Create test data that contains errors
  # new subjid with 99T prefix + row identifier in the dmErr df
  dmErr$subjid <- paste0(gsub("00M01", "99T", dmErr$subjid ), dmErr$ROWID_IM)
  
  dmErr$usubjid <- paste0("CJ16050_", dmErr$subjid )
  
  
  # Test Case: RFENDTC prior to RFSTDTC
  dmErr[dmErr$subjid == '99T1', "rfendtc"] <- "2016-12-06"

  # Test Case: More than one RFSTDTC and RDFENDTC for a single subject
  #   Merge test subject data from 99T2, 99T3 into single subject 99T2
  #   99T2 - start=12-07, end = 12-07 
  #   99T3 - start=12-08, end = 12-08 
  #   So reassign the 99T3 subjid and usubjid to 99T2 to get duplicate dates
  dmErr[dmErr$subjid == '99T3', "subjid"] <- "99T2"
  dmErr[dmErr$usubjid == 'CJ16050_99T3', "usubjid"] <- "CJ16050_99T2"
  
  # Test Case: rfendtc as xsd:string
  dmErr[dmErr$subjid == '99T4', "rfendtc"] <- "7-DEC-16"

  # Test Case: Missing End date 
  dmErr[dmErr$subjid == '99T5', "rfendtc"] <- NA
  

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
#TW}
#TWdm <- addErrDM()

  
#------------------------------------------------------------------------------
#--- RDF Creation Statements --------------------------------------------------
some_rdf <- rdf()  # initialize 

for(i in 1:nrow(dm))
{
  ## Animal Subject   
  rdf_add(some_rdf, 
     subject     = paste0(CJ16050, paste0("Animal_", dm[i,"subjid"])), 
     predicate   = paste0(RDF,  "type"), 
     object      = paste0(STUDY, "AnimalSubject")
  )
  rdf_add(some_rdf, 
    subject      = paste0(CJ16050, paste0("Animal_", dm[i,"subjid"])), 
    predicate    = paste0(SKOS,  "prefLabel"), 
    object       = paste0("Animal ", dm[i, "subjid"]),
    objectType   = "literal", 
    datatype_uri = paste0(XSD,"string")
  )
  
  ## Reference Interval
  # only create interval when both rfstdtc and rfendtc are present
  if( ! is.na (dm[i,"rfstdtc"]) &&
      ! is.na (dm[i,"rfendtc"]) )
  {    
    rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("Animal_", dm[i,"subjid"])), 
      predicate    = paste0(STUDY,  "hasReferenceInterval"), 
      object       = paste0(CJ16050, paste0("Interval_",dm[i,"rfstdtc"], "_", dm[i,"rfendtc"]))
    )
  }  
  rdf_add(some_rdf, 
    subject     = paste0(CJ16050, paste0("Animal_", dm[i,"subjid"])), 
    predicate   = paste0(STUDY,  "hasSubjectID"), 
    object      = paste0(CJ16050, "SubjectIdentifier_", dm[i,"ROWID_IM"])
  )
  rdf_add(some_rdf, 
    subject     = paste0(CJ16050, paste0("Animal_", dm[i,"subjid"])), 
    predicate   = paste0(STUDY,  "hasUniqueSubjectID"), 
    object      = paste0(CJ16050, "UniqueSubjectIdentifier_", dm[i,"ROWID_IM"])
  )
  rdf_add(some_rdf, 
    subject      = paste0(CJ16050, paste0("Animal_", dm[i,"subjid"])), 
    predicate    = paste0(STUDY,  "memberOf"), 
    object       = paste0(CJPROT, paste0("Set_", dm[i,"setcd"]))
  )
  rdf_add(some_rdf, 
    subject      = paste0(CJ16050, paste0("Animal_", dm[i,"subjid"])), 
    predicate    = paste0(STUDY,  "memberOf"), 
    object       = paste0(CODE, paste0("Species_", dm[i,"SPECIESCD_IM"]))
  )
  # AgeDataCollection only when age value is present
  if( ! is.na (dm[i,"age"])){

    rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("Animal_", dm[i,"subjid"])), 
      predicate    = paste0(STUDY,  "participatesIn"), 
      object       = paste0(CJ16050, paste0("AgeDataCollection_", dm[i,"ROWID_IM"]))
    )
  }  
  rdf_add(some_rdf, 
    subject      = paste0(CJ16050, paste0("Animal_", dm[i,"subjid"])), 
    predicate    = paste0(STUDY,  "participatesIn"), 
    object       = paste0(CJ16050, paste0("SexDataCollection_", dm[i,"ROWID_IM"]))
  )
  
    # only create interval when both rfstdtc and rfendtc are present
    # TODO: ADD THE CODE!
    ## Reference Interval
    if( ! is.na (dm[i,"rfstdtc"]) &&
        ! is.na (dm[i,"rfendtc"]) )
    {    
      rdf_add(some_rdf, 
        subject      = paste0(CJ16050, paste0("Interval_",dm[i,"rfstdtc"], "_", dm[i,"rfendtc"])),
        predicate    = paste0(RDF,  "type"), 
        object       = paste0(STUDY, "ReferenceInterval")
      )
      rdf_add(some_rdf, 
        subject      = paste0(CJ16050, paste0("Interval_", dm[i,"rfstdtc"], "_", dm[i,"rfendtc"])),
        predicate    = paste0(SKOS,  "prefLabel"), 
        object       = paste0("Interval ", dm[i,"rfstdtc"], " ", dm[i,"rfendtc"] ),
        objectType   = "literal", 
        datatype_uri = paste0(XSD,"string")
      )
      rdf_add(some_rdf, 
        subject      = paste0(CJ16050, paste0("Interval_", dm[i,"rfstdtc"], "_", dm[i,"rfendtc"])),
        predicate    = paste0(TIME,  "hasBeginning"),     
        object       = paste0(CJ16050, "Date_", dm[i,"rfstdtc"])
      )      
      rdf_add(some_rdf, 
        subject      = paste0(CJ16050, paste0("Interval_", dm[i,"rfstdtc"], "_", dm[i,"rfendtc"])),
        predicate    = paste0(TIME,  "hasEnd"),     
        object       = paste0(CJ16050, "Date_", dm[i,"rfendtc"])
      ) 
    }
    # END OF INTERVAL CREATION
    # Begin Date
    if( ! is.na (dm[i,"rfstdtc"])){
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
      rdf_add(some_rdf, 
        subject      = paste0(CJ16050, "Date_", dm[i,"rfstdtc"]),
        predicate    = paste0(TIME, "inXSDDate"),
        object       = dm[i, "rfstdtc"],
        objectType   = "literal", 
        datatype_uri = paste0(XSD,"date")
      )
      rdf_add(some_rdf, 
        subject      = paste0(CJ16050, "Date_", dm[i,"rfstdtc"]),
        predicate    = paste0(STUDY, "dateTimeInXSDString"),
        object       = dm[i, "rfstdtc"],
        objectType   = "literal", 
        datatype_uri = paste0(XSD,"string")
      )
    }
      
    # End Date
     if( ! is.na (dm[i,"rfendtc"]) ) {
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
        rdf_add(some_rdf, 
          subject      = paste0(CJ16050, "Date_", dm[i,"rfendtc"]),
          predicate    = paste0(TIME, "inXSDDate"),
          object       = dm[i, "rfendtc"],
          objectType   = "literal", 
          datatype_uri = paste0(XSD,"date")
        )
        rdf_add(some_rdf, 
          subject      = paste0(CJ16050, "Date_", dm[i,"rfendtc"]),
          predicate    = paste0(STUDY, "dateTimeInXSDString"),
          object       = dm[i, "rfendtc"],
          objectType   = "literal", 
          datatype_uri = paste0(XSD,"string")
        )
      }

  ## Subject Identifier
  rdf_add(some_rdf, 
      subject     = paste0(CJ16050, "SubjectIdentifier_", dm[i,"ROWID_IM"]),
      predicate   = paste0(RDF,  "type"), 
      object      = paste0(STUDY, "SubjectIdentifier")
    )
    rdf_add(some_rdf, 
      subject     = paste0(CJ16050, "SubjectIdentifier_", dm[i,"ROWID_IM"]),
      predicate    = paste0(SKOS, "prefLabel"),
      object       = paste0(dm[i, "subjid"]),
      objectType   = "literal", 
      datatype_uri = paste0(XSD,"string")
    )
  
  ## Unique Subject Identifier
    rdf_add(some_rdf, 
      subject     = paste0(CJ16050, "UniqueSubjectIdentifier_", dm[i,"ROWID_IM"]),
      predicate   = paste0(RDF,  "type"), 
      object      = paste0(STUDY, "UniqueSubjectIdentifier")
    )
    rdf_add(some_rdf, 
      subject     = paste0(CJ16050, "UniqueSubjectIdentifier_", dm[i,"ROWID_IM"]),
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
        subject      = paste0(CJ16050, paste0("AgeDataCollection_", dm[i,"ROWID_IM"])),
        predicate    = paste0(RDF,  "type"), 
        object       = paste0(CODE, "AgeDataCollection")
      )    
      rdf_add(some_rdf, 
        subject      = paste0(CJ16050, paste0("AgeDataCollection_", dm[i,"ROWID_IM"])),
        predicate    = paste0(SKOS, "prefLabel"),
        object       = paste0("Age data collection ", dm[i, "ROWID_IM"]),
        objectType   = "literal", 
        datatype_uri = paste0(XSD,"string")
      )
      rdf_add(some_rdf, 
        subject      = paste0(CJ16050, paste0("AgeDataCollection_", dm[i,"ROWID_IM"])),
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
      subject      = paste0(CJ16050, paste0("SexDataCollection_", dm[i,"ROWID_IM"])),
      predicate    = paste0(RDF,  "type"), 
      object       = paste0(CODE, "SexDataCollection")
    )    
    rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("SexDataCollection_", dm[i,"ROWID_IM"])),
      predicate    = paste0(SKOS, "prefLabel"),
      object       = paste0("Sex data collection ", dm[i, "ROWID_IM"]),
      objectType   = "literal", 
      datatype_uri = paste0(XSD,"string")
    )
    rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("SexDataCollection_", dm[i,"ROWID_IM"])),
      predicate    = paste0(CODE,  "outcome"), 
      object       = paste0(CODE, paste0("Sex_", dm[i,"sex"]))
    ) 
    
  # Study Participants
  rdf_add(some_rdf, 
    subject      = paste0(CJPROT, paste0("Study_", dm[i,"studyid"])), 
    predicate    = paste0(STUDY,  "hasStudyParticipant"), 
    object       = paste0(CJ16050, "Animal_", dm[i,"subjid"])
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
