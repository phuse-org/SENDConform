<link href="styles.css" rel="stylesheet"/>


# Data Conversion

## Introduction
Only the DM and TS domains are modeled for this proof of concept. Data was obtained from Phuse Scripts repository, [SEND subfolder](https://github.com/phuse-org/phuse-scripts/tree/master/data/send) and copied over to this repository for ease of access.


## Source Data

SAS transport XPT data files for conversion and testing are located in the folder:
<pre>
  SENDConform\data\source\<font class="extraInfo">Study Name</font> 
</pre>

These files are read in by the conversion scripts with data exported to the ttl folder:
<pre>
    SENDConform\data\source\<font class="extraInfo">Study Name</font>\ttl
</pre>

Another folder contains DM and TS data in CSV form for ease of loading into Excel to view the data:

<pre>
    SENDConform\data\source\<font class="extraInfo">Study Name</font>\csv
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

* `skos:prefLabel` is the primary label used in the graph. It may be supplemented later with `rdfs:label` and language tags. 
* Labels specific to a person, including intervals specific to that person, include the value of usubjid in that label.
* Labels for *intervals* use the imputed (_im) values as the `skos:prefLabel` instead of the more readable individual dates. The reason is that if one date is missing, as is common for LifeSpan and InformedConsent intervals, the label is not created. 


# Data Files and Mapping Detail

## Graph Metadata 
Graph metadata, including data conversion date and graph version, is created within the driver.R script and exported to a TTL file for upload into the triplestore.

| File      | Role                     | Description                                  |
| --------- | ------------------------ | ---------------------------------------------|
|Graphmeta.csv | Basic graph metadata | Description of graph content, status, version, and time stamp information.
|Graphmeta_map.TTL|SMS Map | Map to graph. |



[Back to TOC](TableOfContents.md)
