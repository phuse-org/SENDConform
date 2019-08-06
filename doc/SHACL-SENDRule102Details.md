<link href="styles.css?v=1" rel="stylesheet"/>

Modeling SEND Rule SD1002 in SHACL
-----------------------------------

# Data 

This example uses the DM domain data from the study "RE Function in Rats", located in the repository at [/data/studies/RE Function in Rats](https://github.com/phuse-org/SENDConform/tree/master/data/studies/RE%20Function%20in%20Rats) and converted to .TTL using the script [r\\DM-convert.R](https://github.com/phuse-org/SENDConform/blob/master/r/DM-convert.R). The R script adds observations to the original data in order to test the rule components. Test observations are identified by `subjid` and `usubjid` values containing the pattern 99T<n>, in contrast to the original study data values of 00M0<n>. See the [Data Conversion](DataConversion.md) page for details on how the data is converted to TTL.

Familiarity with the data structure is necessary to explain the constraints and test cases. Figure 1 illustrates a partial set of data for test subject subjid=99T1 where the end date precedes start date, thus violating the rule SD1002.

<img src="images/RefIntervalDataFail.PNG"/>
*Figure 1: Reference Interval for Animal 99T1 (incomplete data)*


The full data file used in developing this page is available here: [SHACL/CJ16050Constraints/DM-CJ16050-R.TTL](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints/DM-CJ16050-R.TT)


# SHACL Constraints

A detailed description of SHACL syntax is beyond the scope of this document. Please refer to the [SHACL Introduction](SHACL-Intro.md) page for a list of resources. 

The SHACL file [SHACL/CJ16050Constraints/SHACL-SD1002.TTL](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints/SHACL-SD1002.TTL) contains the constraints for this example. 


# FDA Rule SD1002

The SEND-IG 3.0 rule **SD1020** is defined in the file [FDA-Validator-Rules.xlsx](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx) as:

FDA Validator Rule ID | FDA Validator Message | Publisher|  Publisher ID | Business or Conformance Rule Validated | FDA Validator Rule  
------|-------------------|-----|-------|--------------------------|-----------------------------
**SD1002** |RFSTDTC is after RFENDTC | FDA| FDAB034    |Study Start and End Dates must be submitted and complete. | Subject Reference Start Date/Time (RFSTDTC) must be less than or equal to Subject Reference End Date/Time (RFENDTC)

The following Rule Components are defined based on the data, RDF data model, and SD1002 rule:

**1. Reference Start Date and End Date in xsd:date format**
**1. A Subject has one Reference Interval **
**1. A Reference Interval has one Start Date and one End Date**
**1. The SD1002 Rule itself: Start Date on or before End Date**

Translation of each Rule Component into SHACL and evaluation of Test data is described below.  Test cases and the values used to evaluate them are recorded in the file [TestCases.xlsx](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints/TestCases.xlsx)

# Document Conventions
 Color coding is used as a content guide. 

<div class='def'>
  <div class='def-header'>Description</div>
  A description of the Rule Component. 
</div>
 
 
<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  The rule in short form or pseudo code.
</div>
 

<pre class="shacl">
  SHACL Shape (full or partial)
</pre> 


<pre class="data">
   Example data in TTL format.
</pre>

<pre class="report">
  Excerpts from the SHACL Validation Report.
</pre>


# SD1002 Rule Translation into SHACL

<!--- RULE COMPONENT 1 ------------------------------------------------------->

## 1. Reference Start Date and End Date in xsd:date format

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

The SHACL shape `:DateFmtShape` is constructed using `sh:targetObjectsOf` to select the interval IRI as the (Subject) focus node. The two `sh:targetObjectsOf` follow these paths through the data to obtain the date values: 

<pre>
<font class='objectIRI'>Interval IRI</font> - - - <font class='predicate'>time:hasBeginning</font>  - - > <font class='objectIRI'>Date IRI</font> - - > <font class='predicate'>time:inXSDDate</font> - - > <font class='literal'>Date value</font>

<font class='objectIRI'>Interval IRI</font> - - - <font class='predicate'>time:hasEnd</font>  - - > <font class='objectIRI'>Date IRI</font> - - > <font class='predicate'>time:inXSDDate</font> - - > <font class='literal'>Date value</font>
</pre>

<pre class="shacl">
:DateFmtShape a sh:NodeShape ;
  sh:targetObjectsOf time:hasBeginning ;
  sh:targetObjectsOf time:hasEnd ;
  sh:or (
    [ sh:class study:ReferenceBegin ]
    [ sh:class study:ReferenceEnd ]
  ) ;  
  sh:prefixes [
    sh:declare [ sh:prefix "cj16050" ;
      sh:namespace "https://example.org/cj16050#"^^xsd:anyURI ;
    ]
  ] ;
  sh:property [
    sh:path time:inXSDDate ;  
    sh:datatype xsd:date ;
  ] .  
</pre>

The test data includes subject 99T4 with string for `rfendtc`. Not shown: Subject 9T10 with string for `rfstdtc`.
<pre class="data">
    cj16050:Interval_68bab561
      a                 study:ReferenceInterval ;
      time:hasBeginning cj16050:Date_2016-12-08 ;
      time:hasEnd       cj16050:Date_7-DEC-16 .
       
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

<br/><br/><br/>

<!--- RULE COMPONENT 2 ------------------------------------------------------->


## 2. Subject has one Reference Interval

This check determines if the Animal Subject has one and only one Reference Interval IRI. It is possible to have an Interval IRI with no start date and no end date (see [Data Conversion](DataConversion.md) for details). Test data only evaluates the case of missing Interval IRI. Multiple start/end dates for a single subject are evaluated in Rule Component 3. 

<div class='def'>
  <div class='def-header'>Description</div>
  Animal Subjects should have one and only one Reference Interval IRI.
</div>
 
 
<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  `:AnimalSubject`  `:hasReferenceInterval`  with `sh:minCount` and `sh:maxCount` of 1
</div>
 

<pre class="shacl">
:SubjectOneRefIntervalShape a sh:NodeShape ;
  sh:targetClass study:AnimalSubject ;
  sh:path study:hasReferenceInterval ;
  sh:minCount 1 ;
  sh:maxCount 1 .
</pre> 
<br/>

Data for 99T11 has no `study:hasReferenceInterval`
<pre class="data">
cj16050:Animal_6204e90c
    a                        study:AnimalSubject ;
    skos:prefLabel           "Animal 99T11"^^xsd:string ;
    study:hasSubjectID       cj16050:SubjectIdentifier_6204e90c ;
    study:hasUniqueSubjectID cj16050:UniqueSubjectIdentifier_6204e90c ;
    study:memberOf           cjprot:Set_00, code:Species_Rat ;
    study:participatesIn     cj16050:AgeDataCollection_6204e90c, cj16050:SexDataCollection_6204e90c .
</pre>

The report identifies the IRI `cj16050:Animal_6204e90c` , corresponding to Animal Subject 99T11.
<pre class="report">
a sh:ValidationReport ;
  sh:conforms false
  sh:result [
    a sh:ValidationResult ;
    sh:focusNode cj16050:<font class='error'>Animal_6204e90c</font>;
    sh:resultSeverity sh:Violation ;
    sh:sourceShape :SubjectOneRefIntervalShape ;
    sh:resultPath study:hasReferenceInterval ;
    sh:sourceConstraintComponent sh:MinCountConstraintComponent
  ] 
</pre>

<br/><br/>

***Rules 3-4 Coming Soon***

<!--- RULE COMPONENT 3 ------------------------------------------------------->

## 3. Reference Interval has one Start Date and one End Date

<div class='def'>
  <div class='def-header'>Description</div>

</div>
 
 
<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>

</div>
 

<pre class="shacl">

</pre> 


<pre class="data">

</pre>

<pre class="report">

</pre>

<!--- RULE COMPONENT 4 ------------------------------------------------------->


## 4. SD1002: Start Date on or before End Date

<div class='def'>
  <div class='def-header'>Description</div>

</div>
 
 
<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>

</div>
 

<pre class="shacl">

</pre> 


<pre class="data">

</pre>

<pre class="report">

</pre>


[Back to TOC](TableOfContents.md)
