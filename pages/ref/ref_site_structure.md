---
title: Project Repository Structure
last_updated: 2020-02-28
sidebar: home_sidebar
permalink: ref_site_structure.html
folder: ref
---

## Overview

The GitHub repository is structured based on content and function, with some unavoidable overlap. This page documents the content broadly by function. Information on specific files is found elsewhere within the project documentation. For example, the R Scripts for data conversion located in /r are described on the [SEND Data Conversion and Mapping](DataConversion.md) page.


### Documentation

#### GitHub Pages (content for github.io publication)
Content published to github.io, including this page  your are reading now, is published using the Jekyll Theme as described on [About This Site](ref_about_this_site.md). The files for the theme and documentation are located in multiple folders.

-   **/**
    - landing page index.md/html
    - miscellaneous files required for publication. Some not in use.

-   **/pages**
    - The main documentation pages published to github.io. Content is broken out by major category (as displayed on the homepage sidebar), including /devteam, /intro, /ref, /send, and /submit.

-   **/_data, /_data/sidebars**
    - yml files for tags and navigation, including sidebar definition.

-   **/_includes, /_layouts, /_tooltips**
    - many files not used or can be deleted..

-   **/css**
    - themes and styles. **customstyles.css** contains customizations specific to the project. E.g.: formatting for SPARQL, Data, Definitions boxes.

-   **/fonts**
    - reference also: /css/fonts

-   **/images**
    - static images for inclusion on the web pages. Schema diagrams, etc.

-   **/js, /licenses**
    - JavaScript used by the theme, licenses.

-   **/pdfconfig**
    - configuration files for creating PDF rendition of the project pages. Not currently in use.

-   **/var**
    - build script for the documentation pages. Not     currently ni use.*

##### Visualization
-   **/visualization**
    - data and scripts for visualization

#### Documents
-   **/doc**
    - supporting Documents

-   **/doc/devTest**
    - TO BE DELETED

-   **/doc/FDA**
    - Documents from or related to FDA. Conformance Guidelines and related publications. Submission worksheet, Validator Rules spreadsheet and more.

-   **/doc/Meetings**
    - Team Meeting slide decks and related content.

-   **/doc/pubs**
    -   Project Publications, with sub folders for various conferences.

-   **/doc/Misc**
    - Miscellaneous documentation.

-   **/doc/pubs**
        - Publications resulting from the project. Currently empty.

### Data

-   **/data**
    - data files, both inputs and outputs.

-   **/data/CDISCRDF**
    - CDISC SEND Files copied from the PHUSE CDISC repository, originally from rdf.cdisc.org

-   **/data/config**
    - Files used to drive the conversion process or other configuration. E.g. **prefixes.csv** contains the list of prefixes used by the R conversion scripts.

-   **/data/sas**
    -   Data files for use in future SAS conversion process as an alternative to the R process. Empty as of 2020-02-28

-   **/data/studies/<font class="parameter">Study Name</font>**
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
