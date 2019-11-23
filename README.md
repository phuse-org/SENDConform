# SENDConform

**SENDConform** is a Proof of Concept for representing SEND conformance checks using Shapes Constraint Language (SHACL). The goal is to increase efficiency by decreasing labor-intensive checks performed by both study sponsors and regulatory agencies. It is a subproject of "Going Translational With Linked Data ( [GoTWLD](<https://github.com/phuse-org/CTDasRDF>) )"

To View on Github Pages:  https://phuse-org.github.io/SENDConform

Jump to [Table of Contents](doc/TableOfContents.md)

## Project Leads

* Tim Williams (PhUSE) <tim.williams@phuse.eu>

* Armando Oliva (Semantica LLC) <https://github.com/aolivamd>

* Rashed Hasan (FDA)

# Introduction

The Pharmaceutical Industry has long-relied on relational database systems and row-by-column data formats for data capture, storage, analysis, and submission to regulatory agencies. As the diversity of data sources increases and technology continues to evolve, these traditional data structures are increasingly inadequate. Graph databases are proving to be a valued data component in a comprehensive strategy, acting as a bridge between legacy systems and a more flexible, future-proof data model. Graph data can represent both the clinical trial *processes* and the resulting data and metadata from each step in the data life cycle. The flexible nature of the graph schema allows data models to be built up and refined over time. The work described on these pages models pre-clinical (SEND) data and the validation rules surrounding its collection and submission to the FDA.

# Graph Data
Source data for this project is converted to Resource Description Framework (RDF), where a Subject Node is linked to an Object Node by a Predicate that supplies a meaningful relation between the two nodes.

<img src="doc/images/SubjectPredicateObject.PNG" width="500">

**Figure 1: Building Blocks of RDF: Subject, Predicate, Object**


Nodes and their relationships join together to create a network of relationships that can be described as a graph of data. The graph for a specific clinical trial has a shape that is defined by the entities and relationships within the graph. Entities within the graph denote like an Animal Subject, or a Treatment Arm have their shape defined by the data and relationships attached to them. Individual nodes have attributes that can be validated (node constraints) as can the incoming and outgoing relations from a node and the values associated with those connections.

When data has shape, it makes sense to define validation rules in terms of shapes. This is accomplished in RDF using the W3C Standard **Shapes Contraint Language (SHACL)**.  The book [Validating RDF Data](<https://book.validatingrdf.com/>) is an excellent resource for learning more about SHACL. 



<img src="doc/images/SHACLShapeConcept.PNG"/>

**Figure 2: SHACL Shapes Concept for Data Validation**


Individual FDA SEND rules are deconstructed into their constituent components. Each rule is interpreted, transformed to its corresponding SHACL shape, applied to example data to generate a validation report, then confirmed independently using SPARQL.


<b>NEXT:</b> [Table of Contents](doc/TableOfContents.md).


