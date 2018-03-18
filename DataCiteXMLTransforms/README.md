# DataCiteXMLTransforms

This folder contains XSLT transform modules for converting DataCiteXML to ISO19139, to HTML, and to HTML with Schema.org markup in the html <head> section. The transforms are constructed to work with dataCite v2, v3, or v4 XML. 
What's here:
    
## Datadoi.php 
php script used in the get.iedadata.org/doi website to handle requests for DOI landing pages by getting the DataCiteXML file and transforming it to HTML. The PHP page takes input parameter that is the final token of an IEDA DOI, which will be a 6 digit integer.The DataCite metadata files are located in htdocs/metadata/doi directory. The php calls the dataciteToHTMLwithSDO.xsl xml transform to generate the html page that is returned as the dataset landing page.

dataciteToHTMLwithSDO.xsl imports DataCiteToSchemaOrgDataset1.0.xslt, which transforms the DataCite xml to insert a Schema.org JSON-LD script in the <head> section of the html page that is generated for use by schema.org aware search engines. 
    
## dataciteToHTML.xslt
Transforms datacite v2,3, or 4 xml to HTML to generate IEDA dataset landing page.

## dataciteToSchemaOrgDataset1.0.xslt
Transforms datacite v2,3, or 4 xml to a JSON-LD dataset object containing schema.org version
of the metadata. The main transform starts on line 823: 
<xsl:template match="//*[local-name() = 'resource']">

## dataciteToHTMLwithSDO.xslt
Same as dataciteToHTML.xslt, but imports dataciteToSchemaOrgDataset1.0 xslt to insert
the JSON-LD as an script with type application/ld+json. The imported transform is invoked
on line 61 xsl:apply-templates select="//*[local-name() = 'resource']"

## dataciteToISO19139v3.2.xslt
This transform takes a datacite v2,3, or 4 xml document and transforms to ISO19139 xml. The transform uses local-names for elements, so for those elements that are the same in DataCite v2, 3 and 4 will work. 

relatedIdentifiers are put in gmd:aggregationInfo elements. 

funder information goes to gmd:identificationInfo/gmd:credit

gmd:metadataMaintainence element gets a note describing how the ISO record was generated

## simpletransform.xslt
This is a template to test software invocation of an xslt to operate on a DataCite XML record; it does nothing useful except provide a way to test if a simple xslt can be executed in some environment. Used to test datadoi.php and Geoportal configuration for DataCiteXML ingest (which didn't work in Geoportal v2.5.1)
    
## archive 
This subdirectory contains older versions of various files.


