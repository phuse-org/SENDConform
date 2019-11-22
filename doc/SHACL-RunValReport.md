<link href="styles.css?v=1" rel="stylesheet"/>

# Running Validation Reports

These instructions document how to apply a SHACL constraint file to data using either the Stardog triplestore or TopBraid.

## Stardog

### Stardog Studio Without Adding Constraints to the Database

1. Create a test database named **SENDConform** .
1. Load the **data** file SHACL/CJ16050Constraints/**DM-CJ16050-R.TTL** .
1. Load the ontlogy file SHACL/CJ16050Constraints/**OWL-study.TTL** .
1. Open the **SHACL constraint** file SHACL/CJ16050Constraints/**SHACL-AnimalSubject.TTL** into Stardog Studio.
1. Select the file type as SHACL (lower right corner of Studio)
1. Ensure Reasoning is On.
1. From the ADD CONSTRAINT drop down (upper left), select **Get Validation Report** to execute the report *without adding the constraint to the database*. 
1. Scroll through the report and find the resultMessages indicating data errors. 

Too add the constraint to the database so it is available for command line execution (next section), select "Add Constraint" from the drop down.  

**NOTE:** *There are problems removing constraints from the database that may require dropping the data base and recreating it to avoid duplicate messages in the validation report from sucesssive add/remove steps. Observed and reported to Stardog for version 6.1.  2019-07-18.*


### Command Line

These steps assume Stardog is available from the command line. 
1. Add the data, ontology, and SHACL file to the database as described in the previous section. 

1. Execute this command:

<pre style="background-color:#F6F6F6;">
  stardog icv report SENDConform
</pre>

You may redirect the report to a text file on your local machine: 

<pre style="background-color:#F6F6F6;">
  stardog icv report SENDConform > C:\temp\Report.txt
</pre>

### PHUSE Endpoint

*To be added: Instructions for running the report on the public PHUSE Endpoint*

<br/><br/>

## TopBraid

***Instructions to be added.***
<br/>
Back to [Table of Contents](TableOfContents.md)