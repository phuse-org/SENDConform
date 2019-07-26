<link href="styles.css" rel="stylesheet"/>


# Data Conversion

## Introduction
Only the DM and TS domains are modeled for this proof of concept. Data was obtained from Phuse Scripts repository, [SEND subfolder](https://github.com/phuse-org/phuse-scripts/tree/master/data/send) and copied over to this repository for ease of access.

The conversion process will provide a minimum of two alternatives. A third alternative using SAS may be provided, time permitting.
1. R to TTL
   R scripts read in the source SAS XPT file and output TTL files for import into a triplestore.
1. R to CSV, CSV to Stardog triplestore using SMS
   The same scripts used to create TTL files also output a CSV file that can be mapped to the Stardog triplestore using Stardog Mapping Syntax (SMS) or other triplestore using R2RML. A benefit of this approach is that the team already has an RShiny app for visualizing SMS files, which is very helpful for validating the schema and later as an aid for constructing queries.

## Source Data

SAS transport XPT data files for conversion and testing are located in the folder:
<pre>
  SENDConform\data\studies\<font class="extraInfo">Study Name</font> 
</pre>

These files are read in by the conversion scripts with data exported to the ttl folder:
<pre>
    SENDConform\data\studies\<font class="extraInfo">Study Name</font>\ttl
</pre>

Another folder contains DM and TS data in CSV form for ease of loading into Excel to view the data:

<pre>
    SENDConform\data\studies\<font class="extraInfo">Study Name</font>\csv
</pre>



## Conversion Scripts


### R Programs
| Order  | File                 | Description                                  |
| ------ | -------------------- | ---------------------------------------------|
| 1.     | driver.R             | Main driver program for data conversion. Graph metadata creation. |
| 2.     | DM_convert.R         | DM conversion to TTL file. (under development) |
| 3.     | TS_convert.R         | TM conversion to TTL (not yet written)   |



## General Rules
TBD


### Data Creation: Adding Rules
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
|Graphmeta-*StudyName*.csv | Basic graph metadata | Description of graph content, status, version, and time stamp information.
|Graphmeta-*StudyName*-map.TTL|SMS Map | Map CSV to Stardog graph. |
|Graphmeta-*StudyName*.TTL| RDF Triples | TTL file for loading directly into triplestore. |


## Trial Data
 
 Imputed variables are named in UPPERCASE and include the suffix `_IM` .

| File      | Role                     | Description                                  |
| --------- | ------------------------ | ---------------------------------------------|
| driver.R  | driver program           | Calls data conversion programs in sequence. Creates graph metadata files.

 
### DM 
| File      | Role                     | Description                                  |
| --------- | ------------------------ | ---------------------------------------------|
| DM-Convert.R| Data conversion        | XPT to CVS and TTL. Data imputation.
| DM-CJ16050.CSV | Demographics        |  May be a subset during development. |
| DM-CJ16050-R-map.TTL | SMS Map       | Map CSV to Stardog graph. |
| DM-CJ16050-R.TTL | RDF Triples       | TTL file for loading directly into triplestore. |

#### CJ16050
##### Data Imputation
| Variable     | Value(s)            | Description                                  |
| ------------ | ------------------- | ---------------------------------------------|
| SPECIESCD_IM |  "Rat"              | Species Code not specified in DM data file.
| AGEUNIT_IM   |  "Week"             | A representation of the age unit that is used to link to time namespace. |
| DURATION_IM  | "P56D"              | Duraction code, derived from 8 weeks x 7 days/wk. |

### TS

*Future development*



[Back to TOC](TableOfContents.md)
