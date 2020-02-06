---
title: SEND Data Validation
last_updated: 2020-02-05
sidebar: home_sidebar
permalink: send_validation.html
folder: send
---

## Introduction

These instructions document how to apply [SHACL constraints developed for the CJ16050 study](send_shacl_shapes.html) the to data using the Stardog triplestore.

## Stardog

### Stardog Studio Without Adding Constraints to the Database

1. Create a test database named **SENDConform** .
1. Load the **data** file SHACL/CJ16050Constraints/**DM-CJ16050-R.TTL** .
1. Load the ontology file SHACL/CJ16050Constraints/**OWL-study.TTL** .
1. Open the **SHACL constraint** file SHACL/CJ16050Constraints/**SHACL-AnimalSubject.TTL** into Stardog Studio.
1. Select the file type as SHACL (lower right corner of Studio).
1. In the Activate/Deactivate section of the file, ensure the shape you wish to test is not deactivated:   `sh:deactivated false`
1. Select the database SENDConform.
1. Ensure Reasoning is On.
1. Click the checkmarkd icon at the top of the Workspace (to the left of the selected database. Mouseover of the button shows "Get Validation Report") to execute the report *without adding the constraint to the database*.
1. Scroll through the report and find the resultMessages indicating data errors.


### Alternative: Add Constraints to the Database

**CAUTION:*** There are problems removing constraints from the Stardog 6.x database that may require dropping the data base and recreating it to avoid duplicate messages in the validation report from successive add/remove steps. Observed and reported to Stardog for version 6.1.  2019-07-18.*

1. Follow the same steps as above but instead of clicking the Check Mark, click the plus symbol to add the constraint to the database.

### Command Line Report Generation

As of 2020-02-06, command line execution of the report provides a much cleaner report than Stardog Studio v. 1.15.0.  

These steps assume Stardog is available from the command line.
1. Load the data, ontology, and SHACL file to the database as described in the previous section.

1. Execute this command:

<pre style="background-color:#F6F6F6;">
  stardog icv report SENDConform
</pre>

You may redirect the report to a text file on your local machine:

<pre style="background-color:#F6F6F6;">
  stardog icv report SENDConform > C:\temp\Report.txt
</pre>

### PHUSE Endpoint

<font class='toBeAdded'>Add: Instructions for running the report on the public PHUSE Endpoint</font>

## TopBraid
<font class='toBeAdded'>Add: Instructions for TopBraid.</font>

{% include links.html %}
