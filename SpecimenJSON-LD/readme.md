# JSON-LD for specimens

This directory contains working files for developing JSON-LD metadata to describe specimens.  
Th intention is to reuse existing rdf vocabularies to the extent that they are applicable, to identify any new vocabulary that is required.

Doug Fils and I were discussing how to link datasets, specimens, publications, people, etc. better, building on the Schema.org markup in resource landing pages.  One missing information bit is the graph for parent child relationships between samples. This is important to be able to gather all the datasets and pub related to a given sample (have to find stuff linked to child samples, and option to include stuff linked to parent samples).

The idea of including schema.org markup in landing pages for registered samples came up, along with the question of what that would look like. I spent some time working on a draft ‘rock specimen’ schema.org document. Given its scope and origins, not surprisingly SDO is incomplete for what we need, so I looked into using extension from sosa, sam, and samfl.  The attached example uses samfl, prov, and oml.  

For the sdo types, I chose ‘Product’ to get material, category, isRelatedTo, weight, height, and width properties (for size), and ‘CreativeWork’ to get creator (Role--collector), provider (curator), dateCreated (collection date), locationCreated (where it was collected). 

The samfl extensions are necessary to capture currentLocation (?could do with provider???), sampling procedure (prov:wasGeneratedBy),  samplingMethod.   

There are some overlapping properties where it seems that there are schema.org properties close enough to samfl to use for sdo compatibility
- prov:wasDerivedFrom -- sdo:isRelatedTo 
- samfl:complex/samfl:relatedSamplingFeature -- sdo:isRelatedTo
- samfl:samplingLocation – sdo:locationCreated
- samfl:samplingTime -- sdo: dateCreated
- prov:wasAssociatedWith -- sdo:creator
- samfl:sampledFeature -- sdo:about

I used sdo:category and sdo:material for specimenType, and material, which are both represented as rdf:type in the samfl example.  Using the rdf:type for specimenType makes sense, but I don’t think that the specimen.material identifier as an rdf:type of the specimen is coherent.  The relation to material is ‘composedOf’ not ‘isA’. 

Anyway, I’m looking for comments/feedback, particularly on how to represent the parent-child relationships and the sdo element mappings.   Next step will be to generate the markup for SESAR samples to link with IGSN’s in EarthChem Library metadata. 

