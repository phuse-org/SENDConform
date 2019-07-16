# Modeling a SEND Rule in SHACL
# A Step-by-Step Example

### 0. Background
The goal of this page is to provide a full, simple, working example of how to model a SEND rule using SHACL. The simplistic data structure does not match the schema used in the main SENDConform project, which is more complex. This work will be documented elsewhere. 

### 1. Data Structure and Implications for Constraints

**1.1 Example Data**

This example uses data from the DM domain for the study "RE Function in Rats", located in the repository at [/data/source/RE Function in Rats](https://github.com/phuse-org/SENDConform/tree/master/data/source/RE%20Function%20in%20Rats) and converted to a .CSV file using R [SHACL\Examples\CreateTTL-CJ16050-DM-SD1002-TestData.R](https://github.com/phuse-org/SENDConform/blob/master/SHACL/Examples/CreateTTL-CJ16050-DM-SD1002-TestData.R). 

The R file adds the following test data to trip validation rules:

**Test-1 : Start date after end date**

    cj16050:Subject_TEST-1
        a study:AnimalSubject ;
        study:rfendtc "2016-12-08"^^xsd:date ;
        study:rfstdtc "2016-12-09"^^xsd:date .

**Test-2: End date is a string, not a date/dateTime**

    cj16050:Subject_TEST-2
        a study:AnimalSubject ;
        study:rfendtc "2019-01-30"^^xsd:string ;
        study:rfstdtc "2019-01-29"^^xsd:date .

**Test-3: Duplicate data**

    cj16050:Subject_TEST-3
        a study:AnimalSubject ;
        study:rfendtc "2019-02-02"^^xsd:string ;
        study:rfstdtc "2019-02-03"^^xsd:date .

    cj16050:Subject_TEST-3
        a study:AnimalSubject ;
        study:rfendtc "2019-02-12"^^xsd:string ;
        study:rfstdtc "2019-02-13"^^xsd:date .

The data file for this example is available here: [SHACL\Examples\CJ16050-DM-SD1002-TestData.TTL](https://github.com/phuse-org/SENDConform/blob/master/SHACL/Examples/CJ16050-DM-SD1002-TestData.TTL)


**1.2 Data Structure and Implications for Shape Constraints**

Representation of SEND data as RDF is built around the concept of associating values with a Animal Subject. For the DM domain used in this example, there is one row per Animal Subject and the triples for Subject CJ16050_00M01 are:

    study:Subject_CJ16050_00M01
        a              study:AnimalSubject ;
        study:rfendtc  "2016-12-07"^^xsd:date ;
        study:rfstdtc  "2016-12-07"^^xsd:date  ;
        study:subjid   "00M01"^^xsd:string ;
        study:usubjid  "CJ16050_00M01" ^^xsd:string ;
      .... more data...

For validation purposes, an outer "SubjectShape" is constructed that contains additional shape definitions for the various constraints that apply to the data within the Animal Subject. You can visualize this outer shape as a shell (SubjectShape) in Figure 1 that encapsulate the other shapes within it (SD1002Shape, SD1001Shape, etc.)

<img src="images\\ShapeLayers.PNG" width=600>

*Figure 1 Shapes*

### 2. FDA Rules
This example models the SEND-IG 3.0 rule **SD1020** for the DM domain as defined in the file [FDA-Validator-Rules.xlsx](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx)

FDA Validator Rule ID | FDA Validator Message | Publisher|  Publisher ID | Business or Conformance Rule Validated | FDA Validator Rule  
------|-------------------|-----|-------|--------------------------|-----------------------------
**SD1002** |RFSTDTC is after RFENDTC | FDA| FDAB034    |Study Start and End Dates must be submitted and complete. | Subject Reference Start Date/Time (RFSTDTC) must be less than or equal to Subject Reference End Date/Time (RFENDTC)

Examine the *FDA Validator Rule* and create a complete expression of the rule, capturing all the key components.

The rule: 

"***Subject Reference Start Date/Time (RFSTDTC) must be less than or equal to Subject Reference End Date/Time (RFENDTC).***"

Can be described as: 

2.1 Subject Reference Start Date/Time (RFSTDTC) must be in date format  (xsd:date or xsd:dateTime)

2.2 Subject Reference End Date/Time (RFENDTC) must be in date format  (xsd:date or xsd:dateTime)

2.3 Start Date/Time (RFSTDTC) must be less than or equal to End Date/Time. (RFENDTC)

2.4 The implicit rule that each Animal Subject should only have one RFSTDTC and one RFENDTC date. 

* If the End date (RFENDTC) is later than the Start Date (RFSTDTC), the system must supply the error message **"RFSTDTC is after RFENDTC"**. 

### 3. Define the Constraints

**3.1 SubjectShape**
The SubjectShape is defined first, and then the additional shapes encapsulated within it. 

Create a .TTL file that begins with the prefixes that will be referenced in the rules. In this example, we use the `study:` prefix as a namespace for general information about studies and the `sh:` prefix is used for SHACL. 

Below the prefixes, define the SubjectShape NodeShape Object and the node that references that  SD1002Shape for the timing constraint. For brevity, this example we will not code the SD1001Shape and SD0083 shapes shown in Figure 1. 

    @prefix study: <https://w3id.org/phuse/study#> .
    @prefix sh:   <http://www.w3.org/ns/shacl#> .
    
    study:SubjectShape a sh:Shape;
      sh:targetClass study:AnimalSubject;
      sh:node        study:SD1002Shape .

`sh:targetClass` specifies that the constraints will be applied to all members of the AnimalSubject class.


**3.2 SD1002Shape**

Revisit Section 2. and define constraints for each component. 

**3.2.1 Constraint: Date Format and Count (RFSTDTC and RFENDTC)** 
Constraints for both `study:rfstdtc` and `study:rfendtc`can be applied using `sh:or` and a second `sh:or` to test if their values are xsd:date or xsd:dateTime, since both are acceptable.
The additional statments `sh:minCount 1` and `sh:maxCount 1` ensure that one (and only one) value of each date is present.

    study:SD1002Shape rdf:type sh:NodeShape ;
      sh:property [
      sh:name "Date format and count" ;
      sh:description "Evaluate date format (xsd:date/ xsd:dateTime) and minCount, maxCount = 1 per AnimalSubject." ;
      sh:or (

        [sh:path study:rfendtc ;]
        [sh:path study:rfstdtc; ]
      ) ;  
      sh:or (
        [sh:datatype  xsd:date ; ]
        [sh:datatype  xsd:dateTime ; ]
      ) ;
      sh:minCount 1 ;
      sh:maxcount 1 ;
  ] ; 

`sh:message` is not used in this case because the system messages are adequate to determine a data type error or a min/max count error.



3.2.2 Constraint: RFSTDTC is Less Than or Equal to RFENDTC (Rule 2.3)

The SD1002Shape is completed by adding a `sh:lessThanOrEquals` constraint, as in:


    sh:property [
      sh:name "SD1002" ;
      sh:description "SD1002: Subject Reference Start Date/Time (RFSTDTC) must be less than or equal to Subject Reference End Date/Time (RFENDTC)" ;
      sh:path             study:rfstdtc ;
      sh:lessThanOrEquals study:rfendtc ;
      sh:message "RFSTDTC is after RFENDTC." 
    ]
    .

By convention for this project,  `sh:name` specifies the *FDA Validator Rule ID* the ID also appears in the `sh:description`, pre-pended to the text from the *FDA Validator RUle* field, and in `sh:message` with content from the *FDA Validator Message* field.

This is the end of the validation for SD1002, so the last statment ends with a period instead of a semicolon. 

The complete SHACL file is located in [SHACL\Examples\SHACL_SD1002.TTL](https://github.com/phuse-org/SENDConform/blob/master/SHACL/Examples/SHACL_SD1002.TTL)


### 4. Applying the Constraints

4.1 Stardog via Stardog Studio

4.1.1 Execute the Report on Data in the Database

1. Create a test database named SHACLTest in Stardog.
1. Load the data file CJ16050-DM-SD1002-TestData.TTL .
1. Open the SHACL constraint file SHACL_SD1002.TTL into Stardog Studio.
1. Select the filed type as SHACL (lower right corner of Studio)
1. From the ADD CONSTRAINT drop down (upper left), select the drop down button and choose Get Validation Report.
1. Scroll through the report and find the two shacl#resultMessages for the two data errors. The report is easier to view from the command line exection so see the next section.


4.1.3 b) Stardog via command line

Assuming Stardog is available on the command line and the data and constrains are loaded into the SHACLTest database, execute this command:

    stardog icv report SHACLTest

You may redirect the report to a text file on your local machine, assuming you have the repository cloned to C:\_github\SENDConform :

    stardog icv report SHACLTest > "C:\_github\SENDConform\data\source\RE Function in Rats\csv\ValReport.txt"


4.2  TopBraid
Instructions will be added later for TopBraid.

5. Validation Report

Violation 1:  RFENDTC is of type string, not date or dateTime:

    a sh:ValidationResult ;
      sh:resultPath <https://w3id.org/phuse/study#rfendtc> ;
      sh:resultMessage "RFENDTC is not in date or dateTime format." ;
      sh:sourceShape [] ;
      sh:sourceConstraintComponent sh:OrConstraintComponent ;
      sh:resultSeverity sh:Violation ;
      sh:value "2019-01-30" ;
      sh:focusNode <https://w3id.org/phuse/cd16050#Subject_TEST-2>


Violation 2: RFSTDTC is after RFENDTC

    a sh:ValidationResult ;
      sh:focusNode <https://w3id.org/phuse/cd16050#Subject_CJ16050_TEST-1> ;
      sh:sourceConstraintComponent sh:LessThanOrEqualsConstraintComponent ;
      sh:resultPath <https://w3id.org/phuse/study#rfstdtc> ;
      sh:resultMessage "SD1002: RFSTDTC is after RFENDTC." ;
      sh:value "2016-12-09"^^xsd:date ;
      sh:resultSeverity sh:Violation ;
      sh:sourceShape []


Violation 3: Duplicate data
*TO BE ADDED*

[Back to TOC](TableOfContents.md)
