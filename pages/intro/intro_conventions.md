---
title: Conventions
last_updated: 2020-02-28
sidebar: home_sidebar
permalink: intro_conventions.html
folder: intro
---

## Documentation

<div class='ruleState'>
  <div class='ruleState-header'>Rule Statement</div>
  Grey boxes contain brief syntax / pseudo code for a rule.
</div>

<div class='def'>
  <div class='def-header'>Description</div>
  Blue boxes contain a textual description of a rule.
</div>

<pre class="data">
   This box contains a subset of data that serves as input to test the shapes graph.
   Intentional error values are <font class='error'>highlighted in red.</font>
   Data not relevant to the discussion is omitted and shown as <font class='infoOmitted'>...</font>
</pre>

<pre class="sms">
   Stardog Mapping Syntax, used to import CSV files to the database.
</pre>

<pre class="owl">
   Contains an excerpt from an ontology that is relevant to the rule being described.
   Optional: not all rules rely on the project ontologies.
</pre>

<pre class="shacl">
  Contains a representation of the shapes graph (in full or in part).
</pre>

<pre class="report">
  Excerpts from the SHACL Validation Report (the Output Results graph.)
</pre>

<pre class="sparql">
  SPARQL statements used to retrieve additional information based on values identified in the report or
  to validate values identified in the validation report.
</pre>

<pre class="queryResult">
  Results of a SPARQL query for tracing information from the Report back to additional information or to verify
   the SHACL constraint is catching all test cases.
</pre>



{% include links.html %}
