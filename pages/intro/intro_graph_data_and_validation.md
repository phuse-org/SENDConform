---
title: Graph Data and Validation
last_updated: 2020-02-14
sidebar: home_sidebar
permalink: intro_graph_data_and_validation.html
folder: intro
---

## Graph Data
Source data for this project is converted from SAS Transport (XPT) row-by-column formt to Resource Description Framework (RDF). In RDF, a Subject Node is linked to an Object Node by a Predicate. The Predicate provides a meaningful relation between the two nodes.

<img src="images/SubjectPredicateObject.PNG" width="400">

**Figure 1: Building Blocks of RDF: Subject, Predicate, Object**

<br><br>
Nodes and their relationships join together to create a graph network. The graph for a specific clinical trial has a shape that is defined by the entities and relationships within it. Individual entities like an Animal Subject or a Treatment Arm have their shapes defined by the data and relationships attached to them. Individual nodes have attributes that can be validated (node constraints) as can the incoming and outgoing relations from a node, and the values associated with those connections.

## Graph Validation using SHACL

When data has shape, so can the validation rules that act upon it. This is accomplished in RDF using the W3C Standard **Shapes Constraint Language (SHACL)**.  SHACL is itself a graph, written as familiar Subject--Predicate--Object triples, as are the resulting Validation reports. The book [Validating RDF Data](<https://book.validatingrdf.com/>) is an excellent resource for learning more about SHACL.

<img src="images/SHACLShapeConcept.PNG"/>

**Figure 2: SHACL Shapes Concept for Data Validation**


## Interconnected Data, Constraints, and Reports

<font class='toBeAdded'>Add: Show how data is connected to SHACL, and to the validation report</font>




{% include links.html %}
