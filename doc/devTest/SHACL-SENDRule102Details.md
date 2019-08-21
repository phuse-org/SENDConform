<link href="styles.css?v=1" rel="stylesheet"/>
<a name='top'></a>

Rule SD1002 : Reference Interval
==================================

The SEND-IG 3.0 rule **SD1002** is defined in the file [FDA-Validator-Rules.xlsx](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx) as:

FDA Validator Rule ID | FDA Validator Message | Publisher|  Publisher ID | Business or Conformance Rule Validated | FDA Validator Rule  
------|-------------------|-----|-------|--------------------------|-----------------------------
**SD1002** |RFSTDTC is after RFENDTC | FDA| FDAB034    |Study Start and End Dates must be submitted and complete. | **Subject Reference Start Date/Time (RFSTDTC) must be less than or equal to Subject Reference End Date/Time (RFENDTC)**

The following Rule Components are defined based on the data, RDF data model, and SD1002 rule:

**1. [Reference Start Date and End Date in xsd:date format](#rc1)**

**2. [A Subject has one Reference Interval](#rc2)**

**3. [A Reference Interval has one Start Date and one End Date](#rc3)**

**4. [The SD1002 Rule itself: Start Date on or before End Date](#rc4)**

Translation of each Rule Component into SHACL and evaluation of test data is described below. Test cases and data for evaluation purposes are recorded in the file [TestCases.xlsx](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints/TestCases.xlsx)


# Data Structure

Familiarity with the data structure is necessary to explain the constraints and test cases. **Figure 1** illustrates a partial set of data for test subject 99T1 where the Reference Interval end date *precedes* the start date, thus violating rule SD1002.

<a name='figure1'/>
  <img src="images/RefIntervalStructureDateFail.PNG"/>
  
  ***Figure 1: Reference Interval for Animal 99T1 (incomplete data)***
  
# Translation into SHACL

<!--- RULE COMPONENT 1 ------------------------------------------------------->
<a name='rc1'></a>

## 1. Reference Start Date and End Date in xsd:date format

<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  <code>rfstdtc</code> and <code>rfendtc</code> in <code>xsd:date</code> format.  
</div>


<div class='def'>
  <div class='def-header'>Description</div>
  Reference Start Date (RFSTDTC) and End Date (RFENDTC) must be in 
  <font class='emph'>date format</font>. The study in this example requires
  `xsd:date`. Other studies may use `xsd:dateTime` or a combination of `xsd:date` 
  and `xsd:dateTime`.
</div>


Refer back to [*Figure 1*](#figure1) to compare the data to the SHACL, below.  The shape `:DateFmtShape` uses `sh:targetObjectsOf` to begin evaluation at the <font class='object'>object</font> of the <font class='predicate'>predicates</font> `time:hasBeginning` and `time:hasEnd`. These <font class='object'>objects</font> must be of type `study:ReferenceBegin` or `study:ReferenceEnd` and have the <font class='predicate'>predicate</font> `time:inXSDDate` that leads to the date value that must be in `xsd:date` format.  

<pre>
<font class='nodeBold'>Interval IRI</font> - - - <font class='predicate'>time:hasBeginning</font>  - - > <font class='nodeBold'>Date IRI</font> - - > <font class='predicate'>time:inXSDDate</font> - - > <font class='literal'>Date value</font>

<font class='nodeBold'>Interval IRI</font> - - - <font class='predicate'>time:hasEnd</font>  - - > <font class='nodeBold'>Date IRI</font> - - > <font class='predicate'>time:inXSDDate</font> - - > <font class='literal'>Date value</font>
</pre>


Test data for Animal Subject 99T4 contains a string value for `rfendtc`. Not shown: Subject 9T10 with string value for `rfstdtc`.
<pre class='data'>

cj16050:Animal_68bab561
  a                          study:AnimalSubject ;
  skos:prefLabel             "Animal 99T4"^^xsd:string ;
  study:hasReferenceInterval cj16050:<font class='nodeBold'>Interval_68bab561</font> ;
  <font class='infoOmitted'>...</font>

cj16050:<font class='nodeBold'>Interval_68bab561</font>
  a                 study:ReferenceInterval ;
  time:hasBeginning cj16050:Date_2016-12-08 ;
  time:hasEnd       cj16050:<font class='nodeBold'>Date_7-DEC-16 </font> .
       
cj16050:<font class='nodeBold'>Date_7-DEC-16</font>
      a study:ReferenceEnd ;
      time:inXSDDate <font class='error'>"7-DEC-16"^^xsd:string</font> .
</pre>
<br/>

The shape tests the following conditions:

* A Reference Start Date must be in `xsd:date` format.
* A Reference End Date must be in `xsd:date` format.

<pre class='shacl'>
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
<br/>

The report correctly identifies the value '7-DEC-16' as a string, violating the xsd:date requirement.
<pre class='report'>
  a sh:ValidationReport ;
    sh:conforms false ;
    sh:result [
      a sh:ValidationResult ;
        sh:resultPath time:inXSDDate ;
        sh:resultSeverity sh:Violation ;
        sh:resultMessage "<font class='msg'>Date not in xsd:date format.</font>" ;
        sh:value "<font class='error'>7-DEC-16</font>" ;
        sh:sourceShape _:bnode_3c9cf811_13d4_43cb_b212_b7097d00b1ed_221 ;
        sh:sourceConstraintComponent sh:DatatypeConstraintComponent ;
        sh:focusNode <font class='nodeBold'>cj16050:Date_7-DEC-16 </font>;
    ]
</pre>
<br/><br/>

<!--- RULE COMPONENT 2 ------------------------------------------------------->
<a name='rc2'></a>

## 2. Subject has one Reference Interval

<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  <code>:AnimalSubject</code>  <code>:hasReferenceInterval</code>  with <code>sh:minCount</code> and <code>sh:maxCount</code> of 1
</div>

<div class='def'>
  <div class='def-header'>Description</div>
  Animal Subjects should have one and only one Reference Interval IRI.
</div>

This check determines if the Animal Subject has one and only one Reference Interval IRI. While it is possible to have an Interval IRI with no start date and no end date (see [Data Conversion](DataConversion.md)), this rule component only evaluates the case of missing Reference Interval IRIs. Multiple start/end dates for a single subject are evaluated in [Rule Component 3](#rc3). 

Test data for Animal Subject 99T11 has no `study:hasReferenceInterval` .
<pre class='data'>
cj16050:<font class='nodeBold'>Animal_6204e90c</font>
    a                        study:AnimalSubject ;
    skos:prefLabel           "<font class='nodeBold'>Animal 99T11</font>"^^xsd:string ;
    study:hasSubjectID       cj16050:SubjectIdentifier_6204e90c ;
    study:hasUniqueSubjectID cj16050:UniqueSubjectIdentifier_6204e90c ;
    study:memberOf           cjprot:Set_00, code:Species_Rat ;
    study:participatesIn     cj16050:AgeDataCollection_6204e90c, cj16050:SexDataCollection_6204e90c .
</pre>
<br/>

The shape tests the following conditions:

* An Animal Subject must have one and only one Reference Interval.
 
<pre class='shacl'>
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


The report identifies the IRI `cj16050:Animal_6204e90c` , corresponding to Animal Subject 99T11.
<pre class='report'>
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

<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  <code>study:ReferenceInterval</code> <code>time:hasBeginning</code> with <code>sh:minCount</code> and <code>sh:maxCount</code> of 1, <code>sh:and</code> <code>time:hasEnd</code> with <code>sh:minCount</code> and <code>sh:maxCount</code> of 1
</div>


<div class='def'>
  <div class='def-header'>Description</div>
  Each Reference interval should have one and only one start date and end date.
</div>

Reference interval IRIs are connected to their date values through the paths `time:hasBeginning` and `time:hasEnd`. A correctly formed interval has both start and end dates.

Test data provides the following violations:

* 99T5 missing rfendtc
* 99T9 missing rfstdtc
* 99T8 missing both rfendtc, rfstdtc
* 99T2 >1 rfstdtc, >1 rfendtc  

Only the data and report for 99T5 is shown here, where start date is present and end date is missing for the Reference Interval.
<pre class='data'>
cj16050:Animal_db3c6403
  a                          study:AnimalSubject ;
  skos:prefLabel             "Animal 99T5"^^xsd:string ;
  study:hasReferenceInterval cj16050:<font class='nodeBold'>Interval_db3c6403 </font> ;
  study:hasSubjectID         cj16050:SubjectIdentifier_db3c6403 ;
  study:hasUniqueSubjectID   cj16050:UniqueSubjectIdentifier_db3c6403 ;
  study:memberOf             cjprot:Set_00, code:Species_Rat ;
  study:participatesIn       cj16050:AgeDataCollection_db3c6403, cj16050:SexDataCollection_db3c6403 .

cj16050:<font class='nodeBold'>Interval_db3c6403</font>
  a                 study:ReferenceInterval ;
  skos:prefLabel    "Interval 2016-12-07 NA"^^xsd:string ;
  <font class='nodeBold'>time:hasBeginning cj16050:Date_2016-12-07 </font>.
</pre>
<br/>
 
The shape tests the following conditions:

* Reference Interval Start date for an Animal Subject has one and only one value.
* Reference Interval End date for an Animal Subject has one and only one value.

<pre class='shacl'>
:RefIntervalDateShape a sh:NodeShape ;
  sh:targetClass study:ReferenceInterval ;
  sh:name        "reference interval date count" ;
  sh:description "Interval has one and only one start and end date." ;
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
<br>

The report identifies the interval for Animal Subject 99T5 (`cj16050:Interval_db3c6403`) as violating the constraint.
<pre class='report'>
  a sh:ValidationResult ;
    sh:sourceConstraintComponent sh:AndConstraintComponent ;
    sh:focusNode cj16050:Interval_db3c6403 ;
    sh:resultMessage "<font class='msg'>Problem with Reference Interval date.</font>" ;
    sh:value cj16050:<font class='error'>Interval_db3c6403 </font> ;
    sh:sourceShape :RefIntervalDateShape ;
    sh:resultSeverity sh:Violation ;
</pre>
<br/>


<!--- RULE COMPONENT 4 ------------------------------------------------------->
<a name='rc4'></a>

## 4. SD1002: Start Date on or before End Date
<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  For interval, <code>! (?endDate >= ?beginDate )</code>
</div>


<div class='def'>
  <div class='def-header'>Description</div>
  Interval start date must be on or before end date. When the constraint is violated the report must display the <b>FDA Validator Message</b> "RFSTDTC is after RFENDTC"
</div>
 
Referring back to [**Figure 1**](#figure1), the reference start and end dates are not directly attached to either an Animal Subject or that Subject's Reference Interval IRI. This indirect connection makes the comparison of the two date values more complex, so SHACL-SPARQL is used in place of SHACL-Core. The SPARQL query is written to find cases where the end date is NOT greater than or equal to the start date.
Test data provides the following violations:

*  99T1  start date is after end date
*  99T2  multiple start/end date values, one start date is before one end date value
*  99T10 String value for rfstdtc results in a violation when comparing to rfendtc

Only the data and report for 99T1 is shown below.

<pre class='data'>
cj16050:Animal_184f16eb
    a study:AnimalSubject ;
    skos:prefLabel "Animal 99T1"^^xsd:string ;
    study:hasReferenceInterval cj16050:<font class='nodeBold'>Interval_184f16eb</font> ;
    study:hasSubjectID cj16050:SubjectIdentifier_184f16eb ;
    study:hasUniqueSubjectID cj16050:UniqueSubjectIdentifier_184f16eb ;
    study:memberOf cjprot:Set_00, code:Species_Rat ;
    study:participatesIn cj16050:AgeDataCollection_184f16eb, cj16050:SexDataCollection_184f16eb .

cj16050:<font class='nodeBold'>Interval_184f16eb</font>
    a study:ReferenceInterval ;
    skos:prefLabel "Interval 2016-12-07 2016-12-06"^^xsd:string ;
    time:hasBeginning cj16050:<font class='nodeBold'>Date_2016-12-07</font> ;
    time:hasEnd cj16050:<font class='nodeBold'>Date_2016-12-06</font> .


<font class='nodeBold'>cj16050:Date_2016-12-07</font>
    a study:ReferenceBegin ;
    skos:prefLabel "Date 2016-12-07"^^xsd:string ;
    time:inXSDDate "2016-12-07"^^xsd:date ;
    study:dateTimeInXSDString "<font class='error'>2016-12-07</font>"^^xsd:string .

<font class='nodeBold'>cj16050:Date_2016-12-06</font>
    a study:ReferenceEnd ;
    skos:prefLabel "Date 2016-12-06"^^xsd:string ;
    time:inXSDDate "2016-12-06"^^xsd:date ;
    study:dateTimeInXSDString "<font class='error'>2016-12-06</font>"^^xsd:string .
</pre>
<br/>

The shape tests the following condition:

* Reference Interval Start Date must be on or before End Date
* The shape will also pick up cases where a date is in `xsd:string` format.

<pre class='shacl'>
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
<br/>

The report identifies the interval for Animal Subject 99T1 where End Date precedes Start Date.
<pre class='report'>
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

