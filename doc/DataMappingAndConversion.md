# Data Mapping and Conversion
*** TO BE UPDATED ***

## Introduction


## Process Overview


### R Programs
| Order  | File                 | Description                                  |
| ------ | -------------------- | ---------------------------------------------|
| 1.     | XPTtoCSV.R           | Main driver program for data conversion. Metadata import and time stamp. |
| 2.     | DM_imputeCSV.R       | DM imputation, encoding. 
| 3.     | DM_TTLCreate.R       | Create TTL based on .CSV  |
| 4.     | TS_imputeCSV.R       | TS imputation. |
| 5.     | TS_TTLCreate.R       | Create TTL based on .CSV  |


### Stardog .BAT files
| Order  | File                 | Description                                  |
| ------ | -------------------- | ---------------------------------------------|
| NA     | StarDogUpload.BAT    | Calls the individual mapping files to upload domains to the triplestore. |

## General Rules

### Data Creation

| File                   | Description                       |
| ---------------------- | ----------------------------------|
| x                      | y                                 |
| x                      |y                                  |


### Data Creation: Adding Rules



### Encoding


#### Hashing


### Links to Codelists


### Miscellaneous RDF Guidance
#### Labels

* `skos:prefLabel` is the primary label used in the graph. It may be supplemented later with `rdfs:label` and language tags. 
* Labels specific to a person, including intervals specific to that person, include the value of usubjid in that label.
* Labels for *intervals* use the imputed (_im) values as the `skos:prefLabel` instead of the more readable individual dates. The reason is that if one date is missing, as is common for LifeSpan and InformedConsent intervals, the label is not created. 


# Data Files and Mapping Detail

## Graph Metadata 
Graph metadata including data conversion date and graph version is stored in the file **ctdasrdf_graphmeta.CSV**. When the data conversion scripts are executed in R, **XPTtoCSV.R** reads in the CSV file, updates the time stamp value, then overwrites the file with the new information. The CSV file is mapped to the graph using the SMS process.

| File      | Role                     | Description                                  |
| --------- | ------------------------ | ---------------------------------------------|
|Graphmeta.csv | Basic graph metadata | Description of graph content, status, version, and time stamp information.
|Graphmeta_map.TTL|SMS Map | Map to graph. |



[Back to TOC](TableOfContents.md)
