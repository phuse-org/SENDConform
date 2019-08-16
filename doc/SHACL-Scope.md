<link href="styles.css?v=1" rel="stylesheet"/>
<a name='top'></a>

Project Scope, Conventions
==================================

# Project Scope

## Data
This example uses data from the study "RE Function in Rats", located in the repository 
at [/data/studies/RE Function in Rats](https://github.com/phuse-org/SENDConform/tree/master/data/studies/RE%20Function%20in%20Rats).
Original source data is converted to .TTL using the script [r/driver.R](https://github.com/phuse-org/SENDConform/blob/master/r/driver.R) 
that in turn calls scripts to covert the data domain files used in the prototype. Initial work is based on the DM domain. The TS Domain will be added in the future. 

The data conversion process aligns the data with the graph schema (*link to ontology to be added*) used in this 
project. It also adds observations to test the various SHACL shapes that represent the rule components. Test observations are identified by `subjid` and `usubjid`
values containing the pattern 99T<font class='parameter'>n</font>, in contrast to the original study data values of 00M0<font class='parameter'>n</font>. The [Data Conversion](DataConversion.md) page provides additional details.  

The data file used for developing SHACL is available here: [SHACL/CJ16050Constraints/DM-CJ16050-R.TTL](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints/DM-CJ16050-R.TTL) 

Instructions on how to create validation reports in Stardog is available on the [Running Validation Reports](SHACL-RunValReport.md) page.

# SHACL Constraints

A detailed description of SHACL syntax is beyond the scope of this document. Please refer to the [SHACL Introduction](SHACL-Intro.md) page for a list of resources. 

The SHACL shapes described on this page are available in the file  [SHACL/CJ16050Constraints/SHACL-SD1002.TTL](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints/SHACL-SD1002.TTL). 


## SHACL for SEND Rules 
The project team considered two alternative approaches to modeling the SEND Rules:

1. Create SHACL shapes based on the [FDA Validator Rules Workbook](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx) and then apply those shapes to the data.  The advantage of this approach is that shapes can be constructed to provide error messages that match the rule's  Validator message. However, this approach results in the creation of many overlapping and redundant SHACL shapes and does not leverage the full power of SHACL validation.
   

2. Create *modular* SHACL shapes based on the data schema that satisify the [FDA Validator Rules Workbook](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx) and provide additional, comprehsensive checks as re-usable modules. The disadvantage of this approach is the loss of the original Validator Messages.  However, checks can be tied back to the original rule identifiers, allowing some backward compatibility. 


The second approach was chosen for the project.

Because the prototype is limited to the TS and DM domains to RDF, only a subset of the rules for each domain will be developed. Rules that cross multiple studies (example: identifiers that must be unique across multiple trials) are only evaluated within the context of the single-study in the prototype. To obtain the list of rules, the [FDA Validator Rules Workbook](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx)
was filtered to include exclusively the DM domain for SEND 3.0. This resulted in a list of 19 rules that are specific to that DM domain. Of these, only 14 are independed of other domains. Rule SD1020 is dependent on the SEND ontology and may be added at a later time.

**Table 1. Rules Exclusive to DM Domain**

Domain |Rule   |Category | Status| Reason for Exclusion
---|-------|-------  | ------ | -------------------
DM | SD1001 | id      | <font class='development'>development</font> |
DM | SD0083 | id      | <font class='development'>development</font> |
DM | SD0088 | date    | <font class='development'>development</font> |
DM | SD0087 | date    | <font class='development'>development</font> |
DM | SD1002 | interval| <font class='development'>development </font>|
DM | SD0084 | age     | planned |
DM | SD1129 | age     | planned |
DM | SD1121 | age     | planned |
DM | SD2019 | age     | planned |
DM | SD2023 | age     | planned |
DM | SD2020 | age     | planned |
DM | SD2021 | age     | planned |
DM | SD2022 | age     | planned |
DM | SD1259 | Set code    | planned |
DM | SD1020 | dataset     | ?      | Requires link to SEND Ontology. May be added.
DM | SD0069 | disposition | <font class='error'>excluded</font> | requires DS dataset
DM | SE2311 | Set code    | <font class='error'>excluded</font> | Requires TX dataset
DM | SD0071 | screen fail | <font class='error'>excluded</font> | requires TA dataset
DM | SD0066 | arm         | <font class='error'>excluded</font> | requires TA dataset


## Resuable Shapes

The project defines a number of basic shapes that re-use core components for data validation. Follow the links below for details. The list will continue to grow as more data and shapes are added.

* [AnimalShape](SHACL-AnimalSubject-Details.md)


# Content Conventions

 Color coding is used as a content guide. 


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
   Omitted data is shown as <font class='infoOmitted'>...</font>
</pre>

<pre class="shacl">
  This box contains a representation of the shapes graph (in full or in part). 
</pre> 

<pre class="report">
  Excerpts from the SHACL Validation Report (the output results graph.)
</pre>



[Back to top of page](#top) 
<br/>
[Back to TOC](TableOfContents.md)

