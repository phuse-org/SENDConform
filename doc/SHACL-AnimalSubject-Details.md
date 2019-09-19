<link href="styles.css?v=1" rel="stylesheet"/>
<a name='top'></a>

Animal Subject Shape - Demographics Domain
==================================

The Animal Subject IRI `:Animal_xxx` is a natural starting point for developing rules based on the Demographics domain because each row in the source DM data contains values for an individual Animal Subject. SHACL shapes are created with reuse in mind, as reflected in both the structure and naming conventions. Where practical, shapes are named using a description of their function, a dash, and then an abbreviated name of the class or entity they act upon. Examples:

* `hasMin1Max1Shape-USubjID` - validates that each Animal Subject has a minimum of one and maximum of one USUBJID assigned.  
* `isUniqueShape-USubjID`    - validates the *uniqueness* of USUBJID values. A SUBJID cannot be assigned to more than one Animal Subject.

Shapes may include additional constraints such as data type, length, and other restrictions not explicitly stated in the original FDA rules.

Shapes must include the `sh:message` property to provide meaningful messages about the violation. Where applicable, a reference to the related FDA Rule ID number must be provided in square brackets at the end of the message text. In cases where a shape may be applied to more than one Rule, all rules covered by that shape are listed.

Example:  <code>sh:message "Subject --> USUBJID violation. <b>[SD0083]</b>" ;</code>


# Animal Subject Shape

<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
   One <code>sh:property</code> for each type of <code>predicate</code>---> <code>object</code> relation attached directly to the AnimalSubject IRI.
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

The Node Shape `study:AnimalSubjectShape` describes nodes of the class `study:AnimalSubject` . 

<pre class='shacl'>
# Animal Subject Shape
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

  
  <font class='infoOmitted'>... more property shapes will be added as they are developed</font>
</pre>

If an ontology defines `study:AnimalSubject` as a subclass of `study:Subject`, then shapes could use the `sh:targetClass` `study:Subject` (assuming common constraints for both classes.) This will work will use the target class `study:AnimalSubject` for simplicity and not leverage the ontology.

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

<b>Next: </b>[Identifiers USUBJID, SUBJID](SHACL-AnimalSubject-ID-Details.md)
<br/>
<br/>
Back to [Top of page](#top) <br/>
Back to [Table of Contents](TableOfContents.md)

