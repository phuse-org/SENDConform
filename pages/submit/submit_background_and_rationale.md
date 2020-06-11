---
title: Background and Rationale
last_updated: 2020-06-11
sidebar: home_sidebar
permalink: submit_background_and_rationale.html
folder: submit
---

# <font class='toBeAdded'> This page is DRAFT</font>



## Introduction

As part of the submission process, study data submitted to the FDA must meet structure (format) and completeness (content) standards detailed in the **FDA Standards Catalog** <font class='toBeAdded'>(Add Reference)</font>. The FDA may reject an application based solely on technical deficiencies. The "Technical Rejection Criteria for Study Data (TRC)"<font class='toBeAdded'>(Add Reference)</font> details requirements of varying severity. In their analysis of data from 2016 to 201, [Chen and Hussong (2019)](FDA/PhUSEUSConnect2019-SA15.pdf) reported that approximately 32% of submissions contained critical errors.  

The submission rules are not complex, but confusion exists around their implementation. The FDA recently created a [Self-Check Worksheet for Study Data Preparation](FDA/TRC Self-Check Worksheet_01222019.pdf) and accompanying [Instructions](FDA/TRC Worksheet Instructions_01222019.pdf) to assist applicants in preparing their submissions. The rules could easily be extended to additional structure and quality checks to further improve the submission process for both applicants and the FDA.

## Rationale

The submission process can be greatly streamlined by automating conformance to the technical submission requirements when the process and data use Linked Data principles. Data quality will be increased. Rejection of submissions due to technical issues can be avoided when both sponsors and regulatory agencies employ the same, automated, evaluation processes.

## Background
<a name='background'></a>
The data standards listed in the FDA Data Standards Catalog <font class='toBeAdded'>(Add Ref)</font> must be applied for nonclinical and clinical study <a href="#" data-toggle="tooltip" data-original-title="{{site.data.glossary.NDA}}">NDA</a>s, <a href="#" data-toggle="tooltip" data-original-title="{{site.data.glossary.BLA}}">BLA</a>s and <a href="#" data-toggle="tooltip" data-original-title="{{site.data.glossary.ANDA}}">ANDA</a>s (with study start after 2016-12-17) and <a href="#" data-toggle="tooltip" data-original-title="{{site.data.glossary.IND}}">IND</a>s (study start after 
2017-12-17).  Both <a href="#" data-toggle="tooltip" data-original-title="{{site.data.glossary.CDER}}">CDER</a> and <a href="#" data-toggle="tooltip" data-original-title="{{site.data.glossary.CBER}}">CBER</a> centers are automating the review of study data submissions based on these specifications. Both regulatory agencies and submitters would benefit from basing the validation process on Linked Data.


## Criteria for Automated Validation

### Study Start Data (SSD) Example

Study Start Date (SSD) is a key component in submissions, so its accuracy is paramount. Automated processes at the FDA rely on the <a href="#" data-toggle="tooltip" data-original-title="{{site.data.glossary.SSD}}">SSD</a> value provided in the Trial Summary domain (TS) in the dataset file TS.XPT.  The TS dataset is referenced in the Study Tagging File (STF). Therefore, both the TS file(s) and STF must be present and cross referenced. Furthermore, the study start date is a derived data point (e.g. for human trials, it is the earliest date informed consent is obtained for all study subjects). Currently it is difficult to automate the validation of SSD derivation. Linked Data can faclitate this validation automation. 

<font class='toBeAdded'>This section will describe the data and how the validation can be automated.</a>
TS domain content varies based on type of study and if it is submitted in compliance with <a href="#" data-toggle="tooltip" data-original-title="{{site.data.glossary.SSD}}">CDISC</a> Standards. For the purpose of this prototype we assume the following: <font class='toBeAdded'>(Add type and date of data submission (or multiple), with resulting validation assumptions.)</font>

<font class='toBeAdded'>Content to be added.</font>


{% include links.html %}
