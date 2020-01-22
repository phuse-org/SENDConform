---
title: Ontology for Submission
last_updated: 2020-01-13
sidebar: conform_sidebar
permalink: submit_background_and_rationale.html
folder: mydoc
---

# <font class='toBeAdded'> This page is DRAFT</font>



## Introduction

Study data submitted to the FDA must meet structure (format) and completeness (content) standards detailed in the **FDA Standards Catalog** <font class='toBeAdded'>(Add Ref)</font> as a first step in the submission process, and the FDA may reject an application based solely on technical deficiencies. The "Technical Rejection Criteria for Study Data (TRC)" detail a number of requirements of varying severity. [Chen and Hussong (2019)](FDA/PhUSEUSConnect2019-SA15.pdf) reported a recent analysis of 2016-2018 data showed approximately 32% of submissions contained critical errors.  

The submission rules are not complex, but there can be confusion surrounding their implementation. The FDA recently created a [Self-Check Worksheet for Study Data Preparation](FDA/TRC Self-Check Worksheet_01222019.pdf) and accompanying [Instructions](FDA/TRC Worksheet Instructions_01222019.pdf) to assist applicants in preparing their submissions. The rules could easily be extended to additional structure and quality checks.

## Project Rationale

The submission process can be greatly streamlined by automating conformance to the technical submission requirements when the process and data are based on Linked Data principles. Data quality will be increased. Rejection of submissions due to technical issues can be avoided when both sponsors and regulatory agencies employ the same, automated, evaluation processes.

## Background
<a name='background'></a>
Both nonclinical and clinical studies starting after 2016-12-17 for <a href="#" data-toggle="tooltip" data-original-title="{{site.data.glossary.NDA}}">NDA</a>s, <a href="#" data-toggle="tooltip" data-original-title="{{site.data.glossary.BLA}}">BLA</a>s and <a href="#" data-toggle="tooltip" data-original-title="{{site.data.glossary.ANDA}}">ANDA</a>s , and 2017-12-17 for <a href="#" data-toggle="tooltip" data-original-title="{{site.data.glossary.IND}}">IND</a>s require sponsors to use the data standards listed in the FDA Data Standards Catalog <font class='toBeAdded'>(Add Ref)</font>.  Both <a href="#" data-toggle="tooltip" data-original-title="{{site.data.glossary.CDER}}">CDER</a> and <a href="#" data-toggle="tooltip" data-original-title="{{site.data.glossary.CBER}}">CBER</a> centers are automating the review of study data submissions based on these specifications. Both regulatory agencies and submitters would benefit from basing the validation process on Linked Data.


## Criteria for Automated Validation

The rules applied to the data depend on Study Start Date (SSD) <a href='#background'>as detailed above</a>, so an accurate determine of that date is required. The automated process at the FDA relies on the <a href="#" data-toggle="tooltip" data-original-title="{{site.data.glossary.SSD}}">SSD</a> value provided in the Trial Summary domain (TS) in the dataset file TS.XPT.  The TS dataset is referenced in the Study Tagging File (STF). Therefore, both the TS file(s) and STF must be present and cross referenced to facilitate this automated process. Furthermore, the study start date is a derived data point (e.g. for human trials, it is the earliest date informed consent is obtained for all study subjects). Currently it is not possible to automate that the SSD was derived correctly. Linked Data provides that capability. TS domain content varies based on type of study and if it is submitted in compliance with <a href="#" data-toggle="tooltip" data-original-title="{{site.data.glossary.SSD}}">CDISC</a> Standards. For the purpose of this prototype we assume the following: <font class='toBeAdded'>(Add type and date of data submission (or multiple), with resulting validation assumptions.)</font>

<font class='toBeAdded'>Additional content to be added</font>


{% include links.html %}
