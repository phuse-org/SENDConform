<link href="styles.css?v=1" rel="stylesheet"/>

# Modeling SEND Rule SD1002 in SHACL


# Data 

This example uses the DM domain data from the study "RE Function in Rats", located in the repository at [/data/studies/RE Function in Rats](https://github.com/phuse-org/SENDConform/tree/master/data/studies/RE%20Function%20in%20Rats) and converted to .TTL using the script [r\\DM-convert.R](https://github.com/phuse-org/SENDConform/blob/master/r/DM-convert.R). The R script adds observations to test the rule components using SHACL constraints. Test observations are identified by `subjid` and `usubjid` values containing the pattern 99T<n> in contrast with the original study data values of 00M0<n>. See the [Data Conversion](DataConversion.md) page for details on how the data is converted to TTL.

Familiarity with the data structure is necessary to explain the constraints and test cases. Figure 1 illustrates a partial set of data for test subject subjid=99T1 that violates rule SD1002 where end date precedes start date.

<img src="images/RefIntervalDataFail.PNG"/>
*Figure 1: Reference Interval for Animal 99T1 (incomplete data)*


The full data file used in developing this page is available here: [SHACL/CJ16050Constraints/DM-CJ16050-R.TTL](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints/DM-CJ16050-R.TT)


# SHACL Constraints

A detailed description of SHACL syntax is beyond the scope of this document. Please refer to the [SHACL Introduction](SHACL-Intro.md) page for a list of resources. Only the details relevant to a specific rule component will be explained in this project.

The SHACL file [SHACL/CJ16050Constraints/SHACL-SD1002.TTL](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints\SHACL-SD1002.TTL) contains the constraints for this example. It is a work in progress and subject t change.  



# FDA Rule SD1002

This example details the constraints for the SEND-IG 3.0 rule **SD1020** for the DM domain as defined in the file [FDA-Validator-Rules.xlsx](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx)

FDA Validator Rule ID | FDA Validator Message | Publisher|  Publisher ID | Business or Conformance Rule Validated | FDA Validator Rule  
------|-------------------|-----|-------|--------------------------|-----------------------------
**SD1002** |RFSTDTC is after RFENDTC | FDA| FDAB034    |Study Start and End Dates must be submitted and complete. | Subject Reference Start Date/Time (RFSTDTC) must be less than or equal to Subject Reference End Date/Time (RFENDTC)

Implicit and explicit components of the  *FDA Validator Rule* are detailed below, along with additional components based on knowledge of how a clinical trial is performed, and how the data is captured and modeled. 


## SD1002 Rule Components

### Date format

<div class='def'>
  <div class='def-header'>Description</div>
  Reference Start Date (RFSTDTC) and End Date (RFENDTC) must be in 
  <font class="emph">date format</font>. The study in this example requires
  xsd:date. Other studies may use xsd:dateTime or a combination of xsd:date 
  and xsd:dateTime.
</div>

<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  `rfstdtc` and `rfendtc` in `xsd:date` format.  
</div>

The SHACL shape `:DateShape` is constructed using `sh:targetObjectsOf` to select the interval IRI as the (Subject) focus node. The two `sh:targetObjectsOf` follow these paths through the data to obtain the date values: 

<pre>
<font class='objectIRI'>Interval IRI</font> - - - <font class='predicate'>time:hasBeginning</font>  - - > <font class='objectIRI'>Date IRI</font> - - > <font class='predicate'>time:inXSDDate</font> - - > <font class='literal'>Date value</font>

<font class='objectIRI'>Interval IRI</font> - - - <font class='predicate'>time:hasEnd</font>  - - > <font class='objectIRI'>Date IRI</font> - - > <font class='predicate'>time:inXSDDate</font> - - > <font class='literal'>Date value</font>
</pre>

<pre class="shape">
  :DateShape a sh:NodeShape ;
    sh:targetObjectsOf time:hasBeginning ;
    sh:targetObjectsOf time:hasEnd ;
    sh:class study:ReferenceEnd ;
    sh:property [
      sh:path time:inXSDDate ;  
      sh:datatype xsd:date ;
    ] .  
</pre>

The test data includes subject 99T4 with string for `rfendtc`. Not shown: Subject 9T10 with string for `stdtc`.
<pre class="data">
    cj16050:Interval_68bab561
      a study:ReferenceInterval ;
      time:hasBeginning cj16050:Date_2016-12-08 ;
      time:hasEnd cj16050:Date_7-DEC-16 .
       
    cj16050:Date_7-DEC-16
      a study:ReferenceEnd ;
      time:inXSDDate <font class='error'>"7-DEC-16"^^xsd:string</font> .
</pre>


The report correctly identifies the value '7-Dec-16' as a string, violating the xsd:date requirement.
<pre class="report">
  a sh:ValidationReport ;
    sh:conforms false ;
    sh:result [
      a sh:ValidationResult ;
        sh:value "<font class='error'>7-DEC-16</font>" ;
        sh:resultPath time:inXSDDate ;
        sh:sourceConstraintComponent sh:DatatypeConstraintComponent ;
        sh:focusNode <font class='objectIRI'>cj16050:Date_7-DEC-16 </font>;
        sh:sourceShape [] ;
        sh:resultSeverity sh:<font class='error'>Violation</font>
    ]  
</pre>


[Back to TOC](TableOfContents.md)
