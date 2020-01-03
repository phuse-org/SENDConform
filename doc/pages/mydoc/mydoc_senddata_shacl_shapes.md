---
title: SHACL Shapes for SEND Data
last_updated: 2020-01-02
permalink: mydoc_senddata_shacl_shapes.html
sidebar: mydoc_sidebar
folder: mydoc
---

## Introduction
The project strives to define a core set of re-usable, hierarchical shapes for use in a variety of data validation scenarios spanning the data lifecycle from data collection through to submission and reporting.  The first shapes to be defined by the project come from the Demographics (DM) domain, where the AnimalSubject shape is a primary focus.

## Animal Subject Shape

The Animal Subject IRI <code>:Animal_<font class='parameter'>xxx</font></code> is a natural starting point for developing rules based on the Demographics domain because each row in the source DM data contains values for an individual Animal Subject.  The Animal Subject Shape definitions are located in this file:

* AnimalSubjectShape  [SHACL/CJ16050Constraints/SHACL-AnimalSubject.TTL](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints/SHACL-AnimalSubject.TTL).

SHACL shapes are created with reuse in mind, as reflected in both the structure and naming conventions. Where practical, shapes are named using a description of their function plus the word `Shape` followed by a dash and then an abbreviated name of the class or entity they act upon. Examples:

* `hasMin1Max1Shape-USubjID` - validates that each Animal Subject has a minimum of one and maximum of one USUBJID value.  
* `isUniqueShape-USubjID`    - validates the *uniqueness* of USUBJID values. A USUBJID cannot be assigned to more than one Animal Subject.

Shapes may include additional constraints such as data type, length, and other restrictions not explicitly stated in the original FDA rules.

The `sh:message` property provides meaningful messages about violations when they are detected. Where applicable, the related FDA Rule ID number is provided in square brackets at the end of the message text. In cases where a shape may be applied to more than one Rule, all rules covered by that shape are listed.

Example:  <code>sh:message "Subject --> USUBJID violation. <b>[SD0083]</b>" ;</code>

A shape is created to define the constraints attached to the Animal Subject IRI. Each individual constraint is described in the sections that follow.

<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
   One <code>sh:property</code> for each type of <code>predicate</code> ----> <code>object</code> relation attached directly to the AnimalSubject IRI.
</div>

<div class='def'>
  <div class='def-header'>Description</div>
  Each type of <code>predicate ----> object </code> relation for the AnimalSubject class, with the exception of predicates like `rdf:type`, `skos:prefLabel`, etc.,  has a `sh:property` definition for a shape that validates that type of entity.
</div>

Test data for Animal Subject 00M01 illustrates the predicates and objects attached to an AnimalSubject IRI.
<pre class='data'>
cj16050:Animal_037c2fdc
    a                          study:AnimalSubject ;
    skos:prefLabel             "Animal 00M01"^^xsd:string ;
    study:hasUniqueSubjectID   cj16050:UniqueSubjectIdentifier_CJ16050_00M01 ;
    study:hasSubjectID         cj16050:SubjectIdentifier_00M01 ;
    study:hasReferenceInterval cj16050:Interval_037c2fdc ;
    study:memberOf             cjprot:Set_00,
                               code:Species_Rat ;
    study:participatesIn       cj16050:SexDataCollection_037c2fdc ,
                               cj16050:AgeDataCollection_037c2fdc,
                               cj16050:Randomization_037c2fdc .
</pre>
<br/>

The Node Shape `study:AnimalSubjectShape` describes nodes of the class `study:AnimalSubject` . FDA Rule numbers are added as comments to facilitate referencing back to the original FDA requirements.

<pre class='shacl'>
study:AnimalSubjectShape
  a              <font class='nodeBold'>sh:NodeShape </font>;
  <font class='nodeBold'>sh:targetClass study:AnimalSubject </font>;
  sh:property    study:hasMin1Max1Shape-USubjID ;        # Rule SD0083
  sh:property    study:isUniqueShape-USubjID ;           # Rule SD0083
  sh:property    study:hasMin1Max1Shape-SubjID ;         # Rule SD1001
  sh:property    study:isUniqueShape-SubjID ;            # Rule SD1001
  sh:property    study:hasTypeXsdDate-Date ;             # Rule SD1002
  sh:property    study:hasMin1Max1Shape-Interval ;       # Rule SD1002
  sh:property    study:hasMin1Max1Shape-StartEndDates ;  # Rule SD1002
  sh:property    study:hasStartLEEndShape-Interval ;     # Rule SD1002
  sh:property    study:hasMinInclusive0Shape-Age ;       # Rule SD0084


  <font class='infoOmitted'>... more property shapes will be added as they are developed</font>
</pre>

If an ontology defines `study:AnimalSubject` as a subclass of `study:Subject`, then shapes could use the `sh:targetClass` `study:Subject` (assuming common constraints for both classes.) If a clinical trial on human study subjects were to define a `study:HumanStudySubject` as a subclass of `study:Subject`, the same constraints could be used for both pre-clinical (non-human animals) and clinical (human) data validation. This work focusses on SEND, so the target class `study:AnimalSubject` is specified for simplicity.

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

## Subject Identifiers

***Figure 1*** shows the connections from the Animal Subject IRI to the USUBJID and SUBJID IRI values.

<a name='figure1'/>
  <img src="images/AnimalSubjectStructure.PNG"/>

  ***Figure 1: Animal Subject Node to ID Values***

### USUBJID <a name='ruleSD0083'></a>

<font class='FDARule'>FDA Rule SD0083</font>

The spreadsheet [FDA-Validator-Rules.xlsx](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx) defines the rule for USUBJID in the DM Domain as:

FDA Validator Rule ID | FDA Validator Message | Business or Conformance Rule Validated | FDA Validator Rule  
------|-------------------|--------------------------|-----------------------------
**SD0083** |Duplicate USUBJID | Identifier used to uniquely identify a subject across all studies| The value of Unique Subject Identifier (USUBJID) variable must be unique for each subject **across all trials* in the submission.**

\* *Because the prototype is based on data from a single trial, Rule SD0083 is only evaluated within the context of a single study.*

The Rule is deconstructed into the following components based on knowledge of the study data requirements, RDF data model (schema), and SD0083 rule statement:

**1. [An Animal Subject cannot have more than one USUBJID.](#rc12)**

**2. [An Animal Subject cannot have a missing USUBJID.](#rc12)**

**3. [A USUBJID cannot be assigned to more than one Animal Subject.](#rc3)**


Translation of Rule Components into SHACL and evaluation of test data is described below. The first two Rule Components are satisfied by a single SHACL Shape while a second shape is employed for the third component. Test cases in addition to those documented on these pages are available in the file [TestCases.xlsx](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints/TestCases.xlsx)

---

<font class='ruleComponent'>Rule Components 1,2 : A single, non-missing USUBJID per Animal Subject.</font> <a name='rc12'></a>

<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  <font class='code'>:AnimalSubject</font> has a <font class='code'>sh:minCount</font> and <font class='code'>sh:maxCount</font> of 1 USUBJID.
</div>


<div class='def'>
  <div class='def-header'>Description</div>
  An Animal Subject must be assigned one and only one USUBJID. Missing and multiple USUBJID values are not allowed for an AnimalSubject.
</div>

Animal Subject 00M01 illustrates compliant data with a single USUBJID value.
<pre class='data'>
  cj16050:Animal_037c2fdc
    a                        study:AnimalSubject ;
    skos:prefLabel           "Animal 00M01"^^xsd:string ;
    <font class='goodData'>study:hasUniqueSubjectID cj16050:UniqueSubjectIdentifier_CJ16050_00M01 </font> ;
  <font class='infoOmitted'>...</font>
</pre>
<br/>

The SHACL shape `study:hasMin1Max1Shape-USubjID` evaluates AnimalSubject via its attachment to the parent `study:AnimalSubjectShape`. It evaluates the path `study:hasUniqueSubjectID` from the targetClass to determine if one and only one value of USUBJID IRI is present.

<pre class='shacl'>
study:AnimalSubjectShape
  a              sh:NodeShape ;
  sh:targetClass study:AnimalSubject
  <font class='nodeBold'>sh:property    study:hasMin1Max1Shape-USubjID </font> ;       

 <font class='infoOmitted'>...</font>

#--- Unique Subject ID (USUBJID) ----
study:<font class='nodeBold'>hasMin1Max1Shape-USubjID </font>
  a              sh:PropertyShape ;
  sh:name        "minmaxUniqueSubjid" ;
  sh:description "A single, exclusive USUBJID must be assigned to a Subject." ;
  sh:message     "Subject --> USUBJID violation. [SD0083]" ;
  <font class='nodeBold'>sh:path        study:hasUniqueSubjectID </font>;
  sh:minCount    1 ;
  sh:maxCount    1 .
</pre>
<br/>

Test Case 1 : Animal Subject Assigned Two USUBJID values

Test data for Animal Subject 99T11 (subject URI Animal_6204e90c) shows *two* USUBJID values:
<pre class='data'>
  cj16050:Animal_6204e90c
    a                        study:AnimalSubject ;
    skos:prefLabel           "Animal 99T11"^^xsd:string ;
    study:hasUniqueSubjectID cj16050:<font class='error'>UniqueSubjectIdentifier_CJ16050-99T11B</font>,
                             cj16050:<font class='error'>UniqueSubjectIdentifier_CJ16050_99T11</font> ;
  <font class='infoOmitted'>...</font>
</pre>

Violation of Rule Component 1 as detected by the `sh:maxCount` constraint:

<pre class='shacl'>
  <font class='infoOmitted'>...</font>
  <font class="nodeBold">sh:path study:hasUniqueSubjectID</font> ;
  sh:minCount  1 ;
  <font class="nodeBold">sh:maxCount  1 </font>
  <font class='infoOmitted'>...</font>
</pre>

The Report correctly identifies AnimalSubject Animal_6204e90c as having more than one USUBJID value, violating the MaxConstraintComponent of FDA Rule SD0083.
<pre class='report'>
  a sh:ValidationResult ;
    sh:resultSeverity            sh:Violation ;
    sh:sourceShape               study:hasMin1Max1Shape-USubjID ;
    sh:focusNode                 cj16050:<font class='error'>Animal_6204e90c </font>;
    sh:resultMessage             <font class='msg'>"Subject --> USUBJID violation. [SD0083]"</font> ;
    sh:resultPath                study:hasUniqueSubjectID ;
    sh:sourceConstraintComponent sh:<font class='nodeBold'>MaxCountConstraintComponent</font>
</pre>

The AnimalSubject IRI in the Report can be use to identify the USUBJID value that violates the constraint.  File: [/SPARQL/USUBJID-RC1RC2-TC1-Info.rq](https://github.com/phuse-org/SENDConform/blob/master/SPARQL/USUBJID-RC1RC2-TC1-Info.rq)

<pre class='sparql'>
 SELECT ?animalIRI ?animalLabel ?usubjidLabel
  WHERE{
    cj16050:<font class="nodeBold">Animal_6204e90c</font>   study:hasUniqueSubjectID ?usubjidIRI ;
                              skos:prefLabel           ?animalLabel .
     ?usubjidIRI              skos:prefLabel           ?usubjidLabel .
     BIND(IRI(cj16050:Animal_6204e90c) AS ?animalIRI )
}</pre>

The query result shows Animal 99T11 is assigned two `usubjid`, in violation of the rule.

<pre class='queryResult'>
  animalIRI                  <b>animalLabel       usubjidLabel</b>
  cj16050:<font class='nodeBold'>Animal_6204e90c</font>    "Animal 99T11"    <font class='error'>"CJ16050-99T11B"</font>
  cj16050:<font class='nodeBold'>Animal_6204e90c</font>    "Animal 99T11"    <font class='error'>"CJ16050_99T11"</font>
</pre>


<font class='verify'>Verify</font>

SPARQL independently verifies `Animal_6204e90c` as having two USUBJID values. File: [/SPARQL/USUBJID-RC1RC2-TC1-Verify.rq](https://github.com/phuse-org/SENDConform/blob/master/SPARQL/USUBJID-RC1RC2-TC1-Verify.rq)
<pre class='sparql'>
 SELECT ?animalSubjectIRI ?animalLabel (COUNT(?usubjidIRI) AS ?total)
  WHERE{
    ?animalSubjectIRI a                        study:AnimalSubject ;
                      study:hasUniqueSubjectID ?usubjidIRI ;
                      skos:prefLabel           ?animalLabel .
    ?usubjidIRI       skos:prefLabel           ?usubjidLabel .
  } GROUP BY ?animalSubjectIRI ?animalLabel
    HAVING (?total != 1)
</pre>


<pre class='queryResult'>
  <b>animalSubjectIRI           animalLabel      total</b>
  cj16050:Animal_6204e90c    "Animal 99T11"   <font class='error'>2</font>
</pre>

<br/>



Test Case 2 : Animal Subject has no USUBJID value
The AnimalSubject IRI `Animal_22218ae1` has no USUBJID (and no SUBJID).
<pre class='data'>
  cj16050:Animal_22218ae1
    a study:AnimalSubject ;
    study:hasReferenceInterval cj16050:Interval_22218ae1 ;
    study:memberOf cjprot:Set_00, code:Species_Rat ;
    study:participatesIn cj16050:AgeDataCollection_22218ae1, cj16050:SexDataCollection_22218ae1 .
</pre>

The SHACL is identical to Test Case 1.

The Report correctly identifies AnimalSubject IRI `Animal_6204e90c` as violating the constraint, in this case missing USUBJID.
<pre class='report'>
  a sh:ValidationResult ;                                                     
    sh:resultSeverity sh:Violation ;                                        
    sh:sourceShape study:hasMin1Max1Shape-USubjID ;
    sh:focusNode cj16050:<font class='error'>Animal_22218ae1c</font> ;
    sh:resultMessage <font class='msg'>"Subject --> USUBJID violation [SD0083]"</font> ;
    sh:resultPath study:hasUniqueSubjectID ;       
    sh:sourceConstraintComponent sh:<font class='nodeBold'>MaxCountConstraintComponent</font>            
</pre>

The AnimalSubject IRI in the Report can be use to identify the value of Predicates and Objects attached to the AnimalSubject IRI in facilitate identification of the problematic record, since a missing USUBJID means no `skos:prefLabel` is available. File: [/SPARQL/USUBJID-RC1RC2-TC2-Info.rq](https://github.com/phuse-org/SENDConform/blob/master/SPARQL/USUBJID-RC1RC2-TC2-Info.rq)

<pre class="sparql">
  SELECT ?animalIRI ?p ?o
  WHERE{
    cj16050:<font class='nodeBold'>Animal_22218ae1</font> ?p ?o .
    BIND(IRI(cj16050:Animal_6204e90c) AS ?animalIRI )
  }
</pre>

<pre class='queryResult'>
<b>animalIRI                 p                            o</b>
cj16050:Animal_6204e90c   rdf:type                     study:AnimalSubject
cj16050:Animal_6204e90c   study:hasReferenceInterval   cj16050:Interval_22218ae1
cj16050:Animal_6204e90c   study:memberOf               cjprot:#Set_00
cj16050:Animal_6204e90c   study:memberOf               code:Species_Rat
cj16050:Animal_6204e90c   study:participatesIn         cj16050:AgeDataCollection_22218ae1
cj16050:Animal_6204e90c   study:participatesIn         cj16050:SexDataCollection_22218ae1
</pre>


<font class='verify'>Verify</font>

SPARQL independently confirms the report identifying `Animal_22218ae1c` as having no USUBJID. Because `usubjid` is used as the `skos:prefLabel` for AnimalSubject, there is not label to return when `usubjid` is missing. File: [/SPARQL/USUBJID-RC1RC2-TC2-Verify.rq](https://github.com/phuse-org/SENDConform/blob/master/SPARQL/USUBJID-RC1RC2-TC2-Verify.rq)

<pre class="sparql">
  SELECT ?animalIRI
  WHERE{
    ?animalIRI a study:AnimalSubject .
    OPTIONAL{ ?animalIRI study:hasUniqueSubjectID ?usubjid . }
    FILTER(NOT EXISTS { ?animalIRI study:hasUniqueSubjectID ?usubjid. })
}
</pre>

<pre class='queryResult'>
animalIRI
cj16050:<font class='error'>Animal_22218ae1</font>
</pre>


<br/>

<!--- SD003 Rule Component 3 ------------------------------------------------->

---

<a name='rc3'></a>

<font class='ruleComponent'>Rule Component 3: A USUBJID cannot be assigned to more than one Animal Subject</font>

Implicit in the definition of USUBJID and Rule SD003 is the fact that the identifier should be assigned to one and only one Animal Subject.

In the test data, Animal Subjects Animal_252450f2 and Animal_2706cb1e have the same USUBJID values.
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

Method 1: **Identify USUBJIDs** assigned to multiple AnimalSubjects

<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  The target Object of the <font class='code'>sh:inversePath</font> for the predicate <font class='code'>study:hasUniqueSubjectID</font> must have a <font class='code'>sh:maxCount</font> of 1 .
</div>

<div class='def'>
  <div class='def-header'>Description</div>
  Targeting the Object of (<font class='code'>sh:targetObjectsOf</font>) the inverse of (<font class='code'>sh:inversePath</font>) the predicate <font class='code'>study:hasUniqueSubjectID</font> identifies USBUJID values that are assigned to more than one AnimalSubject. This test is the most informative when trying to quickly identify <i>duplicate USUBJID values</i>.
</div>

SHACL Shape for Method 1: Identify duplicate USUBJID values. This shape is applied to all uses of the predicate `study:hasUniqueSubjectID`, allowing its use for both SEND and SDTM data sets when this predicate is present.  
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
A Report is not provided because Method 2 was chosen over Method 1 for the reasons described below.

<br/>

Method 2: **Identify the AnimalSubjects** that have the same USUBJID

<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  The target *Class* <font class='code'>study:AnimalSubject</font> of the <font class='code'>sh:inversePath</font> of the predicate <font class='code'>study:hasUniqueSubjectID</font> must have a <font class='code'>sh:maxCount</font> of 1 .
</div>

<div class='def'>
  <div class='def-header'>Description</div>
  The subtle difference in Method 2 is that it identifies the AnimalSubject IRIs that have the same USUBJID, and not directly providing the SUBUJID value.

</div>

Method 2 uses a property shape assigned to the `AnimalSubjectShape` and some magic around the path `study:hasUniqueSubjectID`.
<pre class='shacl'>
  # Animal Subject Shape
  study:AnimalSubjectShape
    a              sh:NodeShape ;
    sh:targetClass study:AnimalSubject
    sh:property    study:hasMin1Max1Shape-USubjID  ;       
    <font class='nodeBold'>sh:property    study:isUniqueShape-USubjID</font>
    <font class='infoOmitted'>...</font>

<font class='nodeBold'>study:isUniqueShape-USubjID </font>
  a  sh:PropertyShape ;
    sh:name            "uniqueUSubjid" ;
    sh:description     "A USUBJID must only be assigned to one Subject." ;
    sh:message         "USUBJID assigned to more than one Subject. [SD0083]" ;
    <font class='nodeBold'>sh:path (study:hasUniqueSubjectID [sh:inversePath study:hasUniqueSubjectID]) ;
    sh:maxCount 1 </font>;
   .
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

Use the AnimalSubject IRI values to identify the `usubjid`. File: [/SPARQL/USUBJID-RC3-M2-Info.rq](https://github.com/phuse-org/SENDConform/blob/master/USUBJID-RC3-M2-Info.rq)
<pre class='sparql'>
  SELECT ?animalIRI ?animalLabel ?usubjid
  WHERE{
    {
      cj16050:<font class='nodeBold'>Animal_252450f2</font> study:hasUniqueSubjectID ?usubjidIRI ;
                            skos:prefLabel           ?animalLabel .
      ?usubjidIRI             skos:prefLabel           ?usubjid .
      BIND(IRI(cj16050:Animal_6204e90c) AS ?animalIRI )
    }
    UNION
    {
      cj16050:<font class='nodeBold'>Animal_2706cb1e</font> study:hasUniqueSubjectID ?usubjidIRI ;
                              skos:prefLabel           ?animalLabel .
      ?usubjidIRI             skos:prefLabel           ?usubjid .
      BIND(IRI(cj16050:Animal_2706cb1e) AS ?animalIRI )
    }
  }
</pre>

<pre class='queryResult'>
  <b>animalIRI                   animalLabel       usubjid</b>
  cj16050:Animal_6204e90c	  "Animal 99DUP1"	  <font class='error'>"CJ16050_99DUP1"</font>
  cj16050:Animal_2706cb1e	  "Animal 99DUP1"	  <font class='error'>"CJ16050_99DUP1"</font>
</pre>



<font class='verify'>Verify</font>

Independently verify `Animal_252450f2` and `Animal_2706cb1e` share the same USUBJID (and consequently the same label for the AnimalSubject and USUBJID). File: [/SPARQL/USUBJID-RC3-M2-Verify.rq](https://github.com/phuse-org/SENDConform/blob/master/USUBJID-RC3-M2-Verify.rq)
<pre class='sparql'>
  SELECT ?animalIRI ?usubjid
  WHERE{

    ?animalIRI  study:hasUniqueSubjectID ?usubjidIRI ;
                skos:prefLabel           ?usubjid .
    ?animalIRI2  study:hasUniqueSubjectID ?usubjidIRI .
    FILTER(?animalIRI != ?animalIRI2)
  }
</pre>

<pre class='queryResult'>
  <b>animalIRI                 usubjid</b>
  cj16050:Animal_2706cb1e   "Animal 99DUP1"
  cj16050:Animal_252450f2   "Animal 99DUP1"
</pre>


<br/>

---
<a name='ruleSD1001'></a>

###  SUBJID

<font class='rule'>FDA Rule SD1001</font>

The spreadsheet [FDA-Validator-Rules.xlsx](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx) defines the rule for SUBJID in the DM Domain as:

FDA Validator Rule ID | FDA Validator Message | Business or Conformance Rule Validated | FDA Validator Rule  
------|-------------------|--------------------------|-----------------------------
**SD1001** |Duplicate SUBJID |'Subject identifier, which must be unique within the study.| The value of Subject Identifier for the Study (SUBJID) variable must be unique for each subject **within the study**.

The Rule Components and corresponding SHACL shapes for SD1001 are similar to those defined for <a href='#ruleSD0083'>USUBJID/SD0083</a> with exception of the predicate changing to `study:hasSubjectID`and result messages specific to SUBJID instead of USUBJID. Details for SD1001 are therefore not provided here. The SHACL is available in the Shapes file [SHACL-AnimalSubject.TTL](../SHACL/CJ16050Constraints/SHACL-AnimalSubject.TTL)


## Reference Interval
<font class='FDARule'>FDA Rule SD1002</font>

***Figure 1*** shows the connection from the Animal Subject IRI to its Reference Interval and the associated  SHACL Shapes and SEND Rules.

<a name='figure1'/>
  <img src="images/IntervalStructure.PNG"/>

  ***Figure 1: Animal Subject Data Structure, SHACL Shapes, FDA Rules***

The spreadsheet [FDA-Validator-Rules.xlsx](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx) defines Rule SD10002 for Reference Start Date (RFSTDTC) and Reference End Date (RFENDTC) as:

FDA Validator Rule ID | FDA Validator Message | Business or Conformance Rule Validated | FDA Validator Rule  
------|-------------------|--------------------------|-----------------------------
**SD1002** |RFSTDTC is after RFENDTC |Study Start and End Dates must be submitted and complete. | **Subject Reference Start Date/Time (RFSTDTC) must be less than or equal to Subject Reference End Date/Time (RFENDTC)**

In the SENDConform Project, RFSTDTC and RFENDTC are modeled as part of a Reference Interval, leading to the deconstruction of the FDA rule into the following Rule Components:

**1. [Reference Start Date and End Date must be in xsd:date format.](#rc1)**

**2. [An Animal Subject has one Reference Interval.](#rc2)**

**3. [A Reference Interval has one Start Date and one End Date.](#rc3)**

**4. [Start Date must be on or before End Date.](#rc4)**

Translation of each Rule Component into SHACL and evaluation of test data is described below. Test cases in addition to those documented on these pages are available in the file [TestCases.xlsx](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints/TestCases.xlsx)


<font class='h3NoTOC'>Data Structure</font>

Familiarity with the data structure is necessary to explain the constraints and test cases. **Figure 1** illustrates a partial set of data for test subject 99T1 where the Reference Interval end date *precedes* the start date, thus violating Rule Component 4 of SD1002.

<a name='figure1'/>
  <img src="images/RefIntervalStructureDateFail.PNG"/>

  ***Figure 1: Reference Interval for Animal 99T1 (incomplete data)***

<font class='h3NoTOC'>Translation into SHACL</font>

<!--- RULE COMPONENT 1 ------------------------------------------------------->
<a name='rc1'></a>

<font class='ruleComponent'>Rule Component 1. Reference Start Date and End Date in xsd:date format</font>

<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  <code>rfstdtc</code> and <code>rfendtc</code> in <code>xsd:date</code> format.  
</div>


<div class='def'>
  <div class='def-header'>Description</div>
  Reference Start Date (RFSTDTC) and End Date (RFENDTC) must be in
  <font class='emph'>date format</font>. The study in this example requires
  <code>xsd:date</code>. Other studies may use <code>xsd:dateTime</code> or a combination of <code>xsd:date</code>
  and <code>xsd:dateTime</code>.
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

Additional dates can be assessed by adding additional predicates as `sh:targetObjectsOf` if the date follows through the path `time:inXSDDate`.

<pre class='shacl'>
study:hasTypeXsdDateShape-Date a sh:NodeShape ;
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
    sh:message     "Date not in xsd:date format. [SD1002]"
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
        sh:resultMessage "<font class='msg'>Date not in xsd:date format. [SD1002]</font>" ;
        sh:value "<font class='error'>7-DEC-16</font>" ;
        sh:sourceShape _:bnode_3c9cf811_13d4_43cb_b212_b7097d00b1ed_221 ;
        sh:sourceConstraintComponent sh:DatatypeConstraintComponent ;
        sh:focusNode <font class='nodeBold'>cj16050:Date_7-DEC-16 </font>;
    ]
</pre>
<br/>
The Report identifies the dates "7-DEC-16"  and "6-DEC-16" (not shown above). Execute the following SPARQL to find corresponding Animal SUBJECT IRIs and values (`Animal 99T4` for date "7-Dec-16" and `Animal 99T10` for date "6-Dec-16"). Source file: [/SPARQL/Animal-RefInterval.rq](https://github.com/phuse-org/SENDConform/blob/master/SPARQL/Animal-RefInterval.rq)

<pre class='sparql'>
  # RC1 : Find Subject with incorrect date format
  SELECT ?animalSubjectIRI ?animalLabel ?date
  WHERE{
    ?animalSubjectIRI a                          study:AnimalSubject ;
                      skos:prefLabel             ?animalLabel ;
                      study:hasReferenceInterval ?intervalIRI .

    ?intervalIRI ?beginOrEnd     ?dateIRI .
    ?dateIRI     time:inXSDDate  ?date .
    FILTER (?dateIRI IN (cj16050:Date_6-DEC-16, cj16050:Date_7-DEC-16))
  }
</pre>

<font class='verify'>Verify</font>

SPARQL independently verifies the test case by finding the two dates that are incorrectly typed as strings. Source file: [/SPARQL/Animal-RefInterval.rq](https://github.com/phuse-org/SENDConform/blob/master/SPARQL/Animal-RefInterval.rq)

<pre class='sparql'>
  # RC1 : Independently verify with SPARQL
  SELECT ?refIntervalIRI ?dateIRI ?date ?dateDType
  WHERE{
    ?refIntervalIRI a              study:ReferenceInterval ;
                    ?beginOrEnd    ?dateIRI .
    ?dateIRI        time:inXSDDate ?date .                
    FILTER (datatype(?date) <font class='nodeBold'> != xsd:date</font>)
}
</pre>
<br/><br/>

<!--- RULE COMPONENT 2 ------------------------------------------------------->
<a name='rc2'></a>

<font class='ruleComponent'>Rule Component 2: Subject has one Reference Interval</font>

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

<font class='omitted'>Not tested:</font> AnimalSubject with <i>more than one</i> Reference Interval.

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

The study ontology defines`study:AnimalSubject` as a sub class of both `study:Subject` and `study:Animal`.  Study subjects, be they animal or person, have a Reference Interval documenting their participation in a trial. Therefore, when the ontology is loaded into the database, the same constraint can be used for both pre-clinical (SEND) and clinical (SDTM) studies. This same ontological approach is taken for [USUBJID](SHACL-AnimalSubject-Details.md#rc12) and [SUBJID](SHACL-AnimalSubject-Details.md#ruleSD1001).

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

The SHACL shape evaluates the path `study:hasReferenceInterval` from the targetClass to determine if one and only one Reference Interval IRI is present. When the ontology is loaded, the more general `study:Subject` can be leveraged as the targetClass, assuming other `study:Subject`s like `study:HumanStudySubject` use the same predicate. The commented-out alternative is also provided for when the ontology is not loaded, or for cases where the constraint should only apply to `study:AnimalSubject` and not other classes like `study:HumanSubject`.

<pre class='shacl'>
study:hasMin1Max1Shape-Interval a sh:NodeShape ;
  <font class='nodeBold'>sh:targetClass study:Subject</font> ;  <font class='greyedOut'># Ontology</font>
  <font class='greyedOut'># sh:targetClass study:AnimalSubject ; # No Ontology </font>
  sh:path        study:hasReferenceInterval ;
  sh:name        "reference interval present";
  sh:description "Animal Subject must have one and only one reference interval IRI.";
  sh:message     "Animal Subject does not have one Reference Interval IRI. [SD1002]" ;
  sh:minCount    1 ;
  sh:maxCount    1 .
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
      sh:resultMessage "<font class='msg'>Animal Subject does not have one Reference Interval IRI. [SD1002]</font>" ;
      sh:sourceConstraintComponent sh:MinCountConstraintComponent                  
  ]                                                                                    
</pre>

SPARQL identifies the reported IRI as belonging to AnimalSubject 99T11, also confirming there is no `study:hasReferenceInterval` predicate.

<pre class='sparql'>
  # RC 2 : Information : predicates and objects for the IRI in the report
  SELECT ?s ?p ?o
  WHERE {
    cj16050:Animal_6204e90c ?p ?o ;
    BIND( IRI(cj16050:Animal_6204e90c) as ?s)  
  }  ORDER BY ?p
</pre>

<font class='verify'>Verify</font>

Verification identifies Animal Subject 99T11 with no Reference Interval.

<pre class='sparql'>
# RC 2 : Verify: Number of reference intervals per subject
SELECT ?animalSubjectIRI ?animalLabel (COUNT(?intervalIRI) AS ?numIntervals )
  WHERE{
    ?animalSubjectIRI a study:AnimalSubject ;
                      skos:prefLabel             ?animalLabel ;
    OPTIONAL{
        ?animalSubjectIRI study:hasReferenceInterval ?intervalIRI .
    }    
} # ORDER BY ?animalLabel
 GROUP BY ?animalSubjectIRI ?animalLabel
 HAVING (?numIntervals != 1 )
</pre>


<br/><br/>

<!--- RULE COMPONENT 3 ------------------------------------------------------->
<a name='rc3'></a>

<font class='ruleComponent'>Rule Component 3. Reference Interval has one Start Date and one End Date</font>

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

The study ontology defines`study:ReferenceInterval` as a sub class of `study:EntityInterval`.

<pre class='owl'>
<font class='nodeBold'>study:EntityInterval</font>
  rdf:type owl:Class ;
   rdfs:subClassOf time:Interval ;
  skos:prefLabel "Entity interval" ;
.
<font class='nodeBold'>study:ReferenceInterval</font>
  rdf:type owl:Class ;
  rdfs:subClassOf study:EntityInterval ;
  skos:prefLabel "Reference interval" ;
.
<font class='goodData'>study:Lifespan</font>
  rdf:type owl:Class ;
  rdfs:subClassOf study:EntityInterval ;
  skos:prefLabel "Lifespan" ;
.
<font class='goodData'>study:MedicalConditionInterval</font>
  rdf:type owl:Class ;
  rdfs:subClassOf study:EntityInterval ;
  skos:prefLabel "Medical event interval" ;
.
<font class='goodData'>study:StudyParticipationInterval</font>
  rdf:type owl:Class ;
  rdfs:subClassOf study:EntityInterval ;
  skos:prefLabel "Study participation interval" ;
.
</pre>
<br/>

All sub classes of `study:EntityInterval` must have a `time:hasBeginning` and `time:hasEnd`,  allowing the use of a single shape to evaluate following types of intervals when the ontology is loaded into the database:

* <font class='nodeBold'>study:ReferenceInterval</font>
* <font class='goodData'>study:LifeSpan</font>
* <font class='goodData'>study:MedicalConditionalInterval</font>
* <font class='goodData'>study:StudyParticipationInterval</font>

The ontology facilitates the use of the shape in both pre-clinical (SEND) and clinical (SDTM) studies.  

The shape tests the following conditions:

* Interval Start date for an Animal Subject has one and only one value.
* Interval End date for an Animal Subject has one and only one value.


<pre class='shacl'>
study:hasMin1Max1Shape-StartEndDates a sh:NodeShape ;
  <font class='nodeBold'>sh:targetClass study:EntityInterval</font> ; <font class='greyedOut'># Ontology</font>
  <font class='greyedOut'># sh:targetClass study:ReferenceInterval ; # No Ontology</font>
  sh:name        "intervalDateCount" ;
  sh:description "Interval has one and only one start and end date." ;
  sh:message     "Problem with Interval date. [SD1002]" ;
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
    sh:resultMessage "<font class='msg'>Problem with Interval date. [SD1002]</font>" ;
    sh:value cj16050:<font class='error'>Interval_db3c6403 </font> ;
    sh:sourceShape :RefIntervalDateShape ;
    sh:resultSeverity sh:Violation ;
</pre>


SPARQL can trace the  reference interval from the report back to AnimalSubject 99T5, showing this individual is missing `rfendtc`.
<pre class='sparql'>
SELECT ?animalLabel  ?beginDate ?endDate
WHERE{
  ?animalSubjectIRI study:hasReferenceInterval cj16050:Interval_db3c6403 ;
                    skos:prefLabel    ?animalLabel .

   OPTIONAL{
     cj16050:Interval_db3c6403 time:hasBeginning ?beginIRI .
     ?beginIRI time:inXSDDate  ?beginDate .
   }
   OPTIONAL{
     cj16050:Interval_db3c6403 time:hasEnd ?endIRI .
     ?beginIRI time:inXSDDate  ?beginDate .
  }
}
</pre>

<font class='verify'>Verify</font>
 The query below correctly lists the AnimalSubjects with start and end date data issues as 99T2, 99T5, 99T8, 99T9.


<pre class='sparql'>
#--- RC 3: Verify : Pull all subject IDs that do not have one start and one End date
SELECT ?animalLabel ?beginDate ?endDate (COUNT(?beginDate) AS ?numBeginDate)
       (COUNT(?endDate) AS ?numEndDate)
WHERE{
  ?animalSubjectIRI study:hasReferenceInterval ?intervalIRI ;
                    skos:prefLabel             ?animalLabel .
   OPTIONAL{
     ?intervalIRI time:hasBeginning ?beginIRI .
     ?beginIRI    time:inXSDDate    ?beginDate .
   }

   OPTIONAL{
     ?intervalIRI time:hasEnd     ?endIRI .
     ?beginIRI    time:inXSDDate  ?endDate .
  }
} GROUP BY ?animalSubjectIRI ?animalLabel ?beginDate ?endDate
  HAVING ((?numBeginDate != 1) || (?numEndDate != 1) )

</pre>


<!--- RULE COMPONENT 4 ------------------------------------------------------->
<a name='rc4'></a>

<font class='ruleComponent'>Rule Component 4. Start Date on or before End Date</font>
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

As described for [Rule Component 3](#rc3), this shape is applied at `sh:targetClass study:EntityInterval` for intervals that contain `time:hasBeginning` and `time:hasEnd` predicates. The alternative application to `study:ReferenceInterval` is shown for the alternative case when the ontology is not present.

<pre class='shacl'>
study:hasStartLEEndShape-Interval a sh:NodeShape ;
  <font class='nodeBold'>sh:targetClass study:EntityInterval</font> ; <font class='greyedOut'># Ontology</font>
  <font class='greyedOut'># sh:targetClass study:ReferenceInterval ; # No Ontology</font>
 sh:sparql [
  a              sh:SPARQLConstraint ;
  sh:name        "sd1002" ;
  sh:description "Interval start date on or before end date." ;
  sh:message     "Interval Start Date on or before End Date";
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
  sh:resultMessage "<font class='msg'>Interval Start Date on or before End Date. [SD1002]</font>" ;
  sh:value <font class='error'>cj16050:Interval_184f16eb</font>        ]
  sh:sourceConstraintComponent sh:SPARQLConstraintComponent ;
  sh:resultSeverity sh:Violation ;
  sh:focusNode cj16050:Interval_184f16eb
</pre>

SPARQL traces the interval back to the AnimalSubject and date values.

<pre class='sparql'>
SELECT ?animalLabel (?beginDate AS ?intervalStart) (?endDate AS ?intervalEnd)
WHERE {
  ?animalSubjectIRI study:hasReferenceInterval ?intervalIRI ;
                    skos:prefLabel             ?animalLabel .

  ?intervalIRI time:hasBeginning  ?beginIRI .
  ?beginIRI    time:inXSDDate     ?beginDate .

  ?intervalIRI time:hasEnd        ?endIRI .
  ?endIRI    time:inXSDDate       ?endDate .
  FILTER  (! (?endDate >= ?beginDate ))
}
</pre>


<font class='verify'>Verify</font>

Verification confirms Animal Subject 99T1 and 99T2 with End Data preceding Start Date. Note how when the start date is a string it also flags AnimalSubject 99T10 as a violator. The SPARQL statement is very similar to the query used in the SHACL-SPARQL constraint.

<pre class='sparql'>
  # RC4 : Verify :
  SELECT ?animalLabel (?beginDate AS ?intervalStart) (?endDate AS ?intervalEnd)
  WHERE {
    ?animalSubjectIRI study:hasReferenceInterval ?intervalIRI ;
                      skos:prefLabel             ?animalLabel .

    ?intervalIRI time:hasBeginning  ?beginIRI .
    ?beginIRI    time:inXSDDate     ?beginDate .

    ?intervalIRI time:hasEnd        ?endIRI .
    ?endIRI    time:inXSDDate       ?endDate .
    FILTER  (! (?endDate >= ?beginDate ))
  }
</pre>


<pre class='queryResult'>
  <b>animalLabel    intervaIRI                  intervalStart   intervalEnd</b>
  "Animal 99T1"  cj16050:Interval_184f16eb   2016-12-07      2016-12-06
  "Animal 99T10" cj16050:Interval_56cbc8c2   "6-DEC-16"      2016-12-07
  "Animal 99T2"  cj16050:Interval_21316392   2016-12-08      2016-12-07
</pre>


Animal Subject Shape - Demographics Domain
==================================

## Age

***Figure 1*** shows the connection from the Animal Subject IRI to its Age value.

<a name='figure1'/>
  <img src="images/AgeStructure.PNG"/>

  ***Figure 1: Animal Subject Data Structure for Age***

The spreadsheet [FDA-Validator-Rules.xlsx](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx) defines numerous rules associated with Age in the DM domain. This project defines only a subset of these rules as SHACL Shapes. For example, the rule SD2019 "Invalid value for AGETXT" is not applicable because the example study collects AGE (numeric) and not AGETXT (age range as a string).

The following rules are defined on this page:

* [SD0084 - Age >=0](#sd0084)  
* ...more rules coming!

<a name='sd0084'></a>
<font class='FDARule'>Age >= 0: FDA Rule SD0084</font>

FDA Validator Rule ID | FDA Validator Message | Business or Conformance Rule Validated | FDA Validator Rule  
------|-------------------|--------------------------|-----------------------------
**SD0084** |Negative value for age | Values for age variables cannot be negative, | **The value of Age (AGE) cannot be less than 0.**


<font class='ruleComponent'>Rule Component</font>

**1. [AGE must be greater than or equal to 0. ](#rc1)**

<font class='h3NoTOC'>Data Structure</font>

Refer back to **Figure 1** to see how age is indirectly associated with an AnimalSubject via a study:participatesIn predicate that leads to an outcome IRI that in turn contains the age value and units. Most subjects in the study are the same age (8 Weeks), resulting in a small number of tests in outcome IRIs instead of traditional tests on each age value associated with an Animal Subject.


<font class='h3NoTOC'>Translation into SHACL</font>

<!--- RULE COMPONENT 1 ------------------------------------------------------->
<a name='rc1'></a>

<font class='ruleComponent'>Rule Component 1. AGE must be greater than or equal to 0.</font>

<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  <code>age</code> <code>sh:minInclusive</code> 0.  
</div>

<div class='def'>
  <div class='def-header'>Description</div>
  The Age value must be greater than or equal to 0. While this study has not age=0, the check is constructed to satisfy the FDA rule.
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
<br/>
The report lists the Age value and Age outcome IRI, but not the AnimalSubject associated with the offending value. SPARQL can be used to identify the Animal Subject using the Age Outcome IRI identified in the report.  Source file: [/SPARQL/Animal-Age-LT0.rq](https://github.com/phuse-org/SENDConform/blob/master/SPARQL/Animal-Age-LT0.rq)
<pre class='sparql'>
  SELECT ?animalLabel
  WHERE{
    ?ageDataCollIRI   code:outcome cj16050:<font class='nodeBold'>Age_-10_WEEKS </font>.

    ?AnimalSubjectIRI study:participatesIn ?ageDataCollIRI ;
                      skos:prefLabel       ?animalLabel .
  }
</pre>

SPARQL independently verifies the Animal Subject with  `age < 0`.  Source file: [/SPARQL/Animal-Age-LT0.rq](https://github.com/phuse-org/SENDConform/blob/master/SPARQL/Animal-Age-LT0.rq)

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

<font class='FDARule'>Age XXX: FDA Rule SDxxxx</font>

<font class='toBeAdded'>The next AGE rule will be defined here.</font>

FDA Validator Rule ID | FDA Validator Message | Business or Conformance Rule Validated | FDA Validator Rule  
------|-------------------|--------------------------|-----------------------------
**SDxxxx** | |  | **xxxxxx**

<br><br><br>
<font class='toBeAdded'>Add: Additional DM Rules...</font>

{% include links.html %}
