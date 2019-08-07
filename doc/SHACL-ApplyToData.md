<link href="styles.css?v=1" rel="stylesheet"/>

# Applying SHACL Constraints to Data

## Stardog

### Stardog Studio Without Adding Constraints to the Database

1. Create a test database named SENDConform in Stardog.
1. Load the data file **DM-CJ16050-R.TTL** .
1. Open the SHACL constraint file **SHACL-SD1002.TTL** into Stardog Studio.
1. Select the file type as SHACL (lower right corner of Studio)
1. From the ADD CONSTRAINT drop down (upper left), select the drop down button and choose **Get Validation Report**. This executes the report *without adding the constraint to the database*. Too add the constraint to the database so it is available for command line execution (next section), select "Add Constraint." **NOTE:** *There are problems removing constraints from the database that may require dropping the data base and recreating it to avoid duplicate messages in the validation report from sucesssive add/remove steps. Observed and reported to Stardog for version 6.1.  2019-07-18.*

1. Scroll through the report and find the resultMessages for the data errors. The report is easier to view from the command line execution. 

### Stardog via command line

1. Assuming Stardog is available on the command line and the data and constraints are added into the *SENDConform* database, execute this command:

<pre style="background-color:#F6F6F6;">
  stardog icv report SENDConform
</pre>

You may redirect the report to a text file on your local machine: 

<pre style="background-color:#F6F6F6;">
  stardog icv report SENDConform > "C:\temp\Report.txt"
</pre>

## TopBraid

***INSTRUCTIONS TO BE ADDED***
