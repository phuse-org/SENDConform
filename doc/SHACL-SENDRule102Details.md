<link href="styles.css" rel="stylesheet"/>

# SEND Rule 102 in SHACL
# RFSTDTC <= RFENDTC 

### 0. Background
Data for this example comes from the study \data\studies\RE Function in Rats . Values are added using R script Dm-convert.R to test contraint conditions.

### 1. FDA Rule
This example models the SEND-IG 3.0 rule **SD1020** for the DM domain as defined in the file [FDA-Validator-Rules.xlsx](https://github.com/phuse-org/SENDConform/tree/master/doc/FDA/FDA-Validator-Rules.xlsx)

FDA Validator Rule ID | FDA Validator Message | Publisher|  Publisher ID | Business or Conformance Rule Validated | FDA Validator Rule  
------|-------------------|-----|-------|--------------------------|-----------------------------
**SD1002** |RFSTDTC is after RFENDTC | FDA| FDAB034    |Study Start and End Dates must be submitted and complete. | Subject Reference Start Date/Time (RFSTDTC) must be less than or equal to Subject Reference End Date/Time (RFENDTC)

Examine the *FDA Validator Rule* and state the complete rule in natural language.

The rule: 

"***Subject Reference Start Date/Time (RFSTDTC) must be less than or equal to Subject Reference End Date/Time (RFENDTC).***"

contains the following explicit and implicit components.

#### Rule Components

1.1 Subject Reference Start Date/Time (RFSTDTC) and End Date/Time must be in <font class="emph">date format</font> (xsd:date or xsd:dateTime)

1.2 The implicit rule that each Animal Subject must have <font class="emph">a minimum of one and maximum of one value</font> for RFSTDTC and RFENDTC. 

1.3 The <b>SD1002 rule</b> itself: Start Date/Time must be less than or equal to End Date/Time (<font class="emph">RFSTDTC</font> less than or equal to RFENDTC</font>). When this rule is violated, the system should supply the standard FDA message <font class="error msg">"RFSTDTC is after RFENDTC"</font>. 

### 2. Data Structure and Implications for Constraints

**2.1 Example Data**

This example uses the DM domain data from the study "RE Function in Rats", located in the repository at [/data/studies/RE Function in Rats](https://github.com/phuse-org/SENDConform/tree/master/data/studies/RE%20Function%20in%20Rats) and converted to .TTL using R [r\DM-convert.R](https://github.com/phuse-org/SENDConform/blob/master/r/DM-convert.R). 
2.1.1 Data preparation
The R script adds observations to test the constraints. The added data is identified by the subjid and usubjid identifiers having the naming pattern 99M9<n>. 
A second TTL file is created in the location /SHACL/CJ16050Constraints. This file is manually edited to change the format of the date value `7-DEC-16` to `xsd:string` from the original `xsd:date`.
<pre>
time:inXSDDate "7-DEC-16"^^xsd:<font class="emph">string</font> ;
</pre>


A total of NNN errors should be detected: 
1. N
1. N
1. N
1. N

Familiarity with the data structure in TTL is necessary to explain the constraints. Here is a partial set of data for subjid 99M91 that violates rule SD1002 because end date preceeds start date.

<pre>
cj16050:Animal_99M91
    a study:AnimalSubject ;
    study:hasReferenceInterval cj16050:Interval_2016-12-07_2016-12-06 .

cj16050:Interval_2016-12-07_2016-12-06
    a study:ReferenceInterval ;
    time:hasBeginning cj16050:Date_2016-12-07 ;
    time:hasEnd cj16050:Date_2016-12-06 .
    
cj16050:Date_2016-12-07
    a study:ReferenceBegin ;
    time:inXSDDate "2016-12-07"^^xsd:date .

cj16050:Date_2016-12-06
    a study:ReferenceEnd ;
    time:inXSDDate "2016-12-06"^^xsd:date .
</pre>

A graphical representation of the data is shown in Figure 1. 

<img src="images/RefIntervalDataFail.PNG">
*Figure 1: Animal_99M91 (incomplete data)*


**Test-1: Date not in Datetime format**
<pre>

</pre>

**Test-2: Duplicate data**
<pre>

</pre>

**Test-3 : Start date after end date  [FDA Rule SD1002]**
<pre>
</pre>

The full data file is available here: [SHACL\Examples\CJ16050-DM-SD1002-TestData.TTL](https://github.com/phuse-org/SENDConform/blob/master/SHACL/Examples/CJ16050-DM-SD1002-TestData.TTL)


**2.2 Data Structure and Implications for Shape Constraints**

RDF triples for this example are created by associating values with an AnimalSubject. One row of data in the source DM file results in triples as shown for Subject CJ16050_00M01:
<pre>
    study:Subject_CJ16050_00M01
        a              study:AnimalSubject ;
        study:rfendtc  "2016-12-07"^^xsd:date ;
        study:rfstdtc  "2016-12-07"^^xsd:date  ;
      <font class="extraInfo">... more data</font>
</pre>
The FDA Rules are translated to SHACL Shapes that evaluate portions of the data as illustrated in Figure 1. 

<img src="images/ShapeLayers.PNG">
*Figure 1 Shape for validating an Animal Subject and FDA SEND Rule SD1002*

### 3. Define the Constraints

**3.1 AnimalSubjectShape**

The SHACL file [SHACL\Examples\SHACL_AnimalSubject.TTL](https://github.com/phuse-org/SENDConform/blob/master/SHACL/Examples/SHACL_AnimalSubject.TTL) begins with the prefixes used in the shapes.In this example, `study:` represents a namespace for the study and the `sh:` prefix is used for SHACL. 

Below the prefixes, the first "outer" shape is defined. The target of `:AnimalSubjectShape` is all nodes of the class `AnimalSubject` in the data: `sh:targetClass study:AnimalShape` . Three property shapes are defined within this outer shape.

1. `:rfstdtcShape`  = shape for rfstdtc date values 
1. `:rfendtcShape`  = shape for rfendtc date values
1. `:SD1002RuleShape` = shape for FDA rule SD1002

<pre>
  @prefix study: <https://w3id.org/phuse/study#> .
  @prefix sh:   <http://www.w3.org/ns/shacl#> .
  
  :AnimalSubjectShape a sh:NodeShape ;
  sh:targetClass study:<font class="emph">AnimalSubject</font>;
  sh:property     :rfstdtcShape ;
  sh:property     :rfendtcShape ;
  sh:property     :SD1002RuleShape .  
</pre>

**3.2 Constraints**

Define the data constraints within each of the shapes within AnimalSubjectShape. 

**3.2.1 rfstdtc** (Rule 1.1, 1.2)
Date values must be a date format (either xsd:date or xsd:dateTime). There must be a minimum of one date value present (minCount 1) and not more than one value (maxCount 1).

<pre>
  <font class="codeCom"># RFSTDTC Constraints</font>
  :rfstdtcShape a  sh:PropertyShape;
    sh:path     study:rfstdtc ;
    sh:or (
      [sh:datatype xsd:date ; ]
      [sh:datatype xsd:dateTime ; ]
    ) ;
    sh:minCount 1 ;
    sh:maxCount 1 .
</pre>

**3.2.2 rfendtc** (Rule 1.1, 1.2)
The same rules apply to the date variable TFENDTC:

<pre>
<font class="codeCom"># RFENDTC Constraints</font>
:rfendtcShape a  sh:PropertyShape;
  sh:path     study:rfendtc ;
  sh:or (
    [sh:datatype xsd:date ; ]
    [sh:datatype xsd:dateTime ; ]
  ) ;
  sh:minCount 1 ;
  sh:maxCount 1 .
</pre>

**3.2.3 SD1002 Rule : RFSTDTC Less than or Equal to RFENDTC** (Rule 1.3)

Finally, the AnimalSubjectShape is completed by adding the SD1002 PropertyShape, where RFSTDTC must be less than or equal to RFENDTC.

<pre>
<font class="codeCom"># SD1002 Constraint</font>
:SD1002RuleShape a :PropertyShape  ;
  sh:path              study:rfstdtc ;
  sh:lessThanOrEquals  study:rfendtc ;
  sh:message "RFSTDTC is after RFENDTC." .

</pre>

### 4. Applying the Constraints

**4.1 Stardog via Stardog Studio**

**4.1.1 Execute the Report on Data in the Database**

1. Create a test database named SHACLTest in Stardog.
1. Load the data file CJ16050-DM-SD1002-TestData.TTL .
1. Open the SHACL constraint file SHACL_AnimalSubject.TTL into Stardog Studio.
1. Select the file type as SHACL (lower right corner of Studio)
1. From the ADD CONSTRAINT drop down (upper left), select the drop down button and choose Get Validation Report. This executes the report without adding the constraint to the database. Too add the constraint to the database so it is available for command line execution (see 4.1.2), select "Add Constraint." **NOTE:** *There are problems removing constraints from the database that may require dropping the data base and recreating it to avoid duplicate messages in the validation report from sucesssive add/remove steps. Observed and reported to Stardog for version 6.1.  2019-07-18.*

1. Scroll through the report and find the resultMessages for the data errors. The report is easier to view from the command line execution. 

**4.1.2 Stardog via command line**

1. Assuming Stardog is available on the command line and the data and constraints are added into the SHACLTest database, execute this command:

    stardog icv report SHACLTest

You may redirect the report to a text file on your local machine, assuming you have the repository cloned to C:\_github\SENDConform 

    stardog icv report SHACLTest > "C:\_github\SENDConform\SHACL\Examples\ValReport.txt"


**4.2  TopBraid**

Instructions will be added later.

### 5. Validation Report

**Violation 1:  Date Format**  (Rule 1.1)
<pre>
  a sh:ValidationResult ;
    sh:focusNode study:<font class="emph">Subject_TEST-1</font> ;
    sh:resultPath study:<font class="emph">rfendtc</font> ;
    sh:value "<font class="error">2019-01-30</font>" ;
    sh:sourceShape :rfendtcDateShape ;
    sh:sourceConstraintComponent sh:OrConstraintComponent ;
    sh:resultSeverity sh:Violation 
</pre>

**Violation 2: Minimum one / Maximum One value** (Rule 1.2)
Note how there are two values for each date, so separate messages for RFSTDTC and RFENDTC. SHACL does not identify the values, only the Object (Subject-TEST-2) where the values are duplicated.
<pre>
  a sh:ValidationResult ;
    sh:focusNode study:<font class="emph">Subject_TEST-2</font> ;
    sh:resultPath study:<font class="emph">rfendtc</font> ;
    sh:sourceConstraintComponent sh:<font class="error">MaxCountConstraintComponent</font> ;
    sh:sourceShape :rfendtcDateShape ;
    sh:resultSeverity sh:Violation 

  a sh:ValidationResult ;
    sh:focusNode study:<font class="emph">Subject_TEST-2</font> ;
    sh:resultPath study:<font class="emph">rfstdtc</font> ;
    sh:sourceConstraintComponent sh:<font class="error">MaxCountConstraintComponent </font>;
    sh:sourceShape :rfstdtcDateShape ;
    sh:resultSeverity sh:Violation 
</pre>


**Violation 3: SD1002 Rule : RFSTDTC Less than or Equal to RFENDTC** (Rule 1.3)
<pre>
  a sh:ValidationResult ;
    sh:focusNode study:<font class="emph">Subject_TEST-3</font> ;
    sh:resultPath study:<font class="emph">rfstdtc</font> ;
    sh:value "2016-12-09"^^xsd:date ;
    sh:sourceConstraintComponent sh:LessThanOrEqualsConstraintComponent ;
    sh:resultMessage "<font class="error">RFSTDTC is after RFENDTC.</font>" ;
    sh:sourceShape :SD1002RuleShape ;
    sh:resultSeverity sh:Violation
</pre>

[Back to TOC](TableOfContents.md)
