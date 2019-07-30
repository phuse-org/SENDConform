<link href="styles.css?v=1" rel="stylesheet"/>

# Modeling SEND Rule SD1002 in SHACL

### 1. FDA Rule

This example models the SEND-IG 3.0 rule **SD1020** for the DM domain as defined in the file [FDA-Validator-Rules.xlsx](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx)

FDA Validator Rule ID | FDA Validator Message | Publisher|  Publisher ID | Business or Conformance Rule Validated | FDA Validator Rule  
------|-------------------|-----|-------|--------------------------|-----------------------------
**SD1002** |RFSTDTC is after RFENDTC | FDA| FDAB034    |Study Start and End Dates must be submitted and complete. | Subject Reference Start Date/Time (RFSTDTC) must be less than or equal to Subject Reference End Date/Time (RFENDTC)

Examine the *FDA Validator Rule* and state the complete rule in natural language.

The rule: 

"***Subject Reference Start Date/Time (RFSTDTC) must be less than or equal to Subject Reference End Date/Time (RFENDTC).***"

Contains the following explicit and implicit components:

#### Rule Components

<div style='background-color:#F6F6F6;'>
1.1 Reference Start Date (RFSTDTC) and End Date (RFENDTC) must be in <font class="emph">date format</font>. The study in this example uses xsd:date while other datasets could also use xsd:dateTime. 
</div>
<br/>

<div style='background-color:#F6F6F6;'>
1.2 Animal Subject must have <font class='emph'>one and only one value</font> for each of RFSTDTC and RFENDTC. (Not explicitly stated   in the FDA text.)
</div>
<br/>

<div style='background-color:#F6F6F6;'>
1.3 The <b>SD1002 rule</b>: Start Date must be less than or equal to End Date (<font class='emph'>RFSTDTC</font> less than or equal to RFENDTC</font>). When this rule is violated, the system should supply the standard FDA message <font class='error msg'>"RFSTDTC is after RFENDTC"</font>. 
</div>
<br/>

### 2. Data 

This example uses the DM domain data from the study "RE Function in Rats", located in the repository at [/data/studies/RE Function in Rats](https://github.com/phuse-org/SENDConform/tree/master/data/studies/RE%20Function%20in%20Rats) and converted to .TTL using the script [r\\DM-convert.R](https://github.com/phuse-org/SENDConform/blob/master/r/DM-convert.R). 

#### 2.1 Data preparation

The R script DM-convert.R adds observations to test the rule components using SHACL constraints. Test observations are identified by  `subjid` and `usubjid` values containing the pattern 99T<n> in contrast with the original study data values of 00M0<n>. 

An additional TTL file for development and testing purposes is created in the location /SHACL/CJ16050Constraints. 


#### 2.2 Rules violated by test data include: 


**Rule Component 1** Start Date and End Date in date (xsd:date) format 

<pre style="background-color:#EEEEBB;">
    cj16050:Interval_XXXXXXX
      a study:ReferenceInterval ;
      time:hasBeginning cj16050:Date_2016-12-08 ;
      time:hasEnd cj16050:Date_7-DEC-16 .
       
    cj16050:Date_7-DEC-16
      a study:ReferenceEnd ;
      time:inXSDDate <font class='error'>"7-DEC-16"^^xsd:string</font> .
</pre>    


**Rule Component 2** One RFSTDTC/RFENDTC per AnimalSubject 
<font class='error'>This section subject to change based on ReferenceInterval IRI creation method</font>

As a result of how the reference intervals are constructed in RDF, duplicate `rfstdtc` and `rfendtc` values will result in additional <font class='emph'>cj16050:Interval_</font>  values, violating the condition of one interval per AnimalSubject.


*a) More than one interval*

<pre style="background-color:#EEEEBB;">
  cj16050:Animal_99T2
    a study:AnimalSubject ;
    study:hasReferenceInterval <font class='error'>cj16050:Interval_2016-12-07_2016-12-07, 
                               cj16050:Interval_2016-12-08_2016-12-08 </font> .
</pre>

*b) No interval*
<pre style="background-color:#EEEEBB;">
   *Example Data coming soon*
</pre>



**Rule Component 3** : Reference Interval End Date is on or after Start Date 

<pre style="background-color:#EEEEBB;">
  cj16050:<font class='emph'>Animal_99T1</font>
    a                          study:AnimalSubject ;
    study:hasReferenceInterval cj16050:Interval_2016-12-07_2016-12-06 .
    
  cj16050:Interval_2016-12-07_2016-12-06
    a                 study:ReferenceInterval ;
    time:<font class='emph'>hasBeginning</font> cj16050:<font class='error'>Date_2016-12-07</font> ;
    time:<font class='emph'>hasEnd</font>       cj16050:<font class='error'>Date_2016-12-06</font> .
    
  cj16050:Date_2016-12-07
    a              study:ReferenceBegin ;
    time:inXSDDate "2016-12-07"^^xsd:date .
    
  cj16050:Date_2016-12-06
    a              study:ReferenceEnd ;
    time:inXSDDate "2016-12-06"^^xsd:date .
</pre>


#### 2.3 Data Structure
Familiarity with the data structure in TTL is necessary to explain the constraints. Here is a partial set of data for subjid 99T1 that violates rule SD1002 because end date preceeds start date.

A graphical representation of the data is shown in Figure 1. 

<img src="images/RefIntervalDataFail.PNG">
*Figure 1: Animal_99T1 (incomplete data)*

The full data file used in developing this page is available here: [SHACL\CJ16050Constraints\DM-CJ16050-R.TTL](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints/DM-CJ16050-R.TT)

### 3. SHACL Constraints

**3.1 Constraint File**

The SHACL file [SHACL\CJ16050Constraints\SHACL-SD1002.TTL](https://github.com/phuse-org/SENDConform/blob/master/SHACL/CJ16050Constraints\SHACL-SD1002.TTL) begins with the prefixes used in the shapes. 

Shapes defined below the prefixes include: 

Shape        | Rule Component | Check 
-------------|------------|-------------------
<span style="background-color:#DDEEBB;">:DateShape</span>        |1 | rfstdtc/rfendtc as xsd:date format 
<span style="background-color:#DDEEBB;">:RefIntervalShape</span> |2 |  One and only one rfstdtc, rfendtc per AnimalSubject
<span style="background-color:#DDEEBB;">:SD1002RuleShape</span>  |3 |  SD1002 Rule: rfstdtc less than or equal to rfendtc

**3.1.1 :DateShape** (Rule Component 1)
`:DateShape` uses `sh:targetObjectsOf` to select the interval IRI as the (Subject) focus node. The two `sh:targetObjectsOf` follow these paths through the data to obtain the date values: 
<pre>
 <font class='objectIRI'>Interval IRI</font> - - - <font c lass='predicate'>time:hasBeginning</font>  - - > <font class='objectIRI'>Date IRI</font> - - > <font class='predicate'>time:inXSDDate</font> - - > <font class='literal'>Date value</font>

<font class='objectIRI'>Interval IRI</font> - - - <font class='predicate'>time:hasEnd</font>  - - > <font class='objectIRI'>Date IRI</font> - - > <font class='predicate'>time:inXSDDate</font> - - > <font class='literal'>Date value</font>
</pre>

<pre style="background-color:#DDEEBB;">
  :DateShape a sh:NodeShape ;
    sh:targetObjectsOf time:hasBeginning ;
    sh:targetObjectsOf time:hasEnd ;
    sh:class study:ReferenceEnd ;
    sh:property [
      sh:path time:inXSDDate ;  
      sh:datatype xsd:date ;
    ] .  
</pre>

Validation Report (excerpt):

<pre style="background-color:#EEDDBB;">
  a sh:ValidationReport ;
    sh:conforms false ;
    sh:result [
      a sh:ValidationResult ;
        sh:value "<font class='error'>7-DEC-16</font>" ;
        sh:resultPath time:inXSDDate ;
        sh:sourceConstraintComponent sh:DatatypeConstraintComponent ;
        sh:focusNode <font class='objectIRI'>cj16050:Date_7-DEC-16 </font>;
        sh:sourceShape [] ;
        sh:resultSeverity sh:<font class='error'>Violation</font>
    ]  
</pre>

**3.1.2 RefIntervalShape**

*THIS SECTION IS BEING REWORKED* 

<font class='error'>This section subject to change based on ReferenceInterval IRI creation method</font>

<pre style="background-color:#DDEEBB;">
  :RefIntervalShape a sh:NodeShape ;
    sh:targetClass study:AnimalSubject ;  
    sh:nodeKind sh:IRI ;
    sh:path study:hasReferenceInterval ;
    sh:minCount 1;
    sh:maxCount 1 .
</pre>  

Validation Report (excerpt):

*a) More than one interval*

<pre style="background-color:#EEDDBB;">
   COMING SOON
</pre>

*b) No interval*

<pre style="background-color:#EEDDBB;">
   COMING SOON
</pre>



**3.1.3 SD1002RuleShape**
The SD1002RuleShape uses SHACL-SPARQL to determine if the end date (rfendtc) is *NOT* greater than or equal to the start date (rfstdtc), as required by the rule. SHACL Core can not be used for this constraint because the date values are not directly attached to a focus node (refer back to Figure 1). 

The first step is to create a SPARQL query that detects the data violation where End Data is not greater than or equal to start date.

<pre style="background-color:#DDEEFF;">
  PREFIX study: <https://w3id.org/phuse/study#> 
  PREFIX sh:   <http://www.w3.org/ns/shacl#> 
  PREFIX time: <http://www.w3.org/2006/time#>

  SELECT $this (?beginDate AS ?intervalStart) (?endDate AS ?intervalEnd)
      WHERE {
        $this     time:hasBeginning  ?beginIRI ;
                  time:hasEnd        ?endIRI .
        ?beginIRI time:inXSDDate     ?beginDate .
        ?endIRI   time:inXSDDate     ?endDate .
        FILTER  (! (?endDate >= ?beginDate ))
      }
</pre>


Next, add the SPARQL query to the SHACL file to create a SHACL-SPARQL shape. 

<pre style="background-color:#DDEEBB;">
  :SD1002RuleShape a sh:NodeShape ;
   sh:targetClass study:ReferenceInterval ;
   sh:sparql [
    a sh:SPARQLConstraint ;
    sh:message "RFSTDTC is after RFENDTC";
    sh:prefixes [
      sh:declare [ sh:prefix "time" ;
        sh:namespace "http://www.w3.org/2006/time#"^^xsd:anyURI ;
      ],
      [ sh:prefix "study" ;
        sh:namespace "https://w3id.org/phuse/study#"^^xsd:anyURI ;
      ]  
    ] ;
   sh:select
    """SELECT $this (?beginDate AS ?intervalStart) (?endDate AS ?intervalEnd)
      WHERE {
        $this     time:hasBeginning  ?beginIRI ;
                  time:hasEnd        ?endIRI .
        ?beginIRI time:inXSDDate     ?beginDate .
        ?endIRI   time:inXSDDate     ?endDate .
        FILTER  (! (?endDate >= ?beginDate ))
      }""" ;
  ] .
</pre>

Validation Report (excerpt):

<pre style="background-color:#EEDDBB;">
 a sh:ValidationReport ;
  sh:conforms false ;
  sh:result [
    a sh:ValidationResult ;
      sh:sourceConstraint [] ;
      sh:focusNode cj16050:Interval_2016-12-07_2016-12-06 ;
      sh:resultSeverity sh:Violation ;
      sh:sourceShape :SD1002RuleShape ;
      sh:resultMessage "<font class='error'>RFSTDTC is after RFENDTC</font>" ;
      sh:sourceConstraintComponent sh:SPARQLConstraintComponent ;
      sh:value <font class='error'>cj16050:Interval_2016-12-07_2016-12-06</font>
</pre>

### 4. Applying the Constraints

**4.1 Stardog via Stardog Studio**

**4.1.1 Execute the Report on Data in the Database**

1. Create a test database named SENDConform in Stardog.
1. Load the data file **DM-CJ16050-R.TTL** .
1. Open the SHACL constraint file **SHACL-SD1002.TTL** into Stardog Studio.
1. Select the file type as SHACL (lower right corner of Studio)
1. From the ADD CONSTRAINT drop down (upper left), select the drop down button and choose Get Validation Report. This executes the report without adding the constraint to the database. Too add the constraint to the database so it is available for command line execution (see 4.1.2), select "Add Constraint." **NOTE:** *There are problems removing constraints from the database that may require dropping the data base and recreating it to avoid duplicate messages in the validation report from sucesssive add/remove steps. Observed and reported to Stardog for version 6.1.  2019-07-18.*

1. Scroll through the report and find the resultMessages for the data errors. The report is easier to view from the command line execution. 

**4.1.2 Stardog via command line**

1. Assuming Stardog is available on the command line and the data and constraints are added into the SHACLTest database, execute this command:

<pre style="background-color:#F6F6F6;">
  stardog icv report SENDConform
</pre>

You may redirect the report to a text file on your local machine, assuming you have the repository cloned to C:\_github\SENDConform 

<pre style="background-color:#F6F6F6;">
  stardog icv report SHACLTest > "C:\_github\SENDConform\SHACL\CJ16050Constraints\ValReport.txt"
</pre>

**4.2  TopBraid**

INSTRUCTIONS TO BE ADDED

[Back to TOC](TableOfContents.md)
