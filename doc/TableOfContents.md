
Project Documentation
=====================

# Table of Contents

## 1. Data Conversion, Modeling, Mapping

SEND data is converted to Linked Data as Resource Description Format (RDF) using an ontology-based schema.

* [1.1 SEND Data Conversion and Mapping](DataConversion.md)  
    * SAS XPT to RDF for import into a triplestore.
* [1.2 Data Mapping with Stardog SMS](DataMapping-StardogSMS.md)  
    * Optionally map .CSV files to the database.

## 2. SHACL for Project Data

FDA Validation Rules are translated to SHACL to create validation reports. 

### [2.1 Project scope, conventions](SHACL-Scope.md)

Start here for an introduction, then progress through the descriptions of rules and shapes in section 2.2.  This page also contains a list of the FDA rules within links to the pages that describe their representation in SHACL.

### 2.2 Shapes

<a name='animalSubjectShapes'>
   
* [Animal Subject Shape](SHACL-AnimalSubject-Details.md)- Demographics Domain
    * [Identifiers USUBJID,SUBJID](SHACL-AnimalSubject-ID-Details.md)
    * [Reference Interval](SHACL-AnimalSubject-ReferenceInterval-Details.md) (start, end dates) 
    * [Age](SHACL-AnimalSubject-Age-Details.md)

### [2.3 Running Validation Reports](SHACL-RunValReport.md)


## 3. References and Resources

* Project structure and methods including project data files, scripts, coding conventions, and data modeling decisions.

### [3.1 Project Repository Structure](Repository-Ref.md)

* Details of the GitHub repository structure and content.

### [3.2 Regulatory](Regulatory-Ref.md)

* Regulatory Reference Documentation (Conformance rules, documentation).

### [3.3 SHACL Introduction and Resources](SHACL-Intro.md)

* Resources for learning SHACL and other references.

### [3.5 Ontology Development and Documentation](Ontology-Ref.md)

* Ontology details.  *To be added*

