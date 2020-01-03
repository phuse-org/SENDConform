#______________________________________________________________________________
# FILE: r/validation/compTriplesTTL-app/global.R
# DESC: Compare triples in two TTL files, starting at a named Subject.
#         Used to compare instance data created in the Ontology approach with
#         data converted using R
# SRC :
# IN  : TTL files in a local folder. Typically /data/rdf
# OUT : 
# REQ : 
# SRC : 
# NOTE: 
#       ui.R
# TODO: 
#______________________________________________________________________________
library(plyr)    #  rename
library(dplyr)   # anti_join. Must load dplyr AFTER plyr!!
library(reshape) #  melt
library(rdflib)  # new for testing 
library(shiny)

rm(list = ls(all.names = TRUE))  # Clear workspace

setwd("C:/_gitHub/SENDConform")

# Functions
source('r/Functions.R')

prefixes <-"
PREFIX cj16050:  <https://example.org/cj16050#>
PREFIX code:     <https://w3id.org/phuse/code#>
PREFIX country: <http://psi.oasis-open.org/iso/3166/#>
PREFIX custom: <https://github.com/phuse-org/CTDasRDF/tree/master/data/rdf/custom#>
PREFIX meddra: <https://w3id.org/phuse/meddra#>
prefix owl:   <http://www.w3.org/2002/07/owl#>
PREFIX rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#> 
PREFIX sdtm: <https://github.com/phuse-org/SDTMasRDF/blob/master/data/rdf/sdtm#>
PREFIX sdtm-terminology: <https://github.com/phuse-org/CTDasRDF/tree/master/data/rdf/sdtm-terminology#> 
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX sp: <http://spinrdf.org/sp#> 
PREFIX spin: <http://spinrdf.org/spin#> 
PREFIX study:  <https://w3id.org/phuse/study#>
PREFIX time:  <http://www.w3.org/2006/time#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#> "