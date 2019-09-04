<link href="styles.css?v=1" rel="stylesheet"/>
<a name='top'></a>

Animal Subject Shape - Demographics Domain 
==================================

## **Age** : Rules

***Figure 1*** shows the connection from the Animal Subject IRI to its Age value.

<a name='figure1'/>
  <img src="images/AgeStructure.PNG"/>
  
  ***Figure 1: Animal Subject Data Structure for Age***

The spreadsheet [FDA-Validator-Rules.xlsx](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx) defines numerous rules associated with Age in the DM domain. This project defines only a subset of these rules as SHACL Shapes. For example, the rule SD2019 "Invalid value for AGETXT" is not applicaple because the example study collects AGE (numeric) and not AGETXT (age range as a string). 

## Age >= 0:  FDA Rule SD0084

FDA Validator Rule ID | FDA Validator Message | Publisher|  Publisher ID | Business or Conformance Rule Validated | FDA Validator Rule  
------|-------------------|-----|-------|--------------------------|-----------------------------
**SD0084** |Negative value for age | xxx| xxx4    |Values for age variables cannot be negative, | **The value of Age (AGE) cannot be less than 0.**


### Rule Component

**1. [Value of AGE must be greater than or equal to 0. ](#rc1)**

# Data Structure

Refer back to **Figure 1** to see how age is indirectly associated with an AnimalSubject via a study:participatesIn predicate that leads to an outcome IRI that in turn contains the age value and units. Most subjects in the study are the same age (8 Weeks), resulting in a small number of tests in outcome IRIs instead of traditional tests on each age value associated with an Animal Subject.

  
# Translation into SHACL

<!--- RULE COMPONENT 1 ------------------------------------------------------->
<a name='rc1'></a>

## Rule Component 1. Value of AGE must be greater than or equal to 0.

<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  <code>age</code> <code>sh:minInclusive</code> 0.  
</div>

<div class='def'>
  <div class='def-header'>Description</div>
  The Age value must be greater than or equal to 0. While this study has not age=0, the check is constructed to satisify the FDA rule. 
</div>


The age for Animal Subject 99T1 was set to -10 for testing. 
<pre class='data'>
  cj16050:Animal_184f16eb
    a                    study:AnimalSubject ;
    study:participatesIn cj16050:<font class='nodeBold'>AgeDataCollection_184f16eb</font>,
  <font class='infoOmitted'>...</font>
  
  cj16050:<font class='nodeBold'>AgeDataCollection_184f16eb</font>
    a            code:AgeDataCollection ;
    code:outcome cj16050:<font class='nodeBold'>Age_-10_WEEKS </font>.
  
  cj16050:<font class='nodeBold'>Age_-10_WEEKS</font>
    a                     study:Age ;
    time:hasXSDDuration  "P56D"^^xsd:duration ;
    time:numericDuration <font class='error'>-10 </font>;
    time:unitType        time:unitWeek .
</pre>
<br/>

The shape tests the following condition:

* An Age value must be >= 0


<pre class='shacl'>
  study:hasminInclusive0Shape-Age a sh:NodeShape ;
    sh:targetClass study:Age ;
    sh:name        "agGTE0" ;
    sh:description "Age must be greater than or equal to 0." ;
    sh:message     "Negative value for AGE.  [SD0084]" ;
    sh:property [
      sh:path time:numericDuration ;
              sh:minInclusive 0 ;
    ] .

</pre>
<br/>

The report correctly identifies the value '-10'.
<pre class='report'>
  a sh:ValidationReport ;
    sh:result [
      a sh:ValidationResult ;
        sh:sourceConstraintComponent sh:MinInclusiveConstraintComponent ;
        sh:sourceShape [] ;
        sh:focusNode <font class='nodeBold'>cj16050:Age_-10_WEEKS </font>;
        sh:resultPath time:#numericDuration ;
        sh:value <font class='error'>-10</font> ;
        sh:resultSeverity sh:Violation
    ] ;
    sh:conforms false
</pre>
<br/><br/>

The report lists the Age value and Age outcome IRI, but not the AnimalSubject associated with the offending value. SPARQL can be used to identify the Animal Subject using the Age Outcome IRI identified in teh report.  Source file: [/SPARQL/Animal-Age-LT0.rq](https://github.com/phuse-org/SENDConform/blob/master/SPARQL/Animal-Age-LT0.rq)
<pre class='sparql'>
  SELECT ?animalLabel 
  WHERE{
    ?ageDataCollIRI   code:outcome cj16050:<font class='nodeBold'>Age_-10_WEEKS </font>.
  
    ?AnimalSubjectIRI study:participatesIn ?ageDataCollIRI ;
                      skos:prefLabel       ?animalLabel .
  }
</pre>

Another approach is to identify the Animal Subject using a SPARQL filter for  `age < 0`.  Source file: [/SPARQL/Animal-Age-LT0.rq](https://github.com/phuse-org/SENDConform/blob/master/SPARQL/Animal-Age-LT0.rq)

<pre class='sparql'>
  SELECT ?animalIRI ?animalLabel ?age
  WHERE{
    ?animalIRI       study:participatesIn ?ageDataCollIRI ;
                     skos:prefLabel       ?animalLabel .
    ?ageDataCollIRI  code:outcome         ?ageIRI .
    ?ageIRI          time:numericDuration ?age .
    FILTER (<font class='nodeBold'>?age < 0</font>)
  }
</pre>
<br/>

<b>Next:</b>  Next Section TBD. 
<br/>
<br/>
Back to [Top of page](#top) <br/>
Back to [Table of Contents](TableOfContents.md)