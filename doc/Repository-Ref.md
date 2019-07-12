Folder Structure
----------------

**TO BE UPDATED **

Project folder structure and content.


### Data

-   **/data/rdf**
    -   TTL files created by the conversion process
    -   Project ontology TTL files
    -   External ontology files 
-   **/data/SAS**
    -   SAS data files (can also be .csv) files as an alternative to the R process.
-   **/data/source**
    -   Source XPT files from the various available studies under each study subfolder.
-   **/data/source/<study>/csv**
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
    -   Project Publications, with subfolders for various conferences

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
    -   SPARQL scripts for working with the data in the triplestore. All scripts must contain a comment header describing their function and should indicate vendor-specfic SPARQL extensions whenever used. 



[Back to TOC](TableOfContents.md)
