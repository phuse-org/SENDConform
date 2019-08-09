<link href="styles.css?v=1" rel="stylesheet"/>
<a name='top'></a>

Modeling FDA SEND-IG 3.0 Rule SD1002 in SHACL
==================================

# Data 

This example uses data from the demographics (DM) domain in the study "RE Function in Rats", located in the repository at [/data/studies/RE Function in Rats](https://github.com/phuse-org/SENDConform/tree/master/data/studies/RE%20Function%20in%20Rats) and converted to .TTL using the script [r/DM-convert.R](https://github.com/phuse-org/SENDConform/blob/master/r/DM-convert.R). The R script aligns date the graph schema used in this project and adds observations to test the rule components. Test observations are identified by `subjid` and `usubjid` values containing the pattern 99T<font class='parameter'>n</font>, in contrast to the original study data values of 00M0<n>. [Data Conversion](DataConversion.md) provides additional details.  

The complete data file is available here: [SHACL/CJ16050Constraints/DM-CJ16050-R.TTL](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints/DM-CJ16050-R.TTL) and instructions on how to create valdiation reports in Stardog is available on the  [Running Validation Reports](SHACL-RunValReport.md) page.

Familiarity with the data structure is necessary to explain the constraints and test cases. **Figure 1** illustrates a partial set of data for test subject 99T1 where the Reference Interval end date *precedes* the start date, thus violating rule SD1002.

<a name='figure1'/>
  <img src="images/RefIntervalDataFail.PNG"/>
  
  ***Figure 1: Reference Interval for Animal 99T1 (incomplete data)***
  


# SHACL Constraints

A detailed description of SHACL syntax is beyond the scope of this document. Please refer to the [SHACL Introduction](SHACL-Intro.md) page for a list of resources. 

The SHACL shapes described on this page are available in the file  [SHACL/CJ16050Constraints/SHACL-SD1002.TTL](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints/SHACL-SD1002.TTL). 


# FDA Rule SD1002

The SEND-IG 3.0 rule **SD1020** is defined in the file [FDA-Validator-Rules.xlsx](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx) as:

FDA Validator Rule ID | FDA Validator Message | Publisher|  Publisher ID | Business or Conformance Rule Validated | FDA Validator Rule  
------|-------------------|-----|-------|--------------------------|-----------------------------
**SD1002** |RFSTDTC is after RFENDTC | FDA| FDAB034    |Study Start and End Dates must be submitted and complete. | **Subject Reference Start Date/Time (RFSTDTC) must be less than or equal to Subject Reference End Date/Time (RFENDTC)**

The following Rule Components are defined based on the data, RDF data model, and SD1002 rule:

**1. [Reference Start Date and End Date in xsd:date format](#rc1)**

**2. [A Subject has one Reference Interval](#rc2)**

**3. [A Reference Interval has one Start Date and one End Date](#rc3)**

**4. [The SD1002 Rule itself: Start Date on or before End Date](#rc4)**

Translation of each Rule Component into SHACL and evaluation of test data is described below. Test cases and data for evaluation purposes are recorded in the file [TestCases.xlsx](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints/TestCases.xlsx)

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
<a name='rc1'></a>

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
  <pre>rfstdtc</pre> and <pre>rfendtc</pre> in <pre>xsd:date</pre> format.  
</div>

Refer back to [*Figure 1*](#figure1) to compare the data to the SHACL, below.  The shape `:DateFmtShape` uses `sh:targetObjectsOf` to begin evaluation at the <font class='object'>object</font> of the <font class='predicate'>predicates</font> `time:hasBeginning` and `time:hasEnd`. These <font class='object'>objects</font> must be of type `study:ReferenceBegin` or `study:ReferenceEnd` and have the <font class='predicate'>predicate</font> `time:inXSDDate` that leads to the date value that must be in `xsd:date` format.  

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
  ] ;
  sh:property [
    sh:path        time:inXSDDate ;  
    sh:datatype    xsd:date ;
    sh:name        "xsd:date format";
    sh:description "Date format as xsd:date.";
    sh:message     "Date not in xsd:date format."
  ] .  
</pre>

The test data includes subject 99T4 with a string value for `rfendtc`. Not shown: Subject 9T10 with string value for `rfstdtc`.
<pre class="data">
    cj16050:Interval_68bab561
      a                 study:ReferenceInterval ;
      time:hasBeginning cj16050:Date_2016-12-08 ;
      time:hasEnd       cj16050:Date_7-DEC-16 .
       
    cj16050:Date_7-DEC-16
      a study:ReferenceEnd ;
      time:inXSDDate <font class='error'>"7-DEC-16"^^xsd:string</font> .
</pre>


The report correctly identifies the value '7-DEC-16' as a string, violating the xsd:date requirement.
<pre class="report">
  a sh:ValidationReport ;
    sh:conforms false ;
    sh:result [
      a sh:ValidationResult ;
        sh:resultPath time:inXSDDate ;
        sh:resultSeverity sh:Violation ;
        sh:resultMessage "<font class="msg">Date not in xsd:date format.</font>" ;
        sh:value "<font class='error'>7-DEC-16</font>" ;
        sh:sourceShape _:bnode_3c9cf811_13d4_43cb_b212_b7097d00b1ed_221 ;
        sh:sourceConstraintComponent sh:DatatypeConstraintComponent ;
        sh:focusNode <font class='objectIRI'>cj16050:Date_7-DEC-16 </font>;
    ]
</pre>

<br/>

<!--- RULE COMPONENT 2 ------------------------------------------------------->
<a name='rc2'></a>

## 2. Subject has one Reference Interval

This check determines if the Animal Subject has one and only one Reference Interval IRI. While it is possible to have an Interval IRI with no start date and no end date (see [Data Conversion](DataConversion.md)), this rule component only evaluates the case of missing Referenece Interval IRIs. Multiple start/end dates for a single subject are evaluated in Rule Component 3. 

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
  sh:path        study:hasReferenceInterval ;
  sh:name        "reference interval present";
  sh:description "Animal Subject must have one and only one reference interval IRI.";
  sh:message     "Animal Subject does not have one Reference Interval IRI." ;
  sh:minCount 1 ;
  sh:maxCount 1 .
</pre> 
<br/>

Animal Subject 99T11 has no `study:hasReferenceInterval`
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
  sh:conforms false ;                                                                  
  sh:result [                                                                          
    a sh:ValidationResult ;                                                          
      sh:sourceShape :SubjectOneRefIntervalShape ;                                 
      sh:resultPath study:hasReferenceInterval ;                                   
      sh:resultSeverity sh:Violation ;                                             
      sh:focusNode cj16050:<font class='error'>Animal_6204e90c</font> ;                                       
      sh:resultMessage "<font class='msg'>Animal Subject does not have one Reference Interval IRI.</font>" ;
      sh:sourceConstraintComponent sh:MinCountConstraintComponent                  
  ]                                                                                    

</pre>

<br/><br/>


<!--- RULE COMPONENT 3 ------------------------------------------------------->
<a name='rc3'></a>

## 3. Reference Interval has one Start Date and one End Date

Reference interval IRIs are connected to their date values through the paths `time:hasBeginning` and `time:hasEnd`. A correctly formed interval has both start and end dates.

<div class='def'>
  <div class='def-header'>Description</div>
  Each Reference interval should have one and only one start date and end date.

</div>
 
 
<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  `study:ReferenceInterval` `time:hasBeginning` with `sh:minCount` and `sh:maxCount` of 1, `sh:and` `time:hasEnd` with `sh:minCount` and `sh:maxCount` of 1
</div>
 

<pre class="shacl">
:RefIntervalDateShape a sh:NodeShape ;
  sh:targetClass study:ReferenceInterval ;
  sh:name        "reference interval date count" ;
  sh:description "Interval has One and only one start and end date." ;
  sh:message     "Problem with Reference Interval date." ;
  sh:and (
    [ sh:path time:hasBeginning ;
      sh:minCount 1;
      sh:maxCount 1
    ]
    [
      sh:path time:hasEnd ;
      sh:minCount 1;
      sh:maxCount 1
    ]
 )
.
</pre> 

Test data provides the following violations:

* 99T5 missing rfendtc
* 99T9 missing rfstdtc
* 99T8 missing both rfendtc, rfstdtc
* 99T2 >1 rfstdtc, >1 rfendtc  

Only the data and report for 99T5 is shown here, where start date is present and end date is missing for the Reference Interval.
<pre class="data">
cj16050:Animal_db3c6403
    a study:AnimalSubject ;
    skos:prefLabel "Animal 99T5"^^xsd:string ;
    study:hasReferenceInterval <font class='goodData'>cj16050:Interval_db3c6403 </font> ;
    study:hasSubjectID cj16050:SubjectIdentifier_db3c6403 ;
    study:hasUniqueSubjectID cj16050:UniqueSubjectIdentifier_db3c6403 ;
    study:memberOf cjprot:Set_00, code:Species_Rat ;
    study:participatesIn cj16050:AgeDataCollection_db3c6403, cj16050:SexDataCollection_db3c6403 .

<font class='goodData'>cj16050:Interval_db3c6403</font>
    a study:ReferenceInterval ;
    skos:prefLabel "Interval 2016-12-07 NA"^^xsd:string ;
    <font class='goodData'>time:hasBeginning cj16050:Date_2016-12-07 </font>.
</pre>

Report for Animal Subject 99T5 (`cj16050:Interval_db3c6403`)
<pre class="report">
  a sh:ValidationResult ;
    sh:sourceConstraintComponent sh:AndConstraintComponent ;
    sh:focusNode cj16050:Interval_db3c6403 ;
    sh:resultMessage "<font class='msg'>Problem with Reference Interval date.</font>" ;
    sh:value cj16050:<font class='error'>Interval_db3c6403 </font> ;
    sh:sourceShape :RefIntervalDateShape ;
    sh:resultSeverity sh:Violation ;
</pre>



<!--- RULE COMPONENT 4 ------------------------------------------------------->
<a name='rc4'></a>

## 4. SD1002: Start Date on or before End Date


<div class='def'>
  <div class='def-header'>Description</div>
  Interval start date must be on or before end date. When the constraint is violated the report must display the **FDA Validator Message** "RFSTDTC is after RFENDTC"
</div>
 
 
<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  For interval, `! (?endDate >= ?beginDate )`
</div>
 
Referring back to [**Figure 1**](#figure1), the reference start and end dates are not directly attached to either an Animal Subject or that Subject's Reference Interval IRI. This indirect connection makes the comparison of the two date values more complex, so SHACL-SPARQL is used in place of SHACL-Core. The SPARQL query is written to find cases where the end date is NOT greater than or equal to the start date.

<pre class="shacl">
:SD1002RuleShape a sh:NodeShape ;
 sh:targetClass study:ReferenceInterval ;
 sh:sparql [
  a              sh:SPARQLConstraint ;
  sh:name        "sd1002" ;
  sh:description "SEND-IG 3.0 Rule SD1002. Reference Interval start date on or before end date." ;
  sh:message     "RFSTDTC is after RFENDTC";
  sh:prefixes [
    sh:declare [ sh:prefix "time" ;
      sh:namespace "http://www.w3.org/2006/time#"^^xsd:anyURI ;
    ],
    [ sh:prefix "study" ;
      sh:namespace "https://w3id.org/phuse/study#"^^xsd:anyURI ;
    ]  
  ] ;
 sh:select
  """SELECT $this (?beginDate AS ?intervalStart) (?endDate AS ?intervalEnd)
    WHERE {
      $this     time:hasBeginning  ?beginIRI ;
                time:hasEnd        ?endIRI .
      ?beginIRI time:inXSDDate     ?beginDate .
      ?endIRI   time:inXSDDate     ?endDate .
      FILTER  (! (?endDate >= ?beginDate ))
    }""" ;
] .
</pre> 

Test data provides the following violations:

*  99T1  start date is after end date
*  99T2  multiple start/end date values, one start date is before one end date value
*  99T10 String value for rfstdtc results in a violation when comparing to rfendtc

Only the data and report for 99T1 is shown below.

<pre class="data">
cj16050:Animal_184f16eb
    a study:AnimalSubject ;
    skos:prefLabel "Animal 99T1"^^xsd:string ;
    study:hasReferenceInterval cj16050:<font class='objectIRI'>Interval_184f16eb</font> ;
    study:hasSubjectID cj16050:SubjectIdentifier_184f16eb ;
    study:hasUniqueSubjectID cj16050:UniqueSubjectIdentifier_184f16eb ;
    study:memberOf cjprot:Set_00, code:Species_Rat ;
    study:participatesIn cj16050:AgeDataCollection_184f16eb, cj16050:SexDataCollection_184f16eb .

cj16050:<font class='objectIRI'>Interval_184f16eb</font>
    a study:ReferenceInterval ;
    skos:prefLabel "Interval 2016-12-07 2016-12-06"^^xsd:string ;
    time:hasBeginning cj16050:<font class='objectIRI'>Date_2016-12-07</font> ;
    time:hasEnd cj16050:<font class='objectIRI'>Date_2016-12-06</font> .


<font class='objectIRI'>cj16050:Date_2016-12-07</font>
    a study:ReferenceBegin ;
    skos:prefLabel "Date 2016-12-07"^^xsd:string ;
    time:inXSDDate "2016-12-07"^^xsd:date ;
    study:dateTimeInXSDString "<font class='error'>2016-12-07</font>"^^xsd:string .

<font class='objectIRI'>cj16050:Date_2016-12-06</font>
    a study:ReferenceEnd ;
    skos:prefLabel "Date 2016-12-06"^^xsd:string ;
    time:inXSDDate "2016-12-06"^^xsd:date ;
    study:dateTimeInXSDString "<font class='error'>2016-12-06</font>"^^xsd:string .
</pre>

<pre class="report">
  a sh:ValidationResult ;
  sh:sourceConstraint _:bnode_cacffc33_62e3_4c8b_bdba_e71e398a23dc_29 ;
  sh:sourceShape :SD1002RuleShape ;
  sh:resultMessage "<font class='msg'>RFSTDTC is after RFENDTC</font>" ;
  sh:value <font class='error'>cj16050:Interval_184f16eb</font>        ]
  sh:sourceConstraintComponent sh:SPARQLConstraintComponent ;
  sh:resultSeverity sh:Violation ;
  sh:focusNode cj16050:Interval_184f16eb 
</pre>


[Back to top of page](#top) 
<br/>
[Back to TOC](TableOfContents.md)

