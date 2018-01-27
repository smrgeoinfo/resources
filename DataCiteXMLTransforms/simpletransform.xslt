<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco"
    xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:datetime="http://exslt.org/dates-and-times" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="datetime">

    <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
   
   

    <!-- This is a template to test software invocation of an xslt to operate on a DataCite XML record
		it does nothing useful except provide a way to test if a simple xslt can be executed in some
		environment. Used to test datadoi.php and Geoportal configuration for DataCiteXML ingest ..... -->
		
    <xsl:template match="/">
        <gmd:MD_Metadata xmlns:gmd="http://www.isotc211.org/2005/gmd"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gml="http://www.opengis.net/gml/3.2"
            xsi:schemaLocation="http://www.isotc211.org/2005/gmd http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/gmd/gmd.xsd">

            <!--  The fileIdentifier identifies the 
				metadata record, not the described resource which is identified by a DOI.
			-->


            <gmd:fileIdentifier>
                <gco:CharacterString>

                            <xsl:value-of
                                select="//*[local-name() = 'title'][1]"
                            />

                </gco:CharacterString>
            </gmd:fileIdentifier>

            <gmd:language>
                <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/"
                    codeListValue="eng">eng</gmd:LanguageCode>
            </gmd:language>
            <gmd:characterSet>
                <gmd:MD_CharacterSetCode
                    codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_CharacterSetCode"
                    codeListValue="utf8"/>
            </gmd:characterSet>

  
        </gmd:MD_Metadata>
    </xsl:template>

   

</xsl:stylesheet>
