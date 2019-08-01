<link href="styles.css?v=2" rel="stylesheet"/>


# Data Conversion

## Introduction
The proof of concept is limited to the <b>DM</b> and <b>TS</b> domains. Data was obtained from Phuse Scripts repository, [SEND subfolder](https://github.com/phuse-org/phuse-scripts/tree/master/data/send) and copied over to this repository under /SENDConform/data/studies/<font class="parameter">Study Name</font>  .

A minimum of two alternatives are provided for the data conversion process:
1. R to TTL

   R scripts read in the source SAS XPT file and output TTL files for import into a triplestore.

1. R to CSV, CSV to Stardog triplestore using SMS

   The same scripts used to create TTL files also output a CSV file that can be mapped to the Stardog triplestore using Stardog Mapping Syntax (SMS) or other triplestore using R2RML. A benefit of this approach is that the team already has an RShiny app for visualizing SMS files, which is very helpful for validating the schema and later as an aid for constructing queries.

A third alternative using SAS may be provided, time permitting.

## Source Data

SAS transport XPT data files for conversion and testing are located in the folder:
<pre>
  SENDConform\data\studies\<font class="parameter">Study Name</font> 
</pre>

These files are read in by the conversion scripts with data exported to the ttl folder:
<pre>
    SENDConform\data\studies\<font class="parameter">Study Name</font>\ttl
</pre>

Another folder contains DM and TS data in CSV form for ease of loading into Excel to view the data:

<pre>
    SENDConform\data\studies\<font class="parameter">Study Name</font>\csv
</pre>

## Conversion Scripts


### R Programs

| Order  | File                 | Description                                  |
| ------ | -------------------- | ---------------------------------------------|
| 1.     | driver.R             | Main driver program for data conversion. Graph metadata creation. Creation of observations to test constraints|
| 2.     | DM_convert.R         | DM conversion to TTL file. (under development) |
| 3.     | TS_convert.R         | TM conversion to TTL (not yet written)   |


## General Guidance

#### Generating Unique Identifiers for Animal Subjects
It may seem reasonable to use SUBJID and USUBJID when forming IRIs. The approach simplifies IRI creation and is very human readable, allowing the person to trace data back to a specific subject. In this example, Subject 00M01:
`cj16050:Animal_00M01`

However, the use of SUBJID is fraught with problems. Consider cases where:

* A SUBJID is accidentally re-used and assigned to more than one animal, so two distinct animals have the same ID number. The  resulting RDF would have all observations assigned to a single IRI and it would be difficult to identify the duplication. 

* The same animal is accidentally assigned two different SUBJID values. Results are now seen as belonging to two separate individuals, which is also incorrect. 

* A row of data is accidentally duplicated, a condition that could go undetected when converting the data to RDF.

A solution is to create IRIs for critical components like Animal Subject and Intervals using IRIs that are independed of the data. For the purpose of this prototype, a truncated SHA-1 hash of a randomly generated value (with a known seed value) is used to create the required IRIs, including IRIs for data collection events, intervals, and other components in the data model.

Following this method:

* IRI's remain constant during mutliple runs of the development code. 
* IRIS for subject identifiers, intervals, data collection events and other components in the data model are not dependent on instance data, which could be incorrect. 
* Testing for duplicate, missing, and incorrect instance data becomes possible thanks to data-independent of IRIs. 

Example Animal Subject IRI: `cj16050:Animal_a6d09184`

See the [Technical Details page](https://github.com/phuse-org/UIDPharma/blob/master/UUIDTechDetails.md)) of the project [Unique Identifiers for the Pharmaceutical Industry]https://github.com/phuse-org/UIDPharma) for more information on generating unique identifiers. Methods to generate UIDs for subjects in real-world settings is beyond the mandate of this project.


#### Reference Interval IRIs

Date values for reference start date (rfstdtc) and reference end date (rfendtc) are not direclty attached to the Animal subject IRI. Rather, the `cj16050:Animal_<hashvalue>` has a reference interval IRI `cj16050:Interval_<hashvalue>` which in turn has two date IRIs attached via the `time:hasBeginning` and `time:hasEnd` predicates (See Figure 1).  



### Data Creation: More details.
TBD



### Links to Codelists
TBD

### Miscellaneous RDF Guidance
#### Labels

* `skos:prefLabel` is the primary label used in the graph. `rdfs:label` contains supplemental labels. For controlled terms, `skos:prefLabel` contains the industry standard (CDISC) label, which is often in plural form (DAYS, WEEKS, etc.) while `rdfs:label` contains the W3C standard in singular form (DAY, WEEK, etc.)

# Data Files and Mapping Detail

## Graph Metadata 
Graph metadata, including data conversion date and graph version, is created within the driver.R script and exported to a TTL file for upload into the triplestore.

| File      | Role                     | Description                                  |
| --------- | ------------------------ | ---------------------------------------------|
|Graphmeta-*StudyName*.csv | Basic graph metadata | Description of graph content, status, version, and time stamp information. |
|Graphmeta-*StudyName*-map.TTL|SMS Map | Map CSV to Stardog graph. |
|Graphmeta-*StudyName*.TTL| RDF Triples | TTL file for loading directly into triplestore. |


## Trial Data
 
 Imputed variables are named in UPPERCASE and include the suffix `_IM` .

| File      | Role                     | Description                  |
| --------- | ------------------------ |------------------------------|
| driver.R  | driver program           | Calls data conversion programs in sequence. Creates graph metadata files.

 
### DM 

| File      | Role                     | Description                                  |
| --------- | ------------------------ | ---------------------------------------------|
| DM-Convert.R| Data conversion        | XPT to CVS and TTL. Data imputation.
| DM-CJ16050.CSV | Demographics        |  May be a subset during development. 
| DM-CJ16050-R-map.TTL | SMS Map       | Map CSV to Stardog graph. 
| DM-CJ16050-R.TTL | RDF Triples       | TTL file for loading directly into triplestore. 

#### CJ16050
##### Data Imputation

| Variable     | Value(s)            | Description                                  |
| ------------ | ------------------- | ---------------------------------------------|
| SPECIESCD_IM |  "Rat"              | Species Code not specified in DM data file.
| AGEUNIT_IM   |  "Week"             | A representation of the age unit that is used to link to time namespace. 
| DURATION_IM  | "P56D"              | Duraction code, derived from 8 weeks x 7 days/wk. 

### TS

*Future development*



[Back to TOC](TableOfContents.md)
