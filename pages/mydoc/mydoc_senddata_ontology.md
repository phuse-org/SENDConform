---
title: Ontology
last_updated: 2020-01-02
sidebar: mydoc_sidebar
permalink: mydoc_senddata_ontology.html
folder: mydoc
---

## Introduction

<font class='toBeAdded'>Add: Describe the ontologies used for Data Conversion and Validation.</font>

## Modeling Philosophy
<font class='toBeAdded'>Add.</font>

## Web Protege
<font class='toBeAdded'>Add: How to access and use Web Protege for the project ontologies</font>

## Ontology Notes from Armando

### Ontology files and related components created using TopBraid.

The protocol file imports the study ontology. The instance file imports the protocol file. When ready to "publish" to SEND format it also imports the SEND ontology into a new file called:  `cj160500send.shapes.ttl`

 `cj160500send.shapes.ttl` has everything integrated and linked into one mega-graph, so that SHACL rules pertaining to data quality have a home by linking to resources under the study: namespace and SHACL rules pertaining to SEND conformance issues can be linked to resources under the send: namespace. For example, time interval is a universal concept with start date must be before end date is a universal, "data quality" type of issue, and sure enough the rules can be linked to the `time:Interval` class. On the other hand, the fact that a SEND domain like DM or TS must be present, this is a SEND specific conformance rule that can be linked to the `send:SENDDomain_DM`  or `send:SENDDomain_TS` class.

`send.ttl` file is a bare bones ontology written by AO from scratch to support the prototype. In essence, it documents the requirements for what a robust SEND ontology should be able to support, at a minimum, to allow round-tripping and  SHACL rules validation.  It would be useful if other team members could look at this work and try replacing this rudimentary ontology with something more robust, capable of supporting all the domains not just DM/TS.

{% include links.html %}
