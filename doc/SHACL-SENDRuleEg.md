# Modeling a SEND Rule in SHACL
# A Step-by-Step Example
=================

This example models the SEND-IG 3.0 rule **SD1020** for the DM domain as defined in the file /doc/FDA-Validator-Rules.xlsx 

FDA Validator Rule ID | FDA Validator Message | Publisher|  Publisher ID | Business or Conformance Rule Validated | FDA Validator Rule  
------|-------------------|-----|-------|--------------------------|-----------------------------
**SD1002** |RFSTDTC is after RFENDTC | FDA| FDAB034    |Study Start and End Dates must be submitted and complete. | Subject Reference Start Date/Time (RFSTDTC) must be less than or equal to Subject Reference End Date/Time (RFENDTC)


### 1. Express the rule in human-interpretable form.
Examine the *FDA Validator Rule* and create a complete expression of the rule in human-readable language. 

The rule: "*Subject Reference Start Date/Time (RFSTDTC) must be less than or equal to Subject Reference End Date/Time (RFENDTC).*"

Can be described as: 

1.1 Subject Reference Start Date/Time (RFSTDTC) must be in date format  (xsd:date or xsd:dateTime)

1.2 Subject Reference End Date/Time (RFENDTC) must be in date format  (xsd:date or xsd:dateTime)

1.3 Start Date/Time (RFSTDTC) must be less than or equal to End Date/Time. (RFENDTC)

* If the End date (rfendtc) is later than the Start Date (rfstdtc), the system must supply the error message "RFSTDTC is after RFENDTC". 

### 2. Express the rules in SHACL

2.1 Define a NodeShape
Create a .TTL file and at the top of the file assign the prefixes needed for constraint. In this case, we use the study: prefix as a namespace for general information about "studies" and the and sh: prefixe is used for shacl. 

Below the prefixes, define the NodeShape for the Start and End constraint:

    @prefix study: <https://w3id.org/phuse/study#> .
    @prefix sh:   <http://www.w3.org/ns/shacl#> .
    study:StartEndShape rdf:type sh:NodeShape ; `


2.2. Assign the shape to a target class
Within the Nodeshape, specify the class to which the constraints will apply. 
In our data, the RFSTDTC and RFENDTC values are associated with the class `study:StudySubject` with data that looks like: 

    cj16050:Subject_CJ16050_00M01
     a study:StudySubject ;
     study:rfendtc "2016-12-07"^^xsd:date ;
     study:rfstdtc "2016-12-07"^^xsd:date .

Assign the constraints to a class using `sh:targetClass` so your file now looks like:

    @prefix study: <https://w3id.org/phuse/study#> .
    @prefix sh:   <http://www.w3.org/ns/shacl#> .
    study:StartEndShape rdf:type sh:NodeShape ; `
        sh:targetClass study:StudySubject ;


2.3 Add contraints

2.3.1 (reference 1.1)
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

`stardog icv report SHACLTest`





[Back to TOC](TableOfContents.md)
