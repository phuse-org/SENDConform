Folder Structure
----------------

**TO BE UPDATED **

Project folder structure and content. Documentation is currently incomplete and focuses on the current work that uses data from the study CJ16050


### Data for Project CJ16050

-   **/data/studies/RE Function in Rats/ttl**
    -   TTL files created by the conversion process
    -   Project ontology TTL files
    -   External ontology files 

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
 

**Additional Details**  

The protocol file imports the study ontology. The instance file imports the protocol file. When ready to "publish" in SEND it also imports the SEND ontology into a new file called:  cj160500send.shapes.ttl

 cj160500send.shapes.ttl has everything integrated and linked into one mega-graph, so that SHACL rules pertaining to data quality have a home by linking to resources under the study: namespace and SHACL rules pertaining to SEND conformance issues can be linked to resources under the send: namespace.  For example, time interval is a universal concept with start date must be before end date is a universal, "data quality" type of issue, and sure enough the rules can be linked to the time:Interval class. On the other hand, the fact that a SEND domain like DM or TS must be present, this is a SEND specific conformance rule that can be linked to the send:SENDDomain_DM  or send:SENDDomain_TS class.  - AO
 
send.ttl file is a bare bones ontology written by AO from scratch to support the pilot. It in essence documents the requirements for what a robust SEND ontology should be able to support at a minimum to allow round-tripping and now, SHACL rules validation.  It would be useful if other team members could look at this work and try replacing this rudimentary ontology with something more robust, capable of supporting all the domains not just DM/TS.  - AO
    
    
    
# UPDATES NEEDED BELOW HERE:  2019-08-02    
    
-   **/data/SAS**
    -   SAS data files (can also be .csv) files as an alternative to the R process.
-   **/data/studies**
    -   Source XPT files from the various available studies under each study sub folder.
-   **/data/studies/<study>/csv**
    -   CSV files created by R from source XPT files. Also contains graph metadata CSV file created by R.
    -   Stardog SMS Map files that map their corresponding CSV files to the triplestore.
    -   .BAT files that drive the SMS to triplestore process

### Documentation

-   **/doc**
    -   Project documentation. Primarily Github markdown pages.
-   **/doc/images**
    -   Images to be included in the project documentation, including the Github Markdown files.
-   **/doc/FDA**
    -   Documentation from the FDA. Conformance Guidelines, Rules, and support documentation.

-   **/doc/Pubs**
    -   Project Publications, with sub folders for various conferences

### R

-   **/r/doc**
    -   R documentation. PDFs for packages. 
-   **/r/query**
    -   R scripts that query the triplestore.
-   **/r/util**
    -   Utility/Example scripts. E.g.: Read XPT from R.
-   **/r/validation**
    -   Data validation R scripts. 

-   **/r/vis**
    -   Visualization scripts and RShiny apps.
    -   RShiny apps in subfolders named with "-app"

### SAS

-   **/sas**
    -   SAS scripts with function corresponding to those in /r

### SPARQL

-   **/SPARQL**
    -   SPARQL scripts for working with the data in the triplestore. All scripts must contain a comment header describing their function and should indicate vendor-specific SPARQL extensions whenever used. 



[Back to TOC](TableOfContents.md)
