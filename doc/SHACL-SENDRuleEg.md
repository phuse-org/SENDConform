# Modeling a SEND Rule in SHACL
# A Step-by-Step Example


This example models the SEND-IG 3.0 rule **SD1020** for the DM domain as defined in the file [FDA-Validator-Rules.xlsx](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx)

FDA Validator Rule ID | FDA Validator Message | Publisher|  Publisher ID | Business or Conformance Rule Validated | FDA Validator Rule  
------|-------------------|-----|-------|--------------------------|-----------------------------
**SD1002** |RFSTDTC is after RFENDTC | FDA| FDAB034    |Study Start and End Dates must be submitted and complete. | Subject Reference Start Date/Time (RFSTDTC) must be less than or equal to Subject Reference End Date/Time (RFENDTC)


### 1. Rule Components
Examine the *FDA Validator Rule* and create a complete expression of the rule, capturing all the key aspects.

The rule: "*Subject Reference Start Date/Time (RFSTDTC) must be less than or equal to Subject Reference End Date/Time (RFENDTC).*"

Can be described as: 

1.1 Subject Reference Start Date/Time (RFSTDTC) must be in date format  (xsd:date or xsd:dateTime)

1.2 Subject Reference End Date/Time (RFENDTC) must be in date format  (xsd:date or xsd:dateTime)

1.3 Start Date/Time (RFSTDTC) must be less than or equal to End Date/Time. (RFENDTC)

* If the End date (RFENDTC) is later than the Start Date (RFSTDTC), the system must supply the error message "RFSTDTC is after RFENDTC". 

### 2. Define the rule in SHACL
You must first define the NodeShape and Class to which the rule will apply, then add the specific rules.

2.1 Define a NodeShape

Create a .TTL file that begins with the prefixes that will be referenced in the rules. In this example, we use the `study:` prefix as a namespace for general information about studies and the `sh:` prefix is used for SHACL. 

Below the prefixes, define the NodeShape Object for the timing constraint. We name the Object using the FDA Validator Rule ID to facilitate reference back to the original source:

    @prefix study: <https://w3id.org/phuse/study#> .
    @prefix sh:   <http://www.w3.org/ns/shacl#> .
    
    study:SD1002 rdf:type sh:NodeShape ;


2.2. Assign the shape to a target class

Within the NodeShape, specify the class to which the constraints will apply. 
In our data, the RFSTDTC and RFENDTC values are associated with the class `study:StudySubject` with data that looks like: 

    cj16050:Subject_CJ16050_00M01
     a             study:StudySubject ;
     study:rfendtc "2016-12-07"^^xsd:date ;
     study:rfstdtc "2016-12-07"^^xsd:date .

Assign the constraints to a class using `sh:targetClass` so your file now looks like:

    @prefix study: <https://w3id.org/phuse/study#> .
    @prefix sh:   <http://www.w3.org/ns/shacl#> .
    
    study:SD1002 rdf:type       sh:NodeShape ;
                 sh:targetClass study:StudySubject ;

2.3 Add constraints

Revisit Section 1. and create rules for each component.

2.3.1 (reference 1.1)
Add the rule corresponding to Section 1.1 where RFSTDTC must be in date format:



2.3.2 (reference 1.2)
2.3.3 (reference 1.3)




### 3. Test Data
3.1 Source and augmentation


### 4. Applying the Constraints

4.1 Stardog via Stardog Studio

4.1.1 Load the data

4.1.2 Load the constraint


4.2 Stardog via command line

Assuming Stardog is available on the command line and the data and constrains are loaded into the SHACLTest database, execute this command:

    stardog icv report SHACLTest

You may redirect the report to a text file on your local machine, assuming you have the repository cloned to C:\_github\SENDConform :

    stardog icv report SHACLTest > "C:\_github\SENDConform\data\source\RE Function in Rats\csv\ValReport.txt"


5. Validation Report

Violation 1:  RFENDTC is of type string, not date or dateTime:

    a sh:ValidationResult ;
      sh:resultPath <https://w3id.org/phuse/study#rfendtc> ;
      sh:resultMessage "RFENDTC is not in date or dateTime format." ;
      sh:sourceShape [] ;
      sh:sourceConstraintComponent sh:OrConstraintComponent ;
      sh:resultSeverity sh:Violation ;
      sh:value "2019-01-30" ;
      sh:focusNode <https://w3id.org/phuse/cd16050#Subject_TEST-10>


Violation 2: RFSTDTC is after RFENDTC

    a sh:ValidationResult ;
      sh:focusNode <https://w3id.org/phuse/cd16050#Subject_CJ16050_TEST-1> ;
      sh:sourceConstraintComponent sh:LessThanOrEqualsConstraintComponent ;
      sh:resultPath <https://w3id.org/phuse/study#rfstdtc> ;
      sh:resultMessage "SD1002: RFSTDTC is after RFENDTC." ;
      sh:value "2016-12-09"^^xsd:date ;
      sh:resultSeverity sh:Violation ;
      sh:sourceShape []



[Back to TOC](TableOfContents.md)
