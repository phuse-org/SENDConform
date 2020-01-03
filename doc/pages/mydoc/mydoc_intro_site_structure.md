---
title: Project Repository Structure
last_updated: 2019-12-24
sidebar: mydoc_sidebar
permalink: mydoc_intro_site_structure.html
folder: mydoc
---

## Folder Structure

This pages describes the repository structure and folders with respect to the type of files contained within. Information on specific files is found within the project documentation where use of those files is described. For example, the R Scripts for data conversion located in /r are described on the [SEND Data Conversion and Mapping](DataConversion.md) page.

### Styles for GitHub Pages
-   **/assets/css**
    - css file for GitHub pages theme. CSS for Markdown pages is under /doc .

### Data

-   **/data**
    - data files, both inputs and outputs.
    
-   **/data/CDISCRDF**
    - CDISC SEND Files copied from the PHUSE CDISC repository, originally from rdf.cdisc.org

-   **/data/SAS**
    -   Data files for use in future SAS conversion process as an alternative to the R process. Empty as of 2019-08-08
    
-   **/data/<font class="parameter">Study Name</font>**
    -   Source XPT files from multiple studies used in project. Data was obtained from PHUSE Scripts repository [SEND subfolder](https://github.com/phuse-org/phuse-scripts/tree/master/data/send) and copied over to this project .
    
-   **/data/studies/<font class="parameter">Study Name</font>/csv**
    -   Original source data converted directly from XPT to CSV to allow viewing in Excel. Is NOT used to map to the database. 

-   **/data/studies/<font class="parameter">Study Name</font>/ttl**
    - TTL files for upload into a triple store.
    - CSV files for mapping to the Stardog triplestore using SMS.
    - Stardog SMS Map files 
    - Graph Metadata files as TTL, CSV, and SMS maps
    - ontology files and instance data from TopBraid parallel development (will move at a later date)

-   **/data/test**
    - data for SHACL development and testing. Sourced from various online examples. Will be deleted at later date.

### Documentation

-   **/doc**
    - Project documentation in Markdown. Includes CSS style sheet for formatting.

-   **/doc/FDA**    
    - FDA Conformance Guidelines and related publications. Validator Rules spreadsheet.     
-   **/doc/images**
    -   Images to be included in the project documentation, including the Github Markdown files.

-   **/doc/pubs**
    -   Project Publications, with sub folders for various conferences

### R

-   **/r**
    - Data conversion scripts, drivers, functions.

-   **/r/doc**
    -   R documentation. PDFs for packages. 
-   **/r/query**
    -   R scripts that query the triplestore. Not used as of 2019-08-08.
-   **/r/validation**
    -   Data validation R scripts including subfolders for RShiny validation apps.

-   **/r/vis**
    -   Visualization scripts and RShiny apps.
    -   RShiny apps in subfolders named with "-app"

### SAS

-   **/sas**
    -   SAS scripts with function corresponding to those in /r. Empty as of 2019-08-08.

### SHACL

-   **/SHACL**
    -   SHACL development occurs in this structure.  

-   **/SHACL/<font class='parameter'>StudyName</font>Constraints/**
    - SHACL development for a specific study and files that support that development.
    - Includes SPARQL test scripts for SHACL-SPARQL as .rq files 
    - Includes test case documentation in .XLSX workbook.

-   **/SHACL/Examples**
    - Examples not based on the data schema used in this project.    

### SPARQL

-   **/SPARQL**
    -   SPARQL scripts for working with the data in the triplestore. All scripts must contain a comment header describing their function and should indicate vendor-specific SPARQL extensions whenever used. 


{% include links.html %}
