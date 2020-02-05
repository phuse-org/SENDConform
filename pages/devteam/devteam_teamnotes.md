---
title: Team Notes
last_updated: 2020-02-05
sidebar: conform_sidebar
permalink: devteam_teamnotes.html
folder: devteam
---

## Randomization and Eligibility

Paraphrased from AO email 2020-01-25


In theory, a subject who fails eligibility should not proceed to Randomization. The project ontology is activity-centric, so the Eligibility Determination <font class='emph'>is the start rule</font> for the Randomization activity.  This allows us to define a NOTASSGN or SCRNFL arm based on the defined outcomes of the Eligibility Determination and Randomization. This makes it possible to automate protocol compliance and identify protocol violators.  

Anyone with Eligibility Determination = FALSE must not have a Randomization outcome triple, yet in reality we see it all the time, either because of human error or an intentional attempt to violate the protocol.

Right now the two "states" of NOTASSGN and SCRNFL cannot be verified/validated automatically, but our approach opens that up as an option.

### Eligibility

"Eligibility Determination" in an animal study is not usually considered but it does exist.  <font class='emph'>Allocation</font> appears as a super class if the study uses a different technique other than randomization to allocate animals to treatment arms

### Enrollment

There is no agreed upon definition for enrollment. This project can define Enrollment in a machine computable way, specifically and computationally. The following definition of enrollment is proposed (see `study:EnrolledSubject skos:definition` triple in the ontology) and aligns with most clinician's view of enrollment.


<div class='def'>
  <div class='def-header'>Enrollment</div>
    A Study Subject that has been allocated to a treatment arm in a Study. An Enrolled Subject includes Eligible subjects but may include ineligible subjects who are accidentally or intentionally allocated to a treatment arm; therefore is not a subClass of Eligible Subject necessarily. In a randomized trial, it is equivalent to a Randomized Subject.
</div>




{% include links.html %}
