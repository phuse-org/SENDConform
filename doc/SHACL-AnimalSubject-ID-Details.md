<link href="styles.css?v=1" rel="stylesheet"/>
<a name='top'></a>

Animal Subject Shape - USUBJID, SUBJID
==================================

<a name='ruleSD0083'></a>

##  **USUBJID** : FDA Rule SD0083

***Figure 1*** shows the connection from the Animal Subject IRI to the USUBJID and SUBJID IRI's along with the associated  SHACL Shapes and SEND Rules.

<a name='figure1'/>
  <img src="images/AnimalSubjectStructure.PNG"/>
  
  ***Figure 1: Animal Subject to ID Values, SHACL Shapes, FDA Rules***

The spreadsheet [FDA-Validator-Rules.xlsx](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx) defines the rule for USUBJID in the DM Domain as:

FDA Validator Rule ID | FDA Validator Message | Business or Conformance Rule Validated | FDA Validator Rule  
------|-------------------|--------------------------|-----------------------------
**SD0083** |Duplicate USUBJID | Identifier used to uniquely identify a subject across all studies| The value of Unique Subject Identifier (USUBJID) variable must be unique for each subject **across all trials in the submission.** *

\* *Because the prototype is based on data from a single trial, Rule SD0083 is only evaluated within the context of one study.*

The Rule is deconstructed into the following components based on familiarity with instance data, RDF data model (schema), and SD0083 rule statement:

**1. [An Animal Subject cannot have more than one USUBJID.](#rc12)**

**2. [An Animal Subject cannot have a missing USUBJID.](#rc12)**

**3. [A USUBJID cannot be assigned to more than one Animal Subject.](#rc3)**


Translation of Rule Components into SHACL and evaluation of test data is described below. The first two Rule Components are satisfied by a single SHACL Shape while a second shape is employed for the third component. Test cases in addition to those documented on these pages are available in the file [TestCases.xlsx](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints/TestCases.xlsx)

---
<a name='rc12'></a>

### Rule Components 1,2 : A single,non-missing USUBJID per Animal Subject.

<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  `:AnimalSubject` has a `sh:minCount` and `sh:maxCount` of 1 USUBJID.
</div>


<div class='def'>
  <div class='def-header'>Description</div>
  An Animal Subject must be assigned one and only one USUBJID. Missing and multiple USUBJID values are not allowed for an AnimalSubject.
</div>

Animal Subject 00M01 illustrates compliant data with a single USUBJID value.
<pre class='data'>
cj16050:Animal_037c2fdc
  a study:AnimalSubject ;
  skos:prefLabel "Animal 00M01"^^xsd:string ;
  <font class='goodData'>study:hasUniqueSubjectID cj16050:UniqueSubjectIdentifier_CJ16050_00M01 </font> ;
  <font class='infoOmitted'>...</font> 
</pre>
<br/>

The study ontology defines`study:AnimalSubject` as a sub class of both `study:Subject` and `study:Animal`.  Study subjects, be they animal or person, are assigned the identifiers USUBJID and SUBJID. Therefore, when the ontology is loaded into the database, the same constraint can be used for both pre-clinical (SEND) and clinical (SDTM) studies.  

<pre class='owl'>
<font class='nodeBold'>study:Subject</font>
  rdf:type owl:Class ;
  rdfs:subClassOf study:Party ;
  skos:prefLabel "Subject" ;
.
study:Animal
  rdf:type owl:Class ;
  rdfs:subClassOf study:BiologicEntity ;
  skos:prefLabel "Animal" ;
.
<font class='nodeBold'>study:AnimalSubject</font>
  rdf:type owl:Class ;
  rdfs:subClassOf study:Animal ;
  <font class='nodeBold'>rdfs:subClassOf study:Subject ;</font>
  skos:prefLabel "Animal subject" ;
.
</pre>
<br/>

The SHACL shape `study:hasMin1Max1Shape-USubjID` evaluates the path `study:hasUniqueSubjectID` from the targetClass to determine if one and only one value of USSUBJID IRI is present. When the ontology is loaded, the more general `study:Subject` can be leveraged as the targetClass. The commented-out alternative is also provided for when the ontology is not loaded, or for cases where the constraint should only apply to `study:AnimalSubject` and not other classes like `study:HumanSubject`.

<pre class='shacl'>
# Unique Subject ID (USUBJID)
study:hasMin1Max1Shape-USubjID 
  a              sh:NodeShape ;
  <font class='nodeBold'>sh:targetClass study:Subject</font> ;  <font class='greyedOut'># Ontology</font>
  <font class='greyedOut'># sh:targetClass study:AnimalSubject ; # No Ontology </font>
  sh:name        "minmaxUniqueSubjid" ;
  sh:description "A single, exclusive USUBJID must be assigned to a Subject." ;
  sh:message     "Subject --> USUBJID violation. [SD0083]" ;
  sh:path study:hasUniqueSubjectID ;
  sh:minCount  1 ;
  sh:maxCount  1 .
</pre>
<br/>

#### Test Case 1 : Animal Subject Assigned Two USUBJID values 

Test data for Animal Subject 99T11 (subject URI Animal_6204e90c) shows *two* USUBJID values: 
<pre class='data'>
  cj16050:Animal_6204e90c
    a                        study:AnimalSubject ;
    skos:prefLabel           "Animal 99T11"^^xsd:string ;
    study:hasUniqueSubjectID cj16050:<font class='error'>UniqueSubjectIdentifier_CJ16050-99T11B</font>,
                           cj16050:<font class='error'>UniqueSubjectIdentifier_CJ16050_99T11</font> ;
  <font class='infoOmitted'>...</font> 
</pre>

In violation of Rule Component 1 as detected by the constraint:

<pre class='shacl'>
  <font class='infoOmitted'>...</font> 
  <font class="nodeBold">sh:path study:hasUniqueSubjectID</font> ;
  sh:minCount  1 ;
  <font class="nodeBold">sh:maxCount  1 </font>
  <font class='infoOmitted'>...</font> 
</pre>

The Report correctly identifies Animal Subject Animal_6204e90c as having more than one USUBJID value, violating the MaxConstraintComponent of FDA Rule SD0083.
<pre class='report'>
  a sh:ValidationResult ;
    sh:resultSeverity            sh:Violation ;
    sh:sourceShape               study:hasMin1Max1Shape-USubjID ;
    sh:focusNode                 cj16050:<font class='error'>Animal_6204e90c </font>;
    sh:resultMessage             <font class='msg'>"Subject --> USUBJID violation. [SD0083]"</font> ;
    sh:resultPath                study:hasUniqueSubjectID ;
    sh:sourceConstraintComponent sh:<font class='nodeBold'>MaxCountConstraintComponent</font>
</pre>

The Reports lists the Animal Subject IRI which can be used in a SPARQL query to determine the USUBJID values. Source file: [/SPARQL/Animal-ID.rq](https://github.com/phuse-org/SENDConform/blob/master/SPARQL/Animal-ID.rq)
<pre class='sparql'>
  SELECT ?animalLabel ?usubjidLabel
  WHERE{
    cj16050:Animal_6204e90c study:hasUniqueSubjectID ?usubjidIRI ;
                            skos:prefLabel           ?animalLabel .
   ?usubjidIRI              skos:prefLabel           ?usubjidLabel .
  }
</pre>

SPARQL independently verifies  `Animal_6204e90c` as having more than one USUBJID. Source file: [/SPARQL/Animal-ID.rq](https://github.com/phuse-org/SENDConform/blob/master/SPARQL/Animal-ID.rq)
<pre class='sparql'>
  SELECT ?animalSubjectIRI (COUNT(?usubjidIRI) AS ?total) 
  WHERE{
    ?animalSubjectIRI a                        study:AnimalSubject ;
                      study:hasUniqueSubjectID ?usubjidIRI ;
                      skos:prefLabel           ?animalLabel .
    ?usubjidIRI       skos:prefLabel           ?usubjidLabel .
  } GROUP BY ?animalSubjectIRI
  HAVING (?total > 1)
</pre>

<br/>

#### Test Case 2 : Animal Subject has no USUBJID value
The AnimalSubject IRI `Animal_22218ae1` has no USUBJID (and no SUBJID).
<pre class='data'>
  cj16050:Animal_22218ae1
    a study:AnimalSubject ;
    study:hasReferenceInterval cj16050:Interval_22218ae1 ;
    study:memberOf cjprot:Set_00, code:Species_Rat ;
    study:participatesIn cj16050:AgeDataCollection_22218ae1, cj16050:SexDataCollection_22218ae1 .
</pre>

The SHACL is identical to Test Case 1. 

The Report correctly identifies AnimalSubject IRI `Animal_6204e90c` as violating the constraint, in this case have not USUBJID. 
<pre class='report'>
  a sh:ValidationResult ;                                                     
    sh:resultSeverity sh:Violation ;                                        
    sh:sourceShape study:hasMin1Max1Shape-USubjID ;
    sh:focusNode cj16050:<font class='error'>Animal_22218ae1c</font> ;
    sh:resultMessage <font class='msg'>"Subject --> USUBJID violation [SD0083]"</font> ;
    sh:resultPath study:hasUniqueSubjectID ;       
    sh:sourceConstraintComponent sh:<font class='nodeBold'>MaxCountConstraintComponent</font>            
</pre>

SPARQL independently confirms the report identifying `Animal_22218ae1c` as having no USUBJID. Source file: [/SPARQL/Animal-ID.rq](https://github.com/phuse-org/SENDConform/blob/master/SPARQL/Animal-ID.rq)

<pre class="sparql">
  SELECT ?animalIRI
  WHERE{
    ?animalIRI a study:AnimalSubject . 
    OPTIONAL{ ?animalIRI study:hasUniqueSubjectID ?usubjid . }
    FILTER(NOT EXISTS { ?animalIRI study:hasUniqueSubjectID ?usubjid. })
}
</pre>

<br/>

<!--- SD003 Rule Component 3 ------------------------------------------------->

---

<a name='rc3'></a>

### Rule Component 3: A USUBJID cannot be assigned to more than one Animal Subject

Implicit in the definition of USUBJID and Rule SD003 is the fact that the identifier should be assigned to one and only one Animal Subject.

Test data Animal Subjects Animal_252450f2 and Animal_2706cb1e have the same USUBJID values. 
<pre class='data'>
cj16050:<font class='nodeBold'>Animal_252450f2</font>
    a study:AnimalSubject ;
    skos:prefLabel "Animal 99DUP1"^^xsd:string ;
    study:hasUniqueSubjectID cj16050:<font class='error'>UniqueSubjectIdentifier_CJ16050_99DUP1</font> ;

cj16050:<font class='nodeBold'>Animal_2706cb1e</font>
    a study:AnimalSubject ;
    skos:prefLabel "Animal 99DUP1"^^xsd:string ;
    study:hasUniqueSubjectID cj16050:<font class='error'>UniqueSubjectIdentifier_CJ16050_99DUP1</font> ;
</pre>
<br/>


There are multiple ways to assess the USUBJID requirement in SHACL-Core and SHACL-SPARQL.  Two SHACL-Core alternatives are discussed here.

#### Method 1: **Identify USUBJIDs** assigned to multiple AnimalSubjects

<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  The target Object of the `sh:inversePath` for the predicate `study:hasUniqueSubjectID` must have a `sh:maxCount` of 1 .
</div>

<div class='def'>
  <div class='def-header'>Description</div>
  Targeting the Object of (`sh:targetObjectsOf `) the inverse of (`sh:inversePath`) the predicate `study:hasUniqueSubjectID` identifies USBUJID values that are assigned to more than one AnimalSubject. This test is the most informative when trying to quickly identify <i>duplicate USUBJID values</i>. 
</div>

SHACL Shape for Method 1: Identify duplicate USUBJID values. This shape is applied to all uses of the predicate `study:hasUniqueSubjectID`, allowing its use for both SEND and SDTM data sets when this predicates is present.  
<pre class='shacl'>
study:isUniqueShape-USubjID a sh:PropertyShape ; 
  <font class='nodeBold'>sh:targetObjectsOf study:hasUniqueSubjectID </font> ;
  sh:name            "uniqueUSubjid" ;
  sh:description     "A USUBJID must only be assigned to one Subject." ;
  sh:message         "USUBJID assigned to more than one Subject. [SD0083]" ;
  sh:property [
    <font class='nodeBold'>sh:path [sh:inversePath study:hasUniqueSubjectID]</font>  ;
    sh:maxCount 1
  ] .
</pre>
<br/>

A Report is not provided because Method 2 was chosen over Method 1 for the reasons described below. The corresponding SPARQL to identify the USUBJID IRIs assigned to multiple AnimalSubjects is provided for reference. Source file: [/SPARQL/Animal-ID.rq](https://github.com/phuse-org/SENDConform/blob/master/SPARQL/Animal-ID.rq)
<pre class='sparql'>
  SELECT ?usubjidIRI (COUNT(?animalSubjectIRI) AS ?total) 
  WHERE{
    ?animalSubjectIRI a                        study:AnimalSubject ;
                      study:hasUniqueSubjectID ?usubjidIRI ;
                      skos:prefLabel           ?animalLabel .
    ?usubjidIRI       skos:prefLabel           ?usubjidLabel .
  } GROUP BY ?usubjidIRI
  HAVING (?total > 1)
</pre>


#### Method 2: **Identify the AnimalSubjects** that have the same USUBJID
<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  The target *Class* `study:AnimalSubject` of the `sh:inversePath` of the predicate `study:hasUniqueSubjectID` must have a `sh:maxCount` of 1 .
</div>

<div class='def'>
  <div class='def-header'>Description</div>
  The subtle difference in Method 2 is that it identifies the AnimalSubject IRIs that have the same USUBJID, and not directly providing the SUBUJID value.

</div>

SHACL Shape for Method 2: Identify AnimalSubjects that have the same USUBJID value. Similar to [Rule Components 1,2](#rc12) it is once again possible to leverage an ontology to apply the constraint at the more general level of `study:Subject` targetClass. 
<pre class='shacl'>
study:isUniqueShape-USubjID a sh:PropertyShape ; 
  <font class='nodeBold'>sh:targetClass study:Subject</font> ;  <font class='greyedOut'># Ontology</font>
  <font class='greyedOut'># sh:targetClass study:AnimalSubject ; # No Ontology </font>
  sh:property [
    sh:name            "uniqueUSubjid" ;
    sh:description     "A USUBJID must only be assigned to one Subject." ;
    sh:message         "USUBJID assigned to more than one Subject. [SD0083]" ;
    <font class='nodeBold'>sh:path (study:hasUniqueSubjectID [sh:inversePath study:hasUniqueSubjectID]) </font>;
    sh:maxCount 1
  ] .
</pre>

***Method 2 was chosen for consistency with the other checks in this section that focus on the identification of AnimalSubjects that fail constraints.***

The report from Method 2 correctly identifies the Animal Subjects Animal_252450f2 and Animal_2706cb1e as sharing the same USUBJID.
<pre class='report'>
a sh:ValidationResult ;
  sh:sourceConstraintComponent sh:MaxCountConstraintComponent ;
  sh:focusNode cj16050:<font class='error'>Animal_252450f2 </font>;
  sh:sourceShape _:bnode_dc2d5e41_a650_456a_87ee_944f84cffae6_826 ;
  sh:resultPath ( study:hasUniqueSubjectID [
    sh:inversePath study:hasUniqueSubjectID
  ] ) ;
  sh:resultMessage "<font class='msg'>USUBJID assigned to more than one Subject. [SD0083]</font>" ;
  sh:resultSeverity sh:Violation

  <font class='infoOmitted'>...</font>
  
a sh:ValidationResult ;
  sh:sourceConstraintComponent sh:MaxCountConstraintComponent ;
  sh:focusNode cj16050:<font class='error'>Animal_2706cb1e</font> ;
  sh:sourceShape _:bnode_dc2d5e41_a650_456a_87ee_944f84cffae6_826 ;
  sh:resultPath ( study:hasUniqueSubjectID [
    sh:inversePath study:hasUniqueSubjectID
  ] ) ;
  sh:resultMessage "<font class='msg'>USUBJID assigned to more than one Subject. [SD0083]</font>" ;
  sh:resultSeverity sh:Violation ;
  
  <font class='infoOmitted'>...</font>
</pre>
<br/>
SPARQL independently verifies `Animal_252450f2` and `Animal_2706cb1e` share the same USUBJID (and consequently the same label for the AnimalSubject and USUBJID). Source file: [/SPARQL/Animal-ID.rq](https://github.com/phuse-org/SENDConform/blob/master/SPARQL/Animal-ID.rq)
<pre class='sparql'>
SELECT ?animalSubjectIRI ?animalSubjectIRI2 ?animalLabel ?usubjidLabel 
WHERE{
  ?animalSubjectIRI  study:hasUniqueSubjectID ?usubjidIRI ;
                     study:hasUniqueSubjectID ?usubjidIRI ;
                     skos:prefLabel           ?animalLabel .
  ?usubjidIRI        skos:prefLabel           ?usubjidLabel .

  ?animalSubjectIRI2 study:hasUniqueSubjectID ?usubjidIRI ;
                     study:hasUniqueSubjectID ?usubjid2IRI ;
  FILTER ( ?animalSubjectIRI != ?animalSubjectIRI2 )
}
</pre>

<br/>

--- 
<a name='ruleSD1001'></a>

##  **SUBJID** : FDA Rule SD1001


The spreadsheet [FDA-Validator-Rules.xlsx](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx) defines the rule for SUBJID in the DM Domain as:

FDA Validator Rule ID | FDA Validator Message | Business or Conformance Rule Validated | FDA Validator Rule  
------|-------------------|--------------------------|-----------------------------
**SD1001** |Duplicate SUBJID |'Subject identifier, which must be unique within the study.| The value of Subject Identifier for the Study (SUBJID) variable must be unique for each subject **within the study**.

The Rule Components and corresponding SHACL shapes for SD1001 are similar to those defined for <a href='#ruleSD0083'>USUBJID/SD0083</a> with exception of the predicate changing to `study:hasSubjectID`and result messages specific to SUBJID instead of USUBJID. Details for SD1001 are therefore not provided here. The SHACL is available in the Shapes file [SHACL-AnimalSubject.TTL](../SHACL/CJ16050Constraints/SHACL-AnimalSubject.TTL)


<b>Next: </b>[Reference Interval (FDA Rule SD1002)](SHACL-AnimalSubject-ReferenceInterval-Details.md)
<br/>
<br/>
Back to: 
* [Top of page](#top) <br/>
* [List of AnimalSubject Shapes](TableOfContents.md#animalSubjectShapes)
* [Table of Contents](TableOfContents.md)

