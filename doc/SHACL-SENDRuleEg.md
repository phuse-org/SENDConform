Modeling a SEND Rule in SHACL (Example)
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

2.2. Define NodeShape Constraints


### 3. Test Data
3.1 Source and augmentation


### 4. Applying the Constraints

4.1 Stardog via Stardog Studio
4.1.1 Load the data
4.1.2 Load the constraint


4.2 Stardog via command line







[Back to TOC](TableOfContents.md)
