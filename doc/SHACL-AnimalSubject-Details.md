<link href="styles.css?v=1" rel="stylesheet"/>
<a name='top'></a>

Animal Subject Shape
==================================

The Animal Subject IRI `:Animal_xxx` is a natural starting point for developing rules based on the DM domain, since each row in DM consists of data for each Animal Subject. A Parent Shape named `study:AnimalSubjectShape` is created with a property for each type of relation (predicate) attached to the Animal Subject IRI. Shapes like those that describe the identifiers USUBJID and SUBJID could have easily been combined into a single shape. They are kept separate to provide more specific reporting aligned with the FDA rules and the approach provides a standardized pattern for shape creation.  This pattern will be revisited as the project progresses.


***Figure 1*** provides an overview of how the Animal Subject data values translate into shapes that in turn statisfy SEND Rules for the DM domain. The shapes go well becyond the standard requirements, as described on this page and the [TestCases](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints/TestCases.xlsx) 


<a name='figure1'/>
  <img src="images/AnimalTriples.PNG"/>
  
  ***Figure 1: Animal Triples and Related Rules***

## Naming Conventions

*section will be moved to another page in the future*

Parent shapes are named using their target class. Example:  The **AnimalSubject**Shape contains contstraints for the class `study:AnimalSubject` .

Child shapes under the Parent Shape are named using a decription of their function, a dash, and then an abbreviation of the class/entity they act upon. Exmaples:

* `hasMin1Max1Shape-USubjID`  = shape validates uniqueness of USUBJID : minimum of one SUBJID and maximum of one SUBJID per Animal Subject. 

Child shapes include additional constraints such as data type, lenght, and other restrictions not explictly stated in the original FDA rules.



# Parent Shape

<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
   One <code>sh:property</code> for each <code>predicate</code> <code>object</code> relation.
</div>


<div class='def'>
  <div class='def-header'>Description</div>
  Each type of <code>predicate ----> object </code> relation in the parent class, with the exception of predicates like `a/rdf:type`, `skos:prefLablel`, etc.,  has a `sh:property` definition to a shape for validation of that object.
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
    study:participatesIn       cj16050:AgeDataCollection_037c2fdc, 
                               cj16050:SexDataCollection_037c2fdc .
    
    <font class='infoOmitted'>... more triples to be added here</font>
</pre>
<br/>

The SHACL shape AnimalSubjectShape references numerious child shapes. Click on the shape names to link to their details.

* [asMin1Max1Shape-USubjID](#usubjid)
* [asMin1Max1Shape-SubjID](#subjid)
* 

<pre class='shacl'>
# Animal Subject Shape
study:AnimalSubjectShape
  a              sh:NodeShape ;
  sh:targetclass study:AnimalSubject ;
  sh:property    study:<a href='#usubjid'>hasMin1Max1Shape-USubjID </a>;
  sh:property    study:hasMin1Max1Shape-SubjID .
  
  <font class='infoOmitted'>... more to be added as shapeas are developed</font>
</pre>
<br/>

The report correctly identifies xxxx, violating the XXXX requirement. 
<pre class='report'>
   # Report
</pre>
<br/><br/>


##  HERE be things
<a name='usubjid'></a>




