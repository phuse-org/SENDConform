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
#           SubjectIRI can be thought of as a unique ID for that row of source
#              data, similar to ROWID in other datasets.
#       Error Testing:
#       IF statement is used in the RDF creation for dates with -DEC- for error testing
# TODO:  
#  Move the SHA1 creation to after merge of the error data back to the main data.
#   Fix so will create AgeDataCollection values of Missing. See line ~449.
#______________________________________________________________________________
rm(list = ls())       # COMMENT OUT when running from driver.R

setwd("C:/_github/SENDConform")


source('r/driver.R')  # COMMENT OUT when running from driver.R

# Seed values for random number generation to create data-independent IRIs 
ranSeed1 <-  16050
set.seed(ranSeed1)

#--- Data imputations
dm$SPECIESCD_IM   <- "Rat"
dm$AGEUNIT_IM     <- "Week" # to link to time namespace
dm$DURATION_IM    <- "P56D" 
numDMTestSubjects <- 13  # Number of DM Test subjects for test cases. Generates 99T1 to 99Tn
dm$ROWID_IM <-  (1:nrow(dm)) # To match with ERR dataset. Will later be deleted.

#Necessary for later manipulation
dm <- data.frame(lapply(dm, as.character), stringsAsFactors=FALSE)

#DEL dm$ORIGSUBJID_IM <- dm$subjid  # reference for later data manip. for error testing.

#--- Add errors to DM Domain for testing constraints
# Create the Errors DF using the first row of the DM DF
# reset dm to null
dmErr <- dm[1,]
dmErr <- rep(dmErr, numDMTestSubjects)  # Create rows of data for test cases
dmErr$ROWID_IM <-  (1:nrow(dmErr))
# Create test data that contains errors

dmErr <- dmErr %>% mutate (
  # New subjid with 99T prefix + row identifier in the dmErr df
  subjid   = paste0(gsub("00M01", "99T", subjid ), ROWID_IM),
  usubjid  = paste0("CJ16050_", subjid )  # USUBJID to match pattern.
  
)

dm <- rbind(dm, dmErr)  # Bring datasets back together before more manipulation

# usubjid is still unique at this point. Use it to create a unique hash for each
#   subject in DM, prior to manipulation of the identifier data for testing.
for(i in 1:nrow(dm))  
{
  dm[i,"SubjectIRI"] <- paste0("Animal_", 
                               strtrim(sha1(paste(dm[i,"usubjid"])), 8)  # Truncate for readabilty in the pilot
  ) 
}

dm <- dm %>% mutate (
  ORIGSUBID_IM = subjid # Reference when subjid changed during data manipulation
)

# Clean Subject from original data. No rules violated.
dm[!is.na(dm$subjid) &dm$subjid == c('00M01'), "FDARuleViolated"] <- "None"

#--- Rule SD0083 RC 1 
#  One animal subject has more than one SUBUJID
#--- Rule SD1001 RC 1 
#  One animal subject has more than one SUBJID
#  A single animal subject is assigned to 99T1, 99T2 identifiers.
dm[3,"SubjectIRI"] <- dm[2,"SubjectIRI"] 
dm[dm$subjid %in% c('99T1', '99T2'), "FDARuleViolated"] <- "SD0083-RC1, SD1001-RC1"

#--- Rule SD0083 RC 2 
#  Subject cannot have missing subjid 
dm[dm$subjid == c('99T3'), "FDARuleViolated"] <- "SD0083-RC2, SD1001-RC2"
dm[dm$subjid == c('99T3'), "subjid"] <- NA

#--- Rule SD1001 RC 2 
#  Subject cannot have missing usubjid 
dm[dm$usubjid == c('CJ16050_99T3'), "usubjid"] <- NA


# NB: From this point forward, ! is.na is needed for usubjid, subjid assignments.

#--- Rule SD0083 RC 3
#  usubjid cannot be assigned to more than one subject
#  : Assign CJ16050_99T4 to more than one subject
dm[!is.na(dm$usubjid) & dm$usubjid == c('CJ16050_99T5'), "usubjid"] <- 'CJ16050_99T4'

#--- Rule SD1001 RC 3
#  subjid cannot be assigned to more than one subject
#  : Assign 99T4 to more than one subject.  Two rows of data now have the same
#       usubjid, subjid
dm[!is.na(dm$subjid) & dm$subjid == c('99T5'), "subjid"] <- '99T4'
dm[!is.na(dm$subjid) & dm$subjid == c('99T4'), "FDARuleViolated"] <- "SD0083-RC3, SD1001-RC3"







commentedOut <- function() {
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

  
  # Create duplicate SUBJID, USUBJID for 99T6, 99T7 
  #dmErr[dmErr$subjid == '99T6', "subjid"] <- "99DUP1"
  
  #--- SD0083, RC 3
  #    USUBJID assigned to more than one Animal subject
  #    What should be CJ16050_99T7 is assigned the number CJ16050_99T6, resulting in
  #    two subjects with the same USUBJID.
  dmErr[dmErr$usubjid == 'CJ16050_99T7', "usubjid"] <- "CJ16050_99T6"

  #--- SD1001, RC3 
  #   SUBJID assigned to more than one Animal subject
  #    What should be 99T7 is assigned the number _99T6, resulting in
  #    two subjects with the same SUBJID.
  dmErr[dmErr$subjid == '99T7', "subjid"] <- "99T6"
    
  
  #--- AGE --------------------------------------------------------------------
  # --- SD0084
  #     Age cannot be less than 0
  dmErr[dmErr$subjid == '99T1', "age"] <- -10
  
  #--- 
  # Age missing where missing
  dmErr[dmErr$subjid == '99T2', "age"] <- NA
  
  # Age missing and not required to be present 
  dmErr[dmErr$subjid == '99T4', "age"] <- NA
  dmErr[dmErr$subjid == '99T4', "armcd"] <- "NOTASSGN"
  
  dmErr[dmErr$subjid == '99T13', "age"] <- NA
  dmErr[dmErr$subjid == '99T13', "armcd"] <- "SCRNFAIL"
  
  #--- END test data creation -------
  # Error data appended to real data.
  dm <-rbind (dm, dmErr)
 

# dm <- addErrDM(dm)



# Create data-independent IRI values based on random values  
  

dm$dmRowRanVal <- runif(nrow(dm))
  
for(i in 1:nrow(dm))  
{
  dm[i,"SubjectIRI"] <- strtrim(sha1(paste(dm[i,"dmRowRanVal"])), 8)  # Truncate for readabilty in the pilot
}

# kludge so the duplicate 99T2 has the same short hash (replace origin from 99T3)
dm[dm$subjid == '99T2', "SubjectIRI"] <- "21316392"

# drop columns used for computations that will not become part of the graph
dm <- dm[, !names(dm) %in% c("dmRowRanVal", 'ROWID_IM')]

# Must be here or other re-assignments become more complex (need to look for NA first)
  #SD0083, SD1001
  # Test Case: Missing Start Date and Missing End date 

#TW HERE ----------------------------------------------------------
dm[dm$subjid == '99T12', "subjid"]  <- NA
dm[dm$usubjid == 'CJ16050_99T12', "usubjid"] <- NA

} # END COMMENTED OUT
  
#------------------------------------------------------------------------------
#--- RDF Creation -------------------------------------------------------------
#------------------------------------------------------------------------------
createRDF <- function()
{  
  some_rdf <- rdf()  # initialize 

for(i in 1:nrow(dm))
{
  ## Animal Subject   
  rdf_add(some_rdf, 
     subject     = paste0(CJ16050, paste0(dm[i,"SubjectIRI"])), 
     predicate   = paste0(RDF,  "type"), 
     object      = paste0(STUDY, "AnimalSubject")
  )
  if( ! is.na (dm[i,"subjid"]) ){
    rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0(dm[i,"SubjectIRI"])), 
      predicate    = paste0(SKOS,  "prefLabel"), 
      object       = paste0("Animal ", dm[i, "subjid"]),
      objectType   = "literal", 
      datatype_uri = paste0(XSD,"string")
    )
  }
  
  ## Reference Interval
  #  Intervals without start and end dates are valid. See AO email 2019-08-01
  #    An interval can also have a missing start or end date. 
  #  Test Case: 99T11 has no reference interval present.
  
  # Interval attached to Animal IRI . 
  #   For all cases in the data EXCEPT 99T11 who has no interval.
  if( ! dm[i,"subjid"] %in% c("99T11") )
  {  
  
    rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0(dm[i,"SubjectIRI"])), 
      predicate    = paste0(STUDY,  "hasReferenceInterval"), 
      object       = paste0(CJ16050, paste0("Interval_",dm[i,"SubjectIRI"]))
    )
      
    # Interval Triples and subtriples
    rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("Interval_", dm[i,"SubjectIRI"])),
      predicate    = paste0(RDF,  "type"), 
      object       = paste0(STUDY, "ReferenceInterval")
    )
    rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("Interval_",dm[i,"SubjectIRI"])),
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
        subject      = paste0(CJ16050, paste0("Interval_",dm[i,"SubjectIRI"])),
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
        subject      = paste0(CJ16050, paste0("Interval_",dm[i,"SubjectIRI"])),
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
  
  # Create additional SUBJID and USUBJID IRIs for 99T11. These are in 
  #   addition to the regular triples for 99T11 so there is no 'else' statement!
  #   Test case:  Animal subject 99T11 has more than one SUBJID and more than one USUBJID
  if( dm[i,"subjid"] %in% c("99T11") )
  {  
    ## Subject Identifier
    rdf_add(some_rdf, 
      subject     = paste0(CJ16050, paste0(dm[i,"SubjectIRI"])), 
      predicate   = paste0(STUDY,  "hasSubjectID"), 
      object      = paste0(CJ16050, "SubjectIdentifier_99T11B")
    )
  
    rdf_add(some_rdf, 
      subject     = paste0(CJ16050, "SubjectIdentifier_99T11B"),
      predicate   = paste0(RDF,  "type"), 
      object      = paste0(STUDY, "SubjectIdentifier")
    )
    rdf_add(some_rdf, 
      subject     = paste0(CJ16050, "SubjectIdentifier_99T11B"),
      predicate    = paste0(SKOS, "prefLabel"),
      object       = paste("99T11B"),
      objectType   = "literal", 
      datatype_uri = paste0(XSD,"string")
    )
    # Unique Subject Identifier 
    rdf_add(some_rdf, 
      subject     = paste0(CJ16050, paste0(dm[i,"SubjectIRI"])), 
      predicate   = paste0(STUDY,  "hasUniqueSubjectID"), 
      object      = paste0(CJ16050, "UniqueSubjectIdentifier_CJ16050_99T11B")
    )
    rdf_add(some_rdf, 
      subject     = paste0(CJ16050, "UniqueSubjectIdentifier_CJ16050_99T11B"),
      predicate   = paste0(RDF,  "type"), 
      object      = paste0(STUDY, "UniqueSubjectIdentifier")
    )
    rdf_add(some_rdf, 
      subject     = paste0(CJ16050, "UniqueSubjectIdentifier_CJ16050_99T11B"),
      predicate    = paste0(SKOS, "prefLabel"),
      object       = paste0("CJ16050_99T11B"),
      objectType   = "literal", 
      datatype_uri = paste0(XSD,"string")
    )
  }
  
  ## Subject Identifier
  if( ! is.na (dm[i,"subjid"]) ) {
    rdf_add(some_rdf, 
      subject     = paste0(CJ16050, paste0(, dm[i,"SubjectIRI"])), 
      predicate   = paste0(STUDY,  "hasSubjectID"), 
      object      = paste0(CJ16050, "SubjectIdentifier_", dm[i,"subjid"])
    )
    rdf_add(some_rdf, 
      subject     = paste0(CJ16050, "SubjectIdentifier_", dm[i,"subjid"]),
      predicate   = paste0(RDF,  "type"), 
      object      = paste0(STUDY, "SubjectIdentifier")
    )
    rdf_add(some_rdf, 
      subject     = paste0(CJ16050, "SubjectIdentifier_", dm[i,"subjid"]),
      predicate    = paste0(SKOS, "prefLabel"),
      object       = paste0(dm[i, "subjid"]),
      objectType   = "literal", 
      datatype_uri = paste0(XSD,"string")
    )
  }
  ## Unique Subject Identifier
  if( ! is.na (dm[i,"usubjid"]) ) {
    rdf_add(some_rdf, 
      subject     = paste0(CJ16050, paste0(, dm[i,"SubjectIRI"])), 
      predicate   = paste0(STUDY,  "hasUniqueSubjectID"), 
      object      = paste0(CJ16050, "UniqueSubjectIdentifier_", dm[i,"usubjid"])
    )
    rdf_add(some_rdf, 
      subject     = paste0(CJ16050, "UniqueSubjectIdentifier_", dm[i,"usubjid"]),
      predicate   = paste0(RDF,  "type"), 
      object      = paste0(STUDY, "UniqueSubjectIdentifier")
    )
      
    rdf_add(some_rdf, 
      subject     = paste0(CJ16050, "UniqueSubjectIdentifier_", dm[i,"usubjid"]),
      predicate    = paste0(SKOS, "prefLabel"),
      object       = paste0(dm[i, "usubjid"]),
      objectType   = "literal", 
      datatype_uri = paste0(XSD,"string")
    )
  }
  

  rdf_add(some_rdf, 
    subject      = paste0(CJ16050, paste0(dm[i,"SubjectIRI"])), 
    predicate    = paste0(STUDY,  "memberOf"), 
    object       = paste0(CJPROT, paste0("Set_", dm[i,"setcd"]))
  )
  rdf_add(some_rdf, 
    subject      = paste0(CJ16050, paste0(dm[i,"SubjectIRI"])), 
    predicate    = paste0(STUDY,  "memberOf"), 
    object       = paste0(CODE, paste0("Species_", dm[i,"SPECIESCD_IM"]))
  )
  #AgeDataCollection only when age value is present
  #  NO! For SHACL testing, need AgeDataCollection to be created even when AGE is missing
  #      to allow testing of rules for missing ages.
  # if( ! is.na (dm[i,"age"]))
  #{
    rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0(dm[i,"SubjectIRI"])), 
      predicate    = paste0(STUDY,  "participatesIn"), 
      object       = paste0(CJ16050, paste0("AgeDataCollection_", dm[i,"SubjectIRI"]))
    )
  #}  
  rdf_add(some_rdf, 
    subject      = paste0(CJ16050, paste0(dm[i,"SubjectIRI"])), 
    predicate    = paste0(STUDY,  "participatesIn"), 
    object       = paste0(CJ16050, paste0("SexDataCollection_", dm[i,"SubjectIRI"]))
  )
 


  ## Member of Set
  # Question to AO. Not set here.
    # AgeDataCollection only when age value is present
     # commented out to allow testing of missing age values
     #if( ! is.na (dm[i,"age"])){
      ## Age Data Collection
      rdf_add(some_rdf, 
        subject      = paste0(CJ16050, paste0("AgeDataCollection_", dm[i,"SubjectIRI"])),
        predicate    = paste0(RDF,  "type"), 
        object       = paste0(CODE, "AgeDataCollection")
      )    
      if( ! is.na (dm[i,"subjid"]) ) {
        rdf_add(some_rdf, 
          subject      = paste0(CJ16050, paste0("AgeDataCollection_", dm[i,"SubjectIRI"])),
          predicate    = paste0(SKOS, "prefLabel"),
          object       = paste0("Age data collection ", dm[i, "subjid"]),
          objectType   = "literal", 
          datatype_uri = paste0(XSD,"string")
        )
      #}  
      if( ! is.na (dm[i,"age"])){  
        rdf_add(some_rdf, 
          subject      = paste0(CJ16050, paste0("AgeDataCollection_", dm[i,"SubjectIRI"])),
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
        
      } else {
        # Age value  MISSING: Create IRIs for it without the age value.
        rdf_add(some_rdf, 
          subject      = paste0(CJ16050, paste0("AgeDataCollection_", dm[i,"SubjectIRI"])),
          predicate    = paste0(CODE,  "outcome"), 
          object       = paste0(CJ16050, paste0("Age_"))
        )
       rdf_add(some_rdf, 
         subject      = paste0(CJ16050, paste0("Age_")),
         predicate    = paste0(SKOS, "prefLabel"),
         object       = paste0("Age ", " ", dm[i,"ageu"]),
         objectType   = "literal", 
         datatype_uri = paste0(XSD,"string")
       )    
       rdf_add(some_rdf, 
         subject      = paste0(CJ16050, paste0("Age_")),
         predicate    = paste0(TIME, "hasXSDDuration"),
         object       = paste0(dm[i,"DURATION_IM"]),
         objectType   = "literal", 
         datatype_uri = paste0(XSD,"duration")
       )  
       #rdf_add(some_rdf, 
       #   subject      = paste0(CJ16050, paste0("Age_")),
       #  predicate    = paste0(TIME, "numericDuration"),
       #   object       = paste0(dm[i,"age"]),
       #   objectType   = "literal", 
       #   datatype_uri = paste0(XSD,"decimal")
       #)    
       rdf_add(some_rdf, 
         subject      = paste0(CJ16050, paste0("Age_")),
         predicate    = paste0(TIME, "unitType"),
         object       = paste0(TIME, "unit", dm[i,"AGEUNIT_IM"])
       )    

      } 
    }
    ## Sex Data Collection
    rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("SexDataCollection_", dm[i,"SubjectIRI"])),
      predicate    = paste0(RDF,  "type"), 
      object       = paste0(CODE, "SexDataCollection")
    )    
    rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("SexDataCollection_", dm[i,"SubjectIRI"])),
      predicate    = paste0(SKOS, "prefLabel"),
      object       = paste0("Sex data collection ", dm[i, "SubjectIRI"]),
      objectType   = "literal", 
      datatype_uri = paste0(XSD,"string")
    )
    rdf_add(some_rdf, 
      subject      = paste0(CJ16050, paste0("SexDataCollection_", dm[i,"SubjectIRI"])),
      predicate    = paste0(CODE,  "outcome"), 
      object       = paste0(CODE, paste0("Sex_", dm[i,"sex"]))
    ) 
    
  # Study Participants
  rdf_add(some_rdf, 
    subject      = paste0(CJPROT, paste0("Study_", dm[i,"studyid"])), 
    predicate    = paste0(STUDY,  "hasStudyParticipant"), 
    object       = paste0(CJ16050, dm[i,"SubjectIRI"])
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
                             schema  = "https://schema.org/",
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
                             schema  = "https://schema.org/",
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

} #end createRDF()
  
# createRDF()

# reset dm to null
#dm <- dm[0,]
#dmErr <- dmErr[0,]
