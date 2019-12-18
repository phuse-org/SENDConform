
Project Documentation
=====================

# Table of Contents

# A. Submissions

# A.1  Technical Rejection Criteria

* [Introduction to Technical Rejection Criteria](SUBMIT-Intro.md)

# A.2 Data Conversion, Modeling, Mapping

* [Preparing the data](SUBMIT-DataConvert.md)

# A.3 SHACL Shapes

* [sHACL Shapes details](SUBMIT-SHACLDetail.md) including how the shapes are constructed, evaluated on test data, and validated.

# A.4 Running Validation Reports

* [How to run the reports](SUBMIT-RunVal.md) on the example data. 

# B. SEND Data

## B.1 Data Conversion, Modeling, Mapping

SEND data is converted to Linked Data as Resource Description Format (RDF) using an ontology-based schema.

* [B.1.1 SEND Data Conversion and Mapping](DataConversion.md)  
    * SAS XPT to RDF for import into a triplestore.
* [B.1.2 Data Mapping with Stardog SMS](DataMapping-StardogSMS.md)  
    * Optionally map .CSV files to the database.

## B.2. SHACL for Project Data

FDA Validation Rules are translated to SHACL to create validation reports. 

### [B.2.1 Project scope, conventions](SHACL-Scope.md)

Start here for an introduction, then progress through the descriptions of rules and shapes in section 2.2.  This page also contains a list of the FDA rules within links to the pages that describe their representation in SHACL.

### B.2.2 Shapes

<a name='animalSubjectShapes'>
   
* [Animal Subject Shape](SHACL-AnimalSubject-Details.md)- Demographics Domain
    * [Identifiers USUBJID,SUBJID](SHACL-AnimalSubject-ID-Details.md)
    * [Reference Interval](SHACL-AnimalSubject-ReferenceInterval-Details.md) (start, end dates) 
    * [Age](SHACL-AnimalSubject-Age-Details.md)

### [B.2.3 Running Validation Reports](SHACL-RunValReport.md)


# C. References and Resources

* Project structure and methods including project data files, scripts, coding conventions, and data modeling decisions.

### [C.1 Project Repository Structure](Repository-Ref.md)

* Details of the GitHub repository structure and content.

### [C.2 Regulatory](Regulatory-Ref.md)

* Regulatory Reference Documentation (Conformance rules, documentation).

### [C.3 SHACL Introduction and Resources](SHACL-Intro.md)

* Resources for learning SHACL and other references.

### [C.4 Ontology Development and Documentation](Ontology-Ref.md)

* Ontology details.  *To be added*

