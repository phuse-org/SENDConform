<link href="styles.css?v=2" rel="stylesheet"/>


# SEND Data Conversion and Mapping

## Introduction
The proof of concept is limited to the <b>DM</b> and <b>TS</b> domains. Data was obtained from PHUSE Scripts repository [SEND subfolder](https://github.com/phuse-org/phuse-scripts/tree/master/data/send) and copied over to this project under folders for each example study: /SENDConform/data/studies/<font class="parameter">Study Name</font>  .

The easiest data conversion method would be to read in the row-by-column source data and convert it to RDF, using column names to represent the types of entities represented by the values in each cell, and the rows as individuals. This is not the approach taken in this project. Data is re-formed to match an ontology that represents the types of entities and their relationships in the trial based on knowledge of the data and clinical trial process.


Two alternate methods are provided for the data conversion process. In method one, R scripts read the source SAS XPT file and convert it to TTL for import into a triplestore. The same data conversion R scripts simultaneously create .CSV files to support a second method of importing data into a Stardog triplestore [using Stardog Mapping Syntax (SMS)](DataMapping-StardogSMS.md). ***The .CSV files do not contain the full set of data for evaluating the test cases.***

Additional data conversion methods using SAS or Python may be developed, time and expertise permitting. 

## Source Data

SAS transport XPT data files for conversion and testing are located in the folder:
<pre>
  SENDConform/data/studies/<font class="parameter">Study Name</font> 
</pre>

These files are read in by the conversion scripts with data exported to the /ttl folder:
<pre>
    SENDConform/data/studies/<font class="parameter">Study Name</font>/ttl
</pre>

The /csv folder contains data in comma-delimited format for ease of viewing the data in  Excel. These files are raw, source data and are not used for mapping into the triplestore.

<pre>
    SENDConform/data/studies/<font class="parameter">Study Name</font>/csv
</pre>

## Test Case Data

The data conversion process adds observations to test the various SHACL shapes that represent the rule components. Test observations are identified by `subjid` and `usubjid` values containing the pattern 99T<font class='parameter'>n</font>, in contrast to the original study data values of 00M0<font class='parameter'>n</font>. The [Data Conversion](DataConversion.md) page provides additional details. Test cases are documented in the file [TestCases.xlsx](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints/TestCases.xlsx)



## General Guidance

### Generating Unique Identifiers for Animal Subjects
It may seem reasonable to use SUBJID or USUBJID when forming IRIs for Animal Subjects. IRI creation is simple and the human-readable value facilitates traceability back to the original source. For example, the IRI for Subject 00M01 would be:
`cj16050:Animal_00M01`

However, the use of SUBJID is fraught with problems. Consider cases where:

* A SUBJID is accidentally re-used and assigned to more than one animal. Two unique individuals would have the same ID number and the resulting RDF would have all observations assigned to a single IRI. It would be difficult to detect this duplication after data is converted to the graph. 

* The same animal is accidentally assigned two different SUBJID values. Values are incorrectly assigned to two separate individuals. 

* A row of data is accidentally duplicated, a condition that could go undetected when converting the data to RDF.

A solution is to create IRIs for critical components like **Animal Subject** and **Reference Interval** that are independent from values in the source data. For the purpose of this prototype, a truncated SHA-1 hash of a randomly generated value (with a known seed value) is used to create select IRIs where missing, duplicate, or partial data would be problematic.

Following this method:

* IRIs remain constant during multiple runs during project development. 
* IRIs for subjects, intervals, and other critical components become independent of the source data.
* Testing for duplicate, missing, and incorrect instance data becomes possible thanks to IRIs that are independent from instance data.

Example Animal Subject IRI: `cj16050:Animal_a6d09184`

Methods to generate UIDs for subjects in real-world settings is beyond the mandate of this project.See the [Technical Details page](https://github.com/phuse-org/UIDPharma/blob/master/UUIDTechDetails.md)) of the project [Unique Identifiers for the Pharmaceutical Industry](https://github.com/phuse-org/UIDPharma) for more information on generating unique identifiers. 


### Reference Interval IRIs

Date values for reference start date (rfstdtc) and reference end date (rfendtc) are not directly attached to the Animal Subject IRI. Rather, the <code>cj16050:Animal_<font class="parameter">hashvalue</font></code> has a Reference Interval IRI <code>cj16050:Interval_<font class="parameter">hashvalue</font></code> which in turn has two date IRIs attached via the `time:hasBeginning` and `time:hasEnd` predicates (**Figure 1**).  

<img src="images/RefIntervalStructureDateFail.PNG"/>

**Figure 1: Animal_99T1 (incomplete data)**

Reference Interval IRIs are still created when either start or end date is missing (**Figure 2**), because the data for the non-missing date  must be captured in the graph. A Reference Interval may also be created when ***both*** start and end dates are missing. 

<img src="images/RefIntervalStructureMissEndDate.PNG"/>

**Figure 2: Animal_99T5 Missing rfendtc**

See the [Animal Subject Reference Interval](SHACL-AnimalSubject-ReferenceInterval-Details.md) page for how SHACL shapes are constructed based on this model.


### RDF Project Conventions
#### Labels

* `skos:prefLabel` is the primary label used in the graph. For controlled terms, `skos:prefLabel` contains the industry standard (CDISC) label, which is often in plural form (DAYS, WEEKS, etc.) while `rdfs:label` contains the W3C standard in singular form (DAY, WEEK, etc.). `rdfs:label` is optional for all other triples.

# Conversion Details 

## R Programs

| Order  | File                 | Description                                  |
| ------ | -------------------- | ---------------------------------------------|
| 1.     | driver.R             | Main driver program for data conversion. Graph metadata creation.|
| 2.     | DM_convert.R         | DM instance data conversion to TTL, addition of observations to test constraints. (Under construction)|
| 3.     | TS_convert.R         | TS instance data conversion to TTL, addition of observations to test constraints. (Not yet written)|


## Graph Metadata 
Graph metadata, including data conversion date and graph version, is created within the **driver.R** script and exported to a TTL file for upload into the triplestore and a corresponding .csv file for SMS mapping purposes.

| File      | Role                     | Description                                  |
| --------- | ------------------------ | ---------------------------------------------|
|Graphmeta-<font class='parameter'>StudyName</font>.csv | Basic graph metadata | Description of graph content, status, version, and time stamp information. |
|Graphmeta-<font class='parameter'>StudyName</font>-map.TTL|SMS Map | Map CSV to Stardog graph. |
|Graphmeta-<font class='parameter'>StudyName</font>.TTL| RDF Triples | TTL file for loading directly into triplestore. |


## DM 

| File      | Role                     | Description                                  |
| --------- | ------------------------ | ---------------------------------------------|
| DM-CJ16050.CSV | Demographics        | May be a subset during development. 
| DM-CJ16050-R-map.TTL | SMS Map       | Map CSV to Stardog graph. 
| DM-CJ16050-R.TTL | RDF Triples       | TTL file for loading directly into triplestore. 

### CJ16050
#### Data Imputation

Creation of values not in the original study data, or located in domains that are not part of the pilot.

| Variable     | Value(s)            | Description                                  |
| ------------ | ------------------- | ---------------------------------------------|
| SPECIESCD_IM |  "Rat"              | Species Code not specified in DM data file.
| AGEUNIT_IM   |  "Week"             | A representation of the age unit that is used to link to time namespace. 
| DURATION_IM  | "P56D"              | Duration code, derived from 8 weeks x 7 days/wk. 


#### Data
-   **/data/studies/RE Function in Rats/ttl**

File  | Description    | Contact
---------|----------------------------------|-----------------------------------
cj16050.ttl | Instance data file. Outdated as of 2019-08-02 | 
cjprot.ttl | Nonclinical study protocol file for study CJ16050 | AO
cj160500send.shapes.ttl | Combines the instance file with the SEND ontology to support automated SEND dataset creation. It currently recreates the first record of the pilot DM domain. TS not yet included.  | AO 
DM-CJ16050-R.csv | Data file created by R for mapping DM domain data to triplestore using SMS | TW
DM-CJ16050-R.TTL | Data file created by R for direct load into triplestore | TW
DM-CJ16050-R-map.TTL | SMS map for DM-CJ16050-R.csv  to Stardog
Graphmeta-CJ16050.csv | Graph metadata file for mapping to triplestore using SMS | TW
GraphMeta-CJ16050.TTL | Graph metadata file for direct load into triplestore  | TW
Graphmeta-CJ16050-map.TTL | SMS map for Graphmeta-CJ16050.csv to Stardog | TW
SENDConform-CJ106050LoadDriver.bat | Driver .BAT file that calls SENDConform-CJ106050LoadSequence.bat. Needed for Windows. | TW
SENDConform-CJ106050LoadSequence.bat | Loads data into Stardog using a series of SMS calls.
study.ttl | Ontology file from the CTDasRDF project, updated to support nonclinical data | AO
send.ttl |  "bare bones" SEND ontology to allow exporting protocol and instance data into SEND format. | AO


### TS

*Future development*



[Back to TOC](TableOfContents.md)
