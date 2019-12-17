<link href="styles.css?v=1" rel="stylesheet"/>
<a name='top'></a>

Project Scope, Conventions
==================================

# Data
The prototype uses data from the study "RE Function in Rats", located in the repository 
at [/data/studies/RE Function in Rats](https://github.com/phuse-org/SENDConform/tree/master/data/studies/RE%20Function%20in%20Rats) and is limited to the Demographics (DM) and Trial Summary (TS) domains. Original source data is converted to .TTL using the driver script [r/driver.R](https://github.com/phuse-org/SENDConform/blob/master/r/driver.R) as described on the [Data Conversion](DataConversion.md) page. 

The converted RDF data used for developing SHACL is available here: [SHACL/CJ16050Constraints/DM-CJ16050-R.TTL](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints/DM-CJ16050-R.TTL) 

Instructions on how to create validation reports in Stardog is available on the [Running Validation Reports](SHACL-RunValReport.md) page.

# SHACL Constraints

A detailed description of SHACL syntax is beyond the scope of this document. Please refer to the [SHACL Introduction](SHACL-Intro.md) page for a list of resources. 

The SHACL shapes used in this project are available here:
* AnimalSubjectShape  [SHACL/CJ16050Constraints/SHACL-AnimalSubject.TTL](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints/SHACL-AnimalSubject.TTL). 


## SHACL for SEND Rules 
The project team considered two alternative approaches to modeling the SEND Rules:

1. Create SHACL shapes based on the [FDA Validator Rules Workbook](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx) and then apply those shapes to the data.  The advantage of this approach is that shapes can be constructed to provide error messages that match the result message in the FDA documentation. However, this approach results in the creation of many overlapping and redundant SHACL shapes and does not leverage the full power of SHACL validation.
   

2. Create *modular* SHACL shapes based on the data schema that satisfy the [FDA Validator Rules Workbook](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx) and provide additional, comprehensive checks as re-usable modules. The disadvantage of this approach is the loss of the original Validator Messages. Checks can be tied back to the original rule identifiers by including references in the result messages. In the future, the validation report could be parsed and linked back to the original data to provide more user-friendly reporting.


The second approach was chosen for the project.

Not all the rules for the selected DM and TS domains are modeled. Some rules cross multiple studies (example: identifiers that must be unique across multiple trials) and can only be evaluated within the context of the single-study in the prototype. Other rules cross mutliple domains that are not included in initial development and may be reconsidered as project scope expands to include additional domains.

DM was chosen for initial development and the list of relevant rules was seledcted from the [FDA Validator Rules Workbook](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx)
by filtering exclusively on the <font class="emph">DM domain for SEND 3.0</font>. This resulted in a list of *19 rules* specific to the DM domain. Of these, only 14 are independent of other domains. Additionnally, Rule SD1020 is dependent on the SEND ontology and may be added at a later time.

**Table 1. Rules Exclusive to DM Domain**

Domain |Rule   |Category | SHACL Dev Status| Reason for Exclusion
---|-------|-------  | ------ | -------------------
DM | SD0083 | usubjid | [available](SHACL-AnimalSubject-Details.md) |
DM | SD1001 | subjid  | [available](SHACL-AnimalSubject-Details.md) |
DM | SD1002 | interval| [available](SHACL-AnimalSubject-ReferenceInterval-Details.md) |
DM | SD0088 | date    | <font class='development'>development</font> |
DM | SD0087 | date    | <font class='development'>development</font> |
DM | SD0084 | age     | [available](SHACL-AnimalSubject-Age-Details.md) |
DM | SD1121 | age     | planned |
DM | SD1129 | age     | planned |
DM | SD2019 | age     | <font class='restrict'>excluded</font> | AGETXT (age range) not in source data
DM | SD2020 | age     | <font class='restrict'>excluded</font> |
DM | SD2021 | age     | planned |
DM | SD2022 | age     | planned |
DM | SD2023 | age     | <font class='restrict'>excluded</font> | Birthdate (BRTHTDTC) not present in source data
DM | SD1259 | Set code    | planned |
DM | SD1020 | dataset     | ?      | Requires link to SEND Ontology. May be added.
DM | SD0069 | disposition | <font class='restrict'>excluded</font> | requires DS dataset
DM | SE2311 | Set code    | <font class='restrict'>excluded</font> | Requires TX dataset
DM | SD0071 | screen fail | <font class='restrict'>excluded</font> | requires TA dataset
DM | SD0066 | arm         | <font class='restrict'>excluded</font> | requires TA dataset


## Resuable Shapes

The project defines a number of basic shapes that re-use core components for data validation. Follow the links below for details. The list will continue to grow as more data and shapes are added.

* [AnimalSubjectShape](SHACL-AnimalSubject-Details.md)


# Content Conventions

 Color coding provides a guide to the content describing the shapes.

<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  Grey boxes contain brief syntax / pseudo code for the rule.
</div>

<div class='def'>
  <div class='def-header'>Description</div>
  Blue boxes contain a textual description of the rule.
</div>
 
<pre class="data">
   This box contains a subset of data that serves as input to test the shapes graph. 
   Intentional error values are <font class='error'>highlighted in red.</font>
   Data not relevant to the discussion is and omitted is shown as <font class='infoOmitted'>...</font>
</pre>

<pre class="sms">
   Stardog Mapping Syntax, used to import CSV files to the database. 
</pre>


<pre class="owl">
   Contains an excerpt from an ontology that applies to the rule being described.
   Optional. Not all rules rely on the project ontologies. 
</pre>


<pre class="shacl">
  Contains a representation of the shapes graph (in full or in part). 
</pre> 

<pre class="report">
  Excerpts from the SHACL Validation Report (the output results graph.)
</pre>

<pre class="sparql">
  SPARQL commands to retrieve additional information based on values identified in the report or to validate the validation report.
</pre>

<pre class="queryResult">
  Results of a SPARQL query for tracing information from the Report back to additional information or to verify 
  the SHACL constraint is catching all test cases. 
</pre>




<b>Next: </b>[Animal Subject Shape](SHACL-AnimalSubject-Details.md)
<br/>
<br/>
Back to [Top of page](#top) <br/>
Back to [Table of Contents](TableOfContents.md)
