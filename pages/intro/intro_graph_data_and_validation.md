---
title: Graph Data and Validation
last_updated: 2020-02-28
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

## Validation using SHACL

When data has shape, so can the validation rules that act upon it. This is accomplished in [RDF](https://www.w3.org/RDF/) using the W3C Standard [Shapes Constraint Language](https://www.w3.org/TR/shacl/) (**SHACL**).  SHACL is itself a graph, written as familiar Subject--Predicate--Object triples, as are the resulting Validation reports. A detailed description of SHACL syntax is beyond the scope of this project. Please refer to the [References and Resources](conform_references_and_resources.html) page to learn more about SHACL.

<img src="images/SHACLShapeConcept.PNG"/>

**Figure 2: SHACL Shapes Concept for Data Validation**

## Interconnected Data, Constraints, and Reports

Validation reports from SHACL are also graph data, making it possible to easily link the data, validation constraints, and report, as shown in this figure illustrating violation of FDA rule [SD0083](https://phuse-org.github.io/SENDConform/send_shacl_shapes.html#ruleSD0083). <font class='emph'>Click on the image to explore the connections in a 3-D visualization</font> (opens in a new window.)
<a href="https://phuse-org.github.io/SENDConform/visualization/usubjid/" target="_blank">
  <img src="images/3DVis-SD0083.PNG"/>
</a>  
**Figure 3: Violation of FDA Rule SD0083.**


| Color  | Type  | Explanation                      |
|--------|--------|---------------------------------|
| Grey   | Node   | Predicate. Predicates shown as nodes because SHACL and Report values attached to them. |
| Blue   |Node, Edge| Instance data
| Red    |  Node  | Data errors. In this case, two USUBJID values on for an animal subject|
| Green  | Node, Edge| SHACL|
| Yellow | Node,Edge | Report |
| Orange | Node       | Class. (A Type of thing, defined in an ontology) |


{% include links.html %}
