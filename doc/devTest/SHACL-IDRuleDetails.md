<link href="styles.css?v=1" rel="stylesheet"/>
<a name='top'></a>

Rule SD0083, SD1001 : SUBJID, USUBJID
==================================


Rules for Unique Subject Identifier (ussubjid) and Subject Identifier (subjid) and defined in the file [FDA-Validator-Rules.xlsx](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx) as:

FDA Validator Rule ID | FDA Validator Message | Publisher|  Publisher ID | Business or Conformance Rule Validated | FDA Validator Rule  
------|-------------------|-----|-------|--------------------------|-----------------------------
**SD0083** |Duplicate USUBJID | CDISC| CG0151   |Identifier used to uniquely identify a subject across all studies| The value of Unique Subject Identifier (USUBJID) variable must be unique for each subject **across all trials in the submission.**
**SD1001** |Duplicate SUBJID | CDISC| CG0150   |'Subject identifier, which must be unique within the study.| The value of Subject Identifier for the Study (SUBJID) variable must be unique for each subject **within the study**.

Because the prototype is based on data from a single trial, Rule SD0083 is only evaluated within the context of one study. Rules for both SD0083 and SD1001 therefore very similar, so ***only SD0083 for USUBJID is described in detail on this page***. Differences between the two rules include the naming of predicates (`study:hasSubjectID`, `study:hasUniqueSubjectID` ) and the FDA Validator Messsage, which necessitates separate shapes because `sh:message` is specific to a defined shape. 

The following Rule Components are defined based on the data, RDF data model, and SD0083 rule:

**1. [An Animal Subject cannot have more than one USUBJID](#rc1)**

**2. [An Animal Subject cannot have a missing USUBJID](#rc2)**

**3. [The same USUBJID can not be assigned to more than one Animal Subject](#rc3)**


Translation of each Rule Component into SHACL and evaluation of test data is described below. Test cases and data for evaluation purposes are recorded in the file [TestCases.xlsx](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints/TestCases.xlsx)


# SD0083 Rule Translation into SHACL

<!--- RULE COMPONENT 1 ------------------------------------------------------->
<a name='rc1'></a>

## 1. An Animal Subject cannot have more than one USUBJID

<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  <code>:AnimalSubject</code>  <code>:hasUniqueSubjectID</code>  with <code>sh:maxCount</code> of 1
</div>


<div class='def'>
  <div class='def-header'>Description</div>
  Animal Subject must have a maximum of one USUBJID.
</div>


Test data for Animal Subject 99T11 contains two USUBJID values.
<pre class='data'>
cj16050:Animal_6204e90c
  a                        study:AnimalSubject ;
  skos:prefLabel           "Animal 99T11"^^xsd:string ;
  study:hasUniqueSubjectID cj16050:<font class='error'>UniqueSubjectIdentifier_CJ16050-99T11B</font>,
                           cj16050:<font class='error'>UniqueSubjectIdentifier_CJ16050_99T11</font> ;
  <font class='infoOmitted'>...</font> 
</pre>
<br/>

A single shape tests all three Rule Component conditions. 


<pre class='shacl'>
study:hasMin1Max1Shape-USubjID 
  a              sh:NodeShape ;
  sh:targetClass study:AnimalSubject ;   
  sh:name        "minmaxUniqueSubjid" ;
  sh:description "Value of USUBJID must present/unique." ;
  sh:message     "USUBJID uniqueness violation" ;
  sh:path (study:hasUniqueSubjectID [sh:inversePath study:hasUniqueSubjectID]) ;
  sh:minCount  1 ;
  sh:maxCount  1 
.
</pre>
<br/>


The first two conditions

* An Animal Subject must have a maximum of one USUBJID   
    * `sh:maxCount 1`

* An Animal Subject must have a USUBJID   (USUBJID is missing)
    * `sh:minCount 1`
   
Th

The report correctly identifies xxxx, violating the XXXX requirement. 
<pre class='report'>
   # Report
</pre>
<br/><br/>

<!--- RULE COMPONENT 2 ------------------------------------------------------->
<a name='rc2'></a>

## 2.

<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  <code>:AnimalSubject</code>  <code>:hasUniqueSubjectID</code>  with <code>sh:minCount</code> of 1
  
</div>

<div class='def'>
  <div class='def-header'>Description</div>
  An Animal Subject must have a USUBJID.
</div>

This check determines if USUBJID is present.

Test data for Animal Subject :Animal_22218ae1, would have been referred to as 99T12 but both USUBJID and SUBJID are missing. SUBJID evaluated separately.

<pre class='data'>
cj16050:<font class='nodeBold'>Animal_22218ae1</font>
  a study:AnimalSubject ;
  study:hasReferenceInterval cj16050:Interval_22218ae1 ;
  study:memberOf cjprot:Set_00, code:Species_Rat ;
  study:participatesIn cj16050:AgeDataCollection_22218ae1, cj16050:SexDataCollection_22218ae1 .
</pre>
<br/>

The shape tests the following conditions:

* condition 1
 
<pre class='shacl'>

 # SHAPE 
 
</pre> 
<br/>


The report identifies the IRI xxxxx
<pre class='report'>

# REPORT                                                                               
</pre>
<br/><br/>


<!--- RULE COMPONENT 3 ------------------------------------------------------->
<a name='rc3'></a>

## 3. 

<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>

</div>


<div class='def'>
  <div class='def-header'>Description</div>

</div>

Only the data and report for 99TXXX is shown here, where xxxxxxx.
<pre class='data'>

 # DATA

</pre>
<br/>
 
The shape tests the following conditions:

* 1
* 2

<pre class='shacl'>

# SHACL


</pre> 
<br>

The report identifies the interval for Animal Subject 99T5 (`cj16050:Interval_db3c6403`) as violating the constraint.
<pre class='report'>
  # REPORT 

</pre>
<br/>




[Back to top of page](#top) 
<br/>
[Back to TOC](TableOfContents.md)

