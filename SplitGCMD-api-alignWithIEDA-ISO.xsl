<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco"
    xmlns:gml="http://www.opengis.net/gml" xmlns:gmi="http://www.isotc211.org/2005/gmi"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:srv="http://www.isotc211.org/2005/srv"
    xmlns:usgin="http://resources.usgin.org/xslt/ISO2USGINISO" version="2.0">
    
    <!-- this template takes a document containing a collection of gmd:MD_Metadata xml element inside of some container,
    and modifies the xml to conform to IEDA metadata practice. 
    The original document was created by SMR USGIN for unbundling CSW getRecord requests and doing some clean up work.
    In this instance, the container is a collection of records from GCMD harvested via the GCMD CSW.
    Processing includes relocating content from invalid elements added by NASA, and copying distribution information from the 
    aggreationInformation section to the distribution section where it is normally placed. vertical extents have been converted 
    from encodeing using Geographic Identifier to gmd verticalExtent objects. 
    2017-09-07 SMR -->

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" name="xml"/>
    <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <xsl:variable name="alphabet" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz(:,'"/>
    <xsl:variable name="blank"
        select="'                                                             '"/>
    <xsl:variable name="number" select="'0123456789.-'"/>
    <xsl:variable name="USGIN-resourceTypes"
        select="'|collection|collection:dataset|collection:dataset:catalog|collection:physical artifact collection|document|document:image|document:image:stillimage|document:image:stillimage:human-generated image|document:image:stillimage:human-generated image:map|document:image:stillimage:photograph|document:image:stillimage:remote sensing earth image|document:image:moving image|document:sound|document:text|document:text:hypertext document|event|event:project|model|physical artifact|service|software|software:stand-alone-application|software:interactive resource|structured digital data item|sampling point|'"/>

    <xsl:variable name="metadataMaintenanceNote"
        select="'This metadata was harvested via csw bulk download of 3177 records on 2017-09-23 in ISO19139 
        xml format, and processed by IEDA SplitGCMD-api-alignWithIEDA.xsl to transform to conform 
        with IEDA metadata conventions. The transform is available on GitHub at 
        https://github.com/iedadata/resources. Vertical extent encoding moved from geographic 
        identifier to verticalExtent elements; extra > None strings in keyword paths removed; gml 
        3.2 namespace declaration changed to gml so records will validate. ISO19115-2 (gmi: 
        namespace) elements have been ignored. The acquisition informaton in the NASA GCMD records 
        is duplicated in the keywords sections, and none of the records contained any 
        gmi:LE_Lineage elements. No other gmi content was found in the harvested record set.
        '"/>
    <xsl:template match="/">
        <xsl:for-each select="//result">           
            <xsl:variable name="filename"
                select="concat(string(@concept-id), '.xml')"/>
        <xsl:for-each select="gmd:MD_Metadata | gmi:MI_Metadata">
            <xsl:variable name="var_InputRootNode" select="."/>
<!--            <xsl:variable name="filename"
                select="concat(string(gmd:fileIdentifier/gco:CharacterString), '.xml')"/>-->
            <!--   <xsl:value-of select="$filename" />  Creating  -->
            <xsl:result-document href="file:/C:/Users/Stephen%20Richard/Google%20Drive/IEDA/Systems/USAP/output/{$filename}" format="xml">

                <gmd:MD_Metadata xmlns:gco="http://www.isotc211.org/2005/gco"
                    xmlns:gml="http://www.opengis.net/gml"
                    xmlns:xlink="http://www.w3.org/1999/xlink"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xsi:schemaLocation="http://www.isotc211.org/2005/gmd http://schemas.opengis.net/csw/2.0.2/profiles/apiso/1.0.0/apiso.xsd">

                    <gmd:fileIdentifier>
                        <gco:CharacterString>
                            
                            <xsl:value-of select="substring-before($filename,'.xml')"/>
<!--                            <xsl:choose>
                                <xsl:when test="$var_InputRootNode/gmd:fileIdentifier">
                                    <xsl:value-of
                                        select="$var_InputRootNode/gmd:fileIdentifier/gco:CharacterString"
                                    />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="concat('http://www.opengis.net/def/nil/OGC/0/missing/', '2017-08-31T12:00:00Z')"
                                    />
                                </xsl:otherwise>
                            </xsl:choose>-->
                        </gco:CharacterString>
                    </gmd:fileIdentifier>

                    <!-- metadata language-->
                    <xsl:choose>
                        <xsl:when test="$var_InputRootNode/gmd:language">
                            <xsl:copy-of select="$var_InputRootNode/gmd:language"
                                copy-namespaces="no"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <gmd:language>
                                <!--<xsl:comment>no language in source metadata, USGIN XSLT inserted default value</xsl:comment> -->
                                <gmd:LanguageCode
                                    codeList="http://www.loc.gov/standards/iso639-2/php/code_list.php"
                                    codeListValue="eng">eng</gmd:LanguageCode>
                            </gmd:language>

                        </xsl:otherwise>
                    </xsl:choose>

                    <!-- characterSet defaults to UTF-8 if no character set is specified -->
                    <xsl:choose>
                        <xsl:when test="$var_InputRootNode/gmd:characterSet">
                            <xsl:copy-of select="$var_InputRootNode/gmd:characterSet"
                                copy-namespaces="no"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <gmd:characterSet>
                                <!--   <xsl:comment>no character set element in source metadata, USGIN XSLT inserted default value</xsl:comment>-->
                                <gmd:MD_CharacterSetCode
                                    codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/gmxCodelists.xml#MD_CharacterSetCode "
                                    codeListValue="utf8">UTF-8</gmd:MD_CharacterSetCode>
                            </gmd:characterSet>
                        </xsl:otherwise>
                    </xsl:choose>

                    <!-- hierarchyLevel defaults to dataset -->
                    <xsl:choose>
                        <xsl:when test="$var_InputRootNode/gmd:hierarchyLevel">
                            <xsl:copy-of select="$var_InputRootNode/gmd:hierarchyLevel"
                                copy-namespaces="no"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <gmd:hierarchyLevel>
                                <!--    <xsl:comment>no hierarchyLevel in source metadata, USGIN XSLT inserted default value</xsl:comment> -->
                                <gmd:MD_ScopeCode
                                    codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/gmxCodelists.xml#MD_ScopeCode"
                                    codeListValue="Dataset">dataset</gmd:MD_ScopeCode>
                            </gmd:hierarchyLevel>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- copy hierarchyLevelName -->
                    <xsl:choose>
                        <xsl:when test="$var_InputRootNode/gmd:hierarchyLevelName">
                            <xsl:copy-of select="$var_InputRootNode/gmd:hierarchyLevelName"
                                copy-namespaces="no"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <gmd:hierarchyLevelName>
                                <!--    <xsl:comment>no hierarchyLevelName in source metadata, USGIN XSLT inserted default value</xsl:comment> -->
                                <gco:CharacterString>Missing</gco:CharacterString>
                            </gmd:hierarchyLevelName>
                        </xsl:otherwise>
                    </xsl:choose>

                    <!--        <xsl:apply-templates select="$var_InputRootNode/gmd:contact"/>  -->
                    <!--use for multiple contact-->
                    <xsl:for-each select="$var_InputRootNode/gmd:contact">
                        <xsl:choose>
                            <xsl:when test="not(@gco:nilReason)">
                        <gmd:contact>
                            <xsl:call-template name="usgin:ResponsibleParty">
                                <xsl:with-param name="inputParty" select="gmd:CI_ResponsibleParty"/>
                                <xsl:with-param name="defaultRole">
                                    <gmd:role>
                                        <gmd:CI_RoleCode
                                            codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                                            codeListValue="pointOfContact"
                                            >pointOfContact</gmd:CI_RoleCode>
                                    </gmd:role>
                                </xsl:with-param>
                            </xsl:call-template>

                        </gmd:contact>
                            </xsl:when>
                        <xsl:otherwise>
                            <gmd:contact gco:nilReason="missing"/>
                        </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <gmd:dateStamp>
                        <gco:DateTime>
                            <xsl:call-template name="usgin:dateFormat">
                                <xsl:with-param name="inputDate"
                                    select="$var_InputRootNode/gmd:dateStamp"/>
                            </xsl:call-template>
                        </gco:DateTime>
                    </gmd:dateStamp>

                    <gmd:metadataStandardName>
                        <gco:CharacterString>
                            <xsl:value-of select="'ISO 19115:2003/19139'"/>
                        </gco:CharacterString>
                    </gmd:metadataStandardName>

                    <gmd:metadataStandardVersion>
                        <gco:CharacterString>
                            <xsl:value-of select="'1.2; ISO-USGIN'"/>
                        </gco:CharacterString>
                    </gmd:metadataStandardVersion>

                    <!--                   <gmd:dataSetURI>
                        <gco:CharacterString>
                            <xsl:choose>
                                <xsl:when test="$var_InputRootNode/gmd:datasetURI/gco:CharacterString">
                                    <xsl:value-of
                                        select="$var_InputRootNode/gmd:datasetURI/gco:CharacterString"/>
                                </xsl:when>
                                <xsl:when
                                    test="$var_InputRootNode/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:ISBN">
                                    <!-\-  <xsl:comment>no resource identifier in source metadata, USGIN XSLT uses citation ISBN</xsl:comment> -\->
                                    <xsl:value-of
                                        select="concat('ISBN:',normalize-space(string($var_InputRootNode/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:ISBN)))"
                                    />
                                </xsl:when>
                                <xsl:when
                                    test="$var_InputRootNode/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:ISSN">
                                    <!-\-      <xsl:comment>no resource identifier in source metadata, USGIN XSLT uses citation ISSN</xsl:comment> -\->
                                    <xsl:value-of
                                        select="concat('ISSN:',normalize-space(string($var_InputRootNode/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:ISSN)))"
                                    />
                                </xsl:when>
                                <xsl:when
                                    test="$var_InputRootNode/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier">
                                    <!-\-    <xsl:comment>no resource identifier in source metadata, USGIN XSLT uses citation identifier</xsl:comment>-\->
                                    <xsl:value-of
                                        select="normalize-space(string($var_InputRootNode/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier))"
                                    />
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-\-  <xsl:comment>no resource identifier in source metadata, USGIN XSLT inserted nil value</xsl:comment>-\->
                                    <xsl:value-of
                                        select="concat('http://www.opengis.net/def/nil/OGC/0/missing/','2013-04-04T12:00:00Z')"
                                    />
                                </xsl:otherwise>
                            </xsl:choose>
                        </gco:CharacterString>
                    </gmd:dataSetURI>
  -->
                    <xsl:copy-of select="$var_InputRootNode/gmd:locale" copy-namespaces="no"/>
                    <xsl:copy-of select="$var_InputRootNode/gmd:spatialRepresentationInfo"
                        copy-namespaces="no"/>
                    <xsl:copy-of select="$var_InputRootNode/gmd:referenceSystemInfo"
                        copy-namespaces="no"/>
                    <!-- there may be multiple identificationInfo elements. Several metadata profiles put service distribution
                information in sv_serviceIdentification elements in the same records as MD_DataIdentification
              The USGIN profile used MD_DataIdentification and puts service-based distribution information in 
              the distributionInformation section.  If there are multiple MD_DataIdentification elements, only
              the first will be processed. SV_ServiceIdentification elements will be parsed in the distributionInfo
            template -->
                    <xsl:call-template name="usgin:identificationSection">
                        <xsl:with-param name="inputInfo"
                            select="$var_InputRootNode/gmd:identificationInfo/gmd:MD_DataIdentification[1]"
                        />
                    </xsl:call-template>


                    <xsl:call-template name="usgin:distributionSection">
                        <xsl:with-param name="inputDistro"
                            select="$var_InputRootNode/gmd:distributionInfo"/>
                    </xsl:call-template>
                    
                    <!-- don't copy dataquality sections with no useful content. this test is very specific 
                    to what the GCMS ISO service generates, pretty brittle...-->
                    <xsl:if test="not(count($var_InputRootNode/gmd:dataQualityInfo/descendant::node()/text()[string-length(normalize-space(.))>0])=2)
                        and not($var_InputRootNode/gmd:dataQualityInfo/descendant::node()/text()[string-length(normalize-space(.))>0][1]='series')
                        and not($var_InputRootNode/gmd:dataQualityInfo/descendant::node()/text()[string-length(normalize-space(.))>0][2]='PrecisionOfSeconds')">
                    <xsl:copy-of select="$var_InputRootNode/gmd:dataQualityInfo"
                        copy-namespaces="no"/>
                    </xsl:if>
                    <xsl:copy-of select="$var_InputRootNode/gmd:portrayalCatalogueInfo"
                        copy-namespaces="no"/>
                    <xsl:copy-of select="$var_InputRootNode/gmd:metadataConstraints"
                        copy-namespaces="no"/>
                    <xsl:copy-of select="$var_InputRootNode/gmd:applicationSchemaInfo"
                        copy-namespaces="no"/>
                    <!--           <xsl:for-each select="$var_InputRootNode/gmd:metadataMaintenance">  -->
                    <gmd:metadataMaintenance>
                        <gmd:MD_MaintenanceInformation>
                            <xsl:choose>
                                <xsl:when
                                    test="$var_InputRootNode/gmd:metadataMaintenance/gmd:MD_MaintenanceInformation/gmd:maintenanceAndUpdateFrequency">
                                    <xsl:copy-of
                                        select="$var_InputRootNode/gmd:metadataMaintenance/gmd:MD_MaintenanceInformation/gmd:maintenanceAndUpdateFrequency"
                                        copy-namespaces="no"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <gmd:maintenanceAndUpdateFrequency>
                                        <!--no update frequency in source metadata, USGIN XSLT inserted 'irregular' as a default -->
                                        <gmd:MD_MaintenanceFrequencyCode
                                            codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_MaintenanceFrequencyCode"
                                            codeListValue="IRREGULAR">irregular
                                        </gmd:MD_MaintenanceFrequencyCode>
                                    </gmd:maintenanceAndUpdateFrequency>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:copy-of
                                select="$var_InputRootNode/gmd:metadataMaintenance/gmd:MD_MaintenanceInformation/gmd:dateOfNextUpdate"
                                copy-namespaces="no"/>
                            <xsl:copy-of
                                select="$var_InputRootNode/gmd:metadataMaintenance/gmd:MD_MaintenanceInformation/gmd:userDefinedMaintenanceFrequency"
                                copy-namespaces="no"/>
                            <xsl:copy-of
                                select="$var_InputRootNode/gmd:metadataMaintenance/gmd:MD_MaintenanceInformation/gmd:updateScope"
                                copy-namespaces="no"/>
                            <xsl:copy-of
                                select="$var_InputRootNode/gmd:metadataMaintenance/gmd:MD_MaintenanceInformation/gmd:updateScopeDescription"
                                copy-namespaces="no"/>
                            <xsl:copy-of
                                select="$var_InputRootNode/gmd:metadataMaintenance/gmd:MD_MaintenanceInformation/gmd:maintenanceNote"
                                copy-namespaces="no"/>
                            <!-- add a note that the record has been processed by this xslt -->
                            <gmd:maintenanceNote>
                                <gco:CharacterString>
                                    <xsl:value-of
                                        select="concat($metadataMaintenanceNote, '2013-04-04T12:00:00')"
                                    />
                                </gco:CharacterString>
                            </gmd:maintenanceNote>
                            <xsl:copy-of
                                select="$var_InputRootNode/gmd:metadataMaintenance/gmd:MD_MaintenanceInformation/gmd:contact"
                                copy-namespaces="no"/>
                        </gmd:MD_MaintenanceInformation>
                    </gmd:metadataMaintenance>
                    <!--            </xsl:for-each>  -->
                </gmd:MD_Metadata>

                <!-- <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
               -->
                <!--                <xsl:copy-of select="."/>-->
            </xsl:result-document>
        </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <!--    <xsl:template match="gmd:MD_Metadata | gmi:MI_Metadata">

    </xsl:template>-->

    <!-- Templates Start Here -->
    <!---Metadata contact-->

    <xsl:template name="usgin:ResponsibleParty">
        <!-- parameter should be a CI_ResponsibleParty node -->
        <xsl:param name="inputParty" select="."/>
        <xsl:param name="defaultRole" select="."/>
        <gmd:CI_ResponsibleParty>
            <gmd:individualName>
                <gco:CharacterString>
                    <xsl:choose>
                        <xsl:when test="$inputParty/gmd:individualName/gco:CharacterString">
                            <xsl:value-of
                                select="$inputParty/gmd:individualName/gco:CharacterString"/>
                        </xsl:when>
                        <xsl:otherwise>missing</xsl:otherwise>
                    </xsl:choose>
                </gco:CharacterString>
            </gmd:individualName>
            <gmd:organisationName>
                <gco:CharacterString>
                    <xsl:choose>
                        <xsl:when test="$inputParty/gmd:organisationName/gco:CharacterString">
                            <xsl:value-of
                                select="$inputParty/gmd:organisationName/gco:CharacterString"/>
                        </xsl:when>
                        <xsl:otherwise>missing</xsl:otherwise>
                    </xsl:choose>
                </gco:CharacterString>

            </gmd:organisationName>
            <xsl:copy-of select="$inputParty/gmd:positionName" copy-namespaces="no"/>
            <gmd:contactInfo>
                <gmd:CI_Contact>
                    <gmd:phone>
                        <gmd:CI_Telephone>
                            <xsl:choose>
                                <xsl:when
                                    test="$inputParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString">
                                    <xsl:for-each
                                        select="$inputParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice">
                                        <gmd:voice>
                                            <gco:CharacterString>
                                                <xsl:choose>
                                                  <xsl:when test="gco:CharacterString">
                                                  <xsl:value-of select="gco:CharacterString"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>999-999-9999</xsl:otherwise>
                                                </xsl:choose>
                                            </gco:CharacterString>
                                        </gmd:voice>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <gmd:voice>
                                        <gco:CharacterString>999-999-9999</gco:CharacterString>
                                    </gmd:voice>
                                </xsl:otherwise>
                            </xsl:choose>
                            <!-- if there is a voice phone -->
                            <!-- copy any fax numbers -->
                            <xsl:copy-of
                                select="$inputParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:facsimile"
                                copy-namespaces="no"/>
                        </gmd:CI_Telephone>
                    </gmd:phone>

                    <gmd:address>
                        <gmd:CI_Address>
                            <xsl:copy-of
                                select="$inputParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:deliveryPoint"
                                copy-namespaces="no"/>
                            <xsl:copy-of
                                select="$inputParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city"
                                copy-namespaces="no"/>
                            <xsl:copy-of
                                select="$inputParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:administrativeArea"
                                copy-namespaces="no"/>
                            <xsl:copy-of
                                select="$inputParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:postalCode"
                                copy-namespaces="no"/>
                            <!-- there will be an e-mail address -->
                            <xsl:choose>
                                <xsl:when
                                    test="$inputParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress">
                                    <xsl:for-each
                                        select="$inputParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress">
                                        <gmd:electronicMailAddress>
                                            <gco:CharacterString>
                                                <xsl:choose>
                                                  <xsl:when test="gco:CharacterString">
                                                  <xsl:value-of select="gco:CharacterString"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>missing@usgin.org</xsl:otherwise>
                                                </xsl:choose>
                                            </gco:CharacterString>
                                        </gmd:electronicMailAddress>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- no e-mail address in the source doc -->
                                    <gmd:electronicMailAddress gco:nilReason="missing">
                                        <!--   <xsl:comment>no e-mail address for contact in source metadata, USGIN XSLT inserted nil value</xsl:comment> -->
                                        <gco:CharacterString>missing@usgin.org</gco:CharacterString>
                                    </gmd:electronicMailAddress>
                                </xsl:otherwise>
                            </xsl:choose>

                        </gmd:CI_Address>
                    </gmd:address>
                    <xsl:copy-of
                        select="$inputParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource"
                        copy-namespaces="no"/>
                    <xsl:copy-of
                        select="$inputParty/gmd:contactInfo/gmd:CI_Contact/gmd:hoursOfService"
                        copy-namespaces="no"/>
                    <xsl:copy-of
                        select="$inputParty/gmd:contactInfo/gmd:CI_Contact/gmd:contactInstructions"
                        copy-namespaces="no"/>
                </gmd:CI_Contact>
            </gmd:contactInfo>

            <xsl:choose>
                <xsl:when test="$inputParty/gmd:role">
                    <xsl:copy-of select="$inputParty/gmd:role" copy-namespaces="no"/>

                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$defaultRole">
                            <xsl:copy-of select="$defaultRole" copy-namespaces="no"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <gmd:role>
                                <gmd:CI_RoleCode
                                    codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                                    codeListValue="pointOfContact">pointOfContact</gmd:CI_RoleCode>
                            </gmd:role>
                        </xsl:otherwise>
                    </xsl:choose>

                </xsl:otherwise>
            </xsl:choose>
        </gmd:CI_ResponsibleParty>
    </xsl:template>
    <!-- end of ResponsibleParty handler -->

    <!--Identification info - required regardless of repository output-->
    <xsl:template name="usgin:identificationSection">
        <xsl:param name="inputInfo"/>
        <gmd:identificationInfo>
            <gmd:MD_DataIdentification>
                <!-- elements from abstract MD_Identification -->
                <gmd:citation>
                    <gmd:CI_Citation>
                        <gmd:title>
                            <gco:CharacterString>
                                <xsl:value-of
                                    select="$inputInfo/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString"
                                />
                            </gco:CharacterString>
                        </gmd:title>

                        <xsl:copy-of
                            select="$inputInfo/gmd:citation/gmd:CI_Citation/gmd:alternateTitle"/>

                        <xsl:for-each
                            select="$inputInfo/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date">
                            <gmd:date>
                                <gmd:CI_Date>
                                    <gmd:date>
                                        <gco:DateTime>
                                            <xsl:call-template name="usgin:dateFormat">
                                                <xsl:with-param name="inputDate" select="gmd:date"/>
                                            </xsl:call-template>

                                        </gco:DateTime>
                                    </gmd:date>
                                    <xsl:copy-of select="gmd:dateType" copy-namespaces="no"/>
                                    <!--<gmd:dateType>
                                    <gmd:CI_DateTypeCode
                                        codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/gmxCodelists.xml#CI_DateTypeCode"
                                        codeListValue="publication"
                                        >publication</gmd:CI_DateTypeCode>
                                </gmd:dateType>-->
                                </gmd:CI_Date>
                            </gmd:date>
                        </xsl:for-each>
                        <xsl:copy-of select="$inputInfo/gmd:citation/gmd:CI_Citation/gmd:edition"
                            copy-namespaces="no"/>
                        <xsl:copy-of
                            select="$inputInfo/gmd:citation/gmd:CI_Citation/gmd:editionDate"
                            copy-namespaces="no"/>
                        <xsl:for-each
                            select="$inputInfo/gmd:citation/gmd:CI_Citation/gmd:identifier">
                            <gmd:identifier>
                                <xsl:apply-templates select="gmd:MD_Identifier"/>

                            </gmd:identifier>
                        </xsl:for-each>
                        <!--<xsl:copy-of select="$inputInfo/gmd:citation/gmd:CI_Citation/gmd:identifier"/>
-->
                        <!---Responsible Party may not be included in Repo output, yet It is required for USGIN validation.-->
                        <!-- for each statement alows more than one contact to be processed -->
                        <xsl:choose>
                            <xsl:when
                                test="$inputInfo/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty">
                                <xsl:for-each
                                    select="$inputInfo/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty">
                                    <gmd:citedResponsibleParty>
                                        <xsl:call-template name="usgin:ResponsibleParty">
                                            <xsl:with-param name="inputParty"
                                                select="gmd:CI_ResponsibleParty"/>
                                            <xsl:with-param name="defaultRole">
                                                <gmd:role>
                                                  <gmd:CI_RoleCode
                                                  codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                                                  codeListValue="originator"
                                                  >originator</gmd:CI_RoleCode>
                                                </gmd:role>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </gmd:citedResponsibleParty>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- no responsible party reported, put in minimal missing element -->
                                <gmd:citedResponsibleParty gco:nilReason="missing">
                                    <gmd:CI_ResponsibleParty>
                                        <gmd:individualName>
                                            <gco:CharacterString>missing</gco:CharacterString>
                                        </gmd:individualName>
                                        <gmd:contactInfo>
                                            <gmd:CI_Contact>
                                                <gmd:phone>
                                                  <gmd:CI_Telephone>
                                                  <gmd:voice>
                                                  <gco:CharacterString>999-999-9999</gco:CharacterString>
                                                  </gmd:voice>
                                                  </gmd:CI_Telephone>
                                                </gmd:phone>
                                            </gmd:CI_Contact>
                                        </gmd:contactInfo>
                                        <gmd:role>
                                            <gmd:CI_RoleCode
                                                codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                                                codeListValue="originator"
                                                >originatory</gmd:CI_RoleCode>
                                        </gmd:role>
                                    </gmd:CI_ResponsibleParty>
                                </gmd:citedResponsibleParty>
                            </xsl:otherwise>
                        </xsl:choose>

                        <xsl:copy-of
                            select="$inputInfo/gmd:citation/gmd:CI_Citation/gmd:presentationForm"
                            copy-namespaces="no"/>
                        <xsl:copy-of select="$inputInfo/gmd:citation/gmd:CI_Citation/gmd:series"
                            copy-namespaces="no"/>
                        <xsl:copy-of
                            select="$inputInfo/gmd:citation/gmd:CI_Citation/gmd:otherCitationDetails"
                            copy-namespaces="no"/>
                        <xsl:copy-of
                            select="$inputInfo/gmd:citation/gmd:CI_Citation/gmd:collectiveTitle"
                            copy-namespaces="no"/>
                        <xsl:copy-of select="$inputInfo/gmd:citation/gmd:CI_Citation/gmd:ISBN"
                            copy-namespaces="no"/>
                        <xsl:copy-of select="$inputInfo/gmd:citation/gmd:CI_Citation/gmd:ISSN"
                            copy-namespaces="no"/>

                    </gmd:CI_Citation>
                </gmd:citation>


                <xsl:choose>
                    <xsl:when test="$inputInfo/gmd:abstract[@gco:nilReason]">
                        <xsl:copy-of select="$inputInfo/gmd:abstract" copy-namespaces="no"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <gmd:abstract>
                            <!-- if there are other attributes on the abstract they will be lost  -->
                            <gco:CharacterString>
                                <xsl:value-of
                                    select="normalize-space(string($inputInfo/gmd:abstract))"/>
                            </gco:CharacterString>
                        </gmd:abstract>
                    </xsl:otherwise>
                </xsl:choose>

                <!--               <xsl:for-each select="$inputInfo/gmd:purpose[not(@gco:nilReason)]">
                    <gmd:purpose>
                        <gco:CharacterString>
                            <xsl:value-of select="normalize-space(string($inputInfo/gmd:purpose))"/>
                        </gco:CharacterString>
                    </gmd:purpose>

                </xsl:for-each>-->
                <xsl:copy-of select="$inputInfo/gmd:purpose" copy-namespaces="no"/>
                <xsl:copy-of select="$inputInfo/gmd:credit" copy-namespaces="no"/>
                <xsl:copy-of select="$inputInfo/gmd:status" copy-namespaces="no"/>
                <xsl:copy-of select="$inputInfo/gmd:pointOfContact" copy-namespaces="no"/>
                <xsl:copy-of select="$inputInfo/gmd:resourceMaintenance" copy-namespaces="no"/>
                <!--          USGIN puts format information in distributionFormat 
         <xsl:copy-of select="$inputInfo/gmd:resourceFormat" copy-namespaces="no"/>  -->

                <xsl:copy-of select="$inputInfo/gmd:descriptiveKeywords" copy-namespaces="no"/>
                <xsl:choose>
                    <xsl:when
                        test="not(//gmd:geographicElement) and not(//gmd:MD_KeywordTypeCode[@codeListValue = 'place'])">
                        <!--<xsl:comment>no geographic extent or place keyword in source metadata, USGIN XSLT inserted 'non-geographic' keyword</xsl:comment> -->
                        <gmd:descriptiveKeywords>
                            <gmd:MD_Keywords>
                                <gmd:keyword>
                                    <gco:CharacterString>non-geographic</gco:CharacterString>
                                </gmd:keyword>
                                <gmd:type>
                                    <gmd:MD_KeywordTypeCode
                                        codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_KeywordTypeCode"
                                        codeListValue="place">place</gmd:MD_KeywordTypeCode>
                                </gmd:type>
                            </gmd:MD_Keywords>
                        </gmd:descriptiveKeywords>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if
                            test="not($inputInfo/gmd:descriptiveKeywords/gmd:MD_Keyword/gmd:keyword/gco:CharacterString)">
                            <!--At least one keyword is required -->
                            <gmd:descriptiveKeywords>
                                <gmd:MD_Keywords>
                                    <gmd:keyword>
                                        <gco:CharacterString>missing</gco:CharacterString>
                                    </gmd:keyword>
                                </gmd:MD_Keywords>
                            </gmd:descriptiveKeywords>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:copy-of select="$inputInfo/gmd:resourceSpecificUsage" copy-namespaces="no"/>
                <xsl:copy-of select="$inputInfo/gmd:resourceConstraints" copy-namespaces="no"/>

                <xsl:apply-templates select="$inputInfo/gmd:aggregationInfo"/>

                <!-- elements from MD_DataIdentification -->
                <xsl:copy-of select="$inputInfo/gmd:spatialRepresentationType" copy-namespaces="no"/>
                <xsl:copy-of select="$inputInfo/gmd:spatialResolution" copy-namespaces="no"/>
                <xsl:copy-of select="$inputInfo/gmd:language" copy-namespaces="no"/>

                <!-- characterSet defaults to UTF-8 if no character set is specified -->
                <xsl:choose>
                    <xsl:when test="$inputInfo/gmd:characterSet">
                        <xsl:copy-of select="$inputInfo/gmd:characterSet" copy-namespaces="no"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <gmd:characterSet>
                            <!-- <xsl:comment>no character set element in source metadata, USGIN XSLT inserted default value</xsl:comment> -->
                            <gmd:MD_CharacterSetCode
                                codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/gmxCodelists.xml#MD_CharacterSetCode "
                                codeListValue="utf8">UTF-8</gmd:MD_CharacterSetCode>
                        </gmd:characterSet>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- multiple topicCategories are allowed -->
                <xsl:choose>
                    <xsl:when test="$inputInfo/gmd:topicCategory/gmd:MD_TopicCategoryCode">
                        <xsl:for-each select="$inputInfo/gmd:topicCategory">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <gmd:topicCategory>
                            <!-- <xsl:comment>no topic category code in source metadata, USGIN XSLT inserted default value</xsl:comment>-->
                            <gmd:MD_TopicCategoryCode>
                                <xsl:value-of select="'geoscientificInformation'"/>
                            </gmd:MD_TopicCategoryCode>
                        </gmd:topicCategory>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:copy-of select="$inputInfo/gmd:environmentDescription" copy-namespaces="no"/>

                <xsl:for-each select="$inputInfo/gmd:extent">
                    <!-- <xsl:copy-of select="." copy-namespaces="no"/>-->

                    <!-- handle bounding box EX_GeographicBoundingBox, EX_BoundingPolygon, EX_GeographicDescription -->
                    <!-- if have EX_GeographicDescription, the code values from the identifier should be copied to
    place keywords  -->
                    <gmd:extent>
                        <gmd:EX_Extent>
                            <xsl:copy-of select="gmd:EX_Extent/gmd:description" copy-namespaces="no"/>


                            <xsl:copy-of
                                select="gmd:EX_Extent/gmd:geographicElement[not(contains(string(gmd:EX_GeographicDescription/@id), 'Vertical'))]"
                                copy-namespaces="no"/>

                            <!--  handle temporal extent EX_TemporalExtent -->
                            <!-- GCMD declares gml3.2, but the temporal elements are not valid in gml3.2; -->
                            <xsl:for-each select="gmd:EX_Extent/gmd:temporalElement">
                                <xsl:copy-of select="." copy-namespaces="no"/>
                            </xsl:for-each>
                            <!-- GCMD metadata puts vertical extent in a geographic element; convert to a verticalElement -->
                            <!-- some records have SURFACE or BOTTOM instead of numeric values, skip those -->
                            <xsl:if
                                test="
                                    not(gmd:EX_Extent/gmd:geographicElement//gmd:geographicIdentifier//gmd:code[contains(string(gco:CharacterString), 'SURFACE')]
                                    or gmd:EX_Extent/gmd:geographicElement//gmd:geographicIdentifier//gmd:code[contains(string(gco:CharacterString), 'BOTTOM')])">
                                <xsl:choose>
                                    <!-- first handle depth. Some records report a depth and an altitude view of the same extent -->
                                    <xsl:when
                                        test="gmd:EX_Extent/gmd:geographicElement//gmd:geographicIdentifier//gmd:code[contains(string(gco:CharacterString), 'Depth')]">
                                        <xsl:variable name="minimumCode">
                                            <xsl:value-of
                                                select="(gmd:EX_Extent/gmd:geographicElement//gmd:geographicIdentifier//gco:CharacterString[contains(text(), 'Minimum Depth')])[1]/text()"
                                            />
                                        </xsl:variable>
                                        <!--GCMD ISO text could be like 'Type: Minimum Depth Value: 0 M' -->
                                        <!-- tricky bit here: translate($minimumCode,$number, '') gets all the characters that aren't part of a number; 
                                potential problem is the non-numeric part of minimuCode contains '.' or '-' characters -->
                                        <xsl:variable name="minimumM">
                                            <xsl:value-of
                                                select="normalize-space(translate(substring-after($minimumCode, string('Value: ')), translate($minimumCode, $number, ''), ''))"
                                            />
                                        </xsl:variable>
                                        <xsl:variable name="maximumCode">
                                            <xsl:value-of
                                                select="(gmd:EX_Extent/gmd:geographicElement//gmd:geographicIdentifier//gco:CharacterString[contains(text(), 'Maximum Depth')])[1]/text()"
                                            />
                                        </xsl:variable>
                                        <!--GCMD ISO text should be like 'Type: Maximum Depth Value: 1000 M' -->
                                        <xsl:variable name="maximumM">
                                            <xsl:value-of
                                                select="normalize-space(translate(substring-after($maximumCode, string('Value: ')), translate($maximumCode, $number, ''), ''))"
                                            />
                                        </xsl:variable>
                                        <gmd:verticalElement>
                                            <gmd:EX_VerticalExtent>
                                                <xsl:choose>
                                                  <xsl:when test="string(number($minimumM)) = 'NaN'">
                                                    <gmd:minimumValue gco:nilReason="missing"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                    <gmd:minimumValue>
                                                        <gco:Real>
                                                            <xsl:value-of select="$minimumM"/>
                                                        </gco:Real>
                                                    </gmd:minimumValue>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:choose>
                                                    <xsl:when test="string(number($maximumM)) = 'NaN'">
                                                        <gmd:maximumValue gco:nilReason="missing"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                <gmd:maximumValue>
                                                  <gco:Real>
                                                  <xsl:value-of select="$maximumM"/>
                                                  </gco:Real>
                                                </gmd:maximumValue>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                <gmd:verticalCRS>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="gmd:EX_Extent/gmd:geographicElement//gmd:code/gco:CharacterString[contains(text(), 'BELOW SEAFLOOR')]">
                                                  <xsl:attribute name="xlink:title">
                                                  <xsl:value-of
                                                  select="string('Depth below seafloor, m')"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="xlink:href">
                                                  <xsl:value-of
                                                  select="string('http://www.opengis.net/def/nil/OGC/0/missing')"
                                                  />
                                                  </xsl:attribute>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="gmd:EX_Extent/gmd:geographicElement//gmd:code/gco:CharacterString[contains(text(), 'WATER DEPTH')]">
                                                  <xsl:attribute name="xlink:title">
                                                  <xsl:value-of select="string('water depth, m')"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="xlink:href">
                                                  <xsl:value-of
                                                  select="string('http://www.spatialreference.org/ref/epsg/5715/')"
                                                  />
                                                  </xsl:attribute>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="gmd:EX_Extent/gmd:geographicElement//gmd:code/gco:CharacterString[contains(text(), 'Depth')]">
                                                  <xsl:attribute name="xlink:title">
                                                  <xsl:value-of
                                                  select="string('Depth below MSL, m')"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="xlink:href">
                                                  <xsl:value-of
                                                  select="string('http://www.spatialreference.org/ref/epsg/5715/')"
                                                  />
                                                  </xsl:attribute>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:attribute name="gco:nilReason">
                                                  <xsl:value-of select="string('missing')"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="xlink:title">
                                                  <xsl:value-of
                                                  select="concat(string($minimumCode), '. ', string($maximumCode))"
                                                  />
                                                  </xsl:attribute>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </gmd:verticalCRS>
                                            </gmd:EX_VerticalExtent>
                                        </gmd:verticalElement>
                                    </xsl:when>
                                    <xsl:when
                                        test="gmd:EX_Extent/gmd:geographicElement//gmd:geographicIdentifier//gmd:code[contains(string(gco:CharacterString), 'Altitude')]">
                                        <xsl:variable name="minimumCode">
                                            <xsl:value-of
                                                select="(gmd:EX_Extent/gmd:geographicElement//gmd:geographicIdentifier//gco:CharacterString[contains(text(), 'Minimum Altitude')])[1]/text()"
                                            />
                                        </xsl:variable>
                                        <!--GCMD ISO text could be like 'Type: Minimum Altitude Value: 0 M' -->
                                        <xsl:variable name="minimumM">
                                            <xsl:value-of
                                                select="normalize-space(translate(substring-after($minimumCode, string('Value: ')), translate($minimumCode, $number, ''), ''))"
                                            />
                                        </xsl:variable>
                                        <xsl:variable name="maximumCode">
                                            <xsl:value-of
                                                select="(gmd:EX_Extent/gmd:geographicElement//gmd:geographicIdentifier//gco:CharacterString[contains(text(), 'Maximum Altitude')])[1]/text()"
                                            />
                                        </xsl:variable>
                                        <!--GCMD ISO text should be like 'Type: Maximum Altitude Value: 1000 M' -->
                                        <xsl:variable name="maximumM">
                                            <xsl:value-of
                                                select="normalize-space(translate(substring-after($maximumCode, string('Value: ')), translate($maximumCode, $number, ''), ''))"
                                            />
                                        </xsl:variable>
                                        <gmd:verticalElement>
                                            <gmd:EX_VerticalExtent>
                                                <xsl:choose>
                                                    <xsl:when test="string(number($minimumM)) = 'NaN'">
                                                        <gmd:minimumValue gco:nilReason="missing"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <gmd:minimumValue>
                                                            <gco:Real>
                                                                <xsl:value-of select="$minimumM"/>
                                                            </gco:Real>
                                                        </gmd:minimumValue>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:choose>
                                                    <xsl:when test="string(number($maximumM)) = 'NaN'">
                                                        <gmd:maximumValue gco:nilReason="missing"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <gmd:maximumValue>
                                                            <gco:Real>
                                                                <xsl:value-of select="$maximumM"/>
                                                            </gco:Real>
                                                        </gmd:maximumValue>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                <gmd:verticalCRS>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="gmd:EX_Extent/gmd:geographicElement//gmd:code/gco:CharacterString[contains(text(), 'Altitude')]">
                                                  <xsl:attribute name="xlink:title">
                                                  <xsl:value-of
                                                  select="string('Elevation above MSL, m')"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="xlink:href">
                                                  <xsl:value-of
                                                  select="string('http://www.spatialreference.org/ref/epsg/5714/')"
                                                  />
                                                  </xsl:attribute>
                                                  </xsl:when>

                                                  <xsl:otherwise>
                                                  <xsl:attribute name="gco:nilReason">
                                                  <xsl:value-of select="string('missing')"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="xlink:title">
                                                  <xsl:value-of
                                                  select="concat(string($minimumCode), '. ', string($maximumCode))"
                                                  />
                                                  </xsl:attribute>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </gmd:verticalCRS>
                                            </gmd:EX_VerticalExtent>
                                        </gmd:verticalElement>

                                    </xsl:when>
                                </xsl:choose>
                            </xsl:if>
                        </gmd:EX_Extent>
                    </gmd:extent>

                    <!-- handle EX_SpatialTemporalExtent -->
                    <!-- handle vertical extent EX_VerticalExtent -->

                </xsl:for-each>

                <!-- GCMD ISO19139 xml schema has added a bogus 'gmd:processingLevel' element, a preview of ISO19115-1 and 19115-2; 
                put the content in supplemental information if a useful value is provided-->

                <xsl:variable name="sipl">
                    <xsl:if
                        test="
                            $inputInfo/gmd:supplementalInformation/gco:CharacterString and
                            string-length($inputInfo/gmd:supplementalInformation/gco:CharacterString) > 0">
                        <xsl:value-of
                            select="
                                concat(string('supplementalInformation: '),
                                normalize-space(string($inputInfo/gmd:supplementalInformation/gco:CharacterString)),
                                string('. '))"
                        />
                    </xsl:if>
                    <xsl:if
                        test="
                            $inputInfo/gmd:processingLevel//gmd:code/gco:CharacterString and
                            not($inputInfo/gmd:processingLevel//gmd:code/gco:CharacterString = 'Not provided')">
                        <xsl:value-of
                            select="
                                concat(string('processingLevel: '),
                                normalize-space(string($inputInfo/gmd:processingLevel//gmd:code/gco:CharacterString)),
                                string('. '))"
                        />
                    </xsl:if>
                    <xsl:if test="$inputInfo/gmd:processingLevel//gmd:authority">
                        <xsl:value-of
                            select="
                                concat(string('processingLevel/identifier/authority: '),
                                normalize-space(string($inputInfo/gmd:processingLevel//gmd:authority)),
                                string('. '))"
                        />
                    </xsl:if>
                </xsl:variable>
                <xsl:if test="string-length($sipl) > 0">
                    <gmd:supplementalInformation>
                        <gco:CharacterString>
                            <xsl:value-of select="normalize-space(string($sipl))"/>
                        </gco:CharacterString>
                    </gmd:supplementalInformation>
                </xsl:if>
            </gmd:MD_DataIdentification>
        </gmd:identificationInfo>
    </xsl:template>
    <!-- end processing MD_DataIdentification -->

    <!-- Distribution -->
    <xsl:template name="usgin:distributionSection">
        <xsl:param name="inputDistro"/>
        <!-- context will be distributionInfo -->
        <gmd:distributionInfo>
            <gmd:MD_Distribution>
                <!-- copy over any distribution Formats -->
                <xsl:copy-of select="$inputDistro/gmd:MD_Distribution/gmd:distributionFormat"
                    copy-namespaces="no"/>
                <!-- if there is a MD_DataIdentification/resourceFormat, put that in here-->
                <xsl:for-each select=".//gmd:MD_DataIdentification/gmd:resourceFormat">
                    <gmd:distributionFormat>
                        <xsl:copy-of select="gmd:MD_Format" copy-namespaces="no"/>
                    </gmd:distributionFormat>
                </xsl:for-each>

                <xsl:for-each select="$inputDistro/gmd:MD_Distribution/gmd:distributor">
                    <!-- verify that there's some useful content here... -->
                    <xsl:if test="gmd:MD_Distributor/gmd:distributionOrderProcess
                        or gmd:MD_Distributor/gmd:distributorFormat
                        or gmd:MD_Distributor/gmd:distributorTransferOptions//gmd:URL
                        or (gmd:MD_Distributor/gmd:distributorContact and not(gmd:MD_Distributor/gmd:distributorContact/@gco:nilReason)) ">
                    <gmd:distributor>
                        <!-- check: may need to check for ID's on distributors used to bind transfer options
                        to distributors if there are multiple distributors and transfer options -->
                        <gmd:MD_Distributor>
                            <xsl:choose>
                                <xsl:when test="not(gmd:MD_Distributor/gmd:distributorContact/@gco:nilReason)">
                            <gmd:distributorContact>
                                <xsl:call-template name="usgin:ResponsibleParty">
                                    <xsl:with-param name="inputParty"
                                        select="gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty"/>
                                    <xsl:with-param name="defaultRole">
                                        <gmd:role>
                                            <gmd:CI_RoleCode
                                                codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                                                codeListValue="distributor"
                                                >distributor</gmd:CI_RoleCode>
                                        </gmd:role>
                                    </xsl:with-param>
                                </xsl:call-template>


                            </gmd:distributorContact>
                                </xsl:when>
                                <xsl:otherwise>
                                    <gmd:distributorContact gco:nilReason="missing"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:copy-of select="gmd:MD_Distributor/gmd:distributionOrderProcess"
                                copy-namespaces="no"/>
                            <xsl:copy-of select="gmd:MD_Distributor/gmd:distributorFormat"
                                copy-namespaces="no"/>
                            <xsl:copy-of select="gmd:MD_Distributor/gmd:distributorTransferOptions"
                                copy-namespaces="no"/>
                        </gmd:MD_Distributor>
                    </gmd:distributor>
                    </xsl:if>
                </xsl:for-each>
                <!-- end of iteration over distributors -->
                <!-- accomodate metadata that has all transfer options in distributorTransferOptions
                 put the first TransferOptions link into MD_Distribtuion/gmd:transferOptions -->
                <xsl:choose>
                    <xsl:when test="$inputDistro/gmd:MD_Distribution/gmd:transferOptions">

                        <xsl:copy-of select="$inputDistro/gmd:MD_Distribution/gmd:transferOptions"
                            copy-namespaces="no"/>
                    </xsl:when>

                    <!-- copy in the first distributor transfer options -->
                    <xsl:when
                        test="$inputDistro/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions">
                        <gmd:transferOptions>
                            <!-- <xsl:comment>USGIN XSLT copies first distributorTransferOption here for clients that expect transferOptions</xsl:comment> -->
                            <xsl:copy-of
                                select="$inputDistro/gmd:MD_Distribution/gmd:distributor[1]/gmd:MD_Distributor/gmd:distributorTransferOptions[1]/gmd:MD_DigitalTransferOptions"
                                copy-namespaces="no"/>
                        </gmd:transferOptions>
                    </xsl:when>
                    <!-- gcmd metadata puts links to resources in CI_ResponsibleParty on aggregateDatasetName/CI_Citation -->
                    <!-- take project home page as first choice-->
                    <xsl:when
                        test=".//gmd:aggregationInfo//gmd:description[contains(gco:CharacterString, string('URL Type: PROJECT HOME PAGE'))]">
                        <xsl:for-each
                            select=".//gmd:aggregationInfo//gmd:description[contains(gco:CharacterString, string('URL Type: PROJECT HOME PAGE'))]/parent::gmd:CI_OnlineResource">
                            <gmd:transferOptions>
                                <gmd:MD_DigitalTransferOptions>
                                    <gmd:onLine>
                                        <gmd:CI_OnlineResource>
                                            <gmd:linkage>
                                                <gmd:URL>
                                                  <xsl:value-of select="gmd:linkage/gmd:URL"/>
                                                </gmd:URL>
                                            </gmd:linkage>
                                            <gmd:protocol>
                                                <gco:CharacterString>http</gco:CharacterString>
                                            </gmd:protocol>
                                            <gmd:description>
                                                <gco:CharacterString>
                                                  <xsl:value-of
                                                  select="normalize-space(gmd:description/gco:CharacterString)"/>
                                                </gco:CharacterString>
                                            </gmd:description>
                                            <gmd:function>
                                                <gmd:CI_OnLineFunctionCode
                                                  codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_OnLineFunctionCode"
                                                  codeListValue="information">PROJECT HOME PAGE</gmd:CI_OnLineFunctionCode>
                                            </gmd:function>
                                        </gmd:CI_OnlineResource>
                                    </gmd:onLine>
                                </gmd:MD_DigitalTransferOptions>
                            </gmd:transferOptions>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- NSF award number second -->
                    <xsl:when
                        test=".//gmd:aggregationInfo//gmd:description[contains(gco:CharacterString, string('Award Abstract'))]">
                        <xsl:for-each
                            select=".//gmd:aggregationInfo//gmd:description[contains(gco:CharacterString, string('Award Abstract'))]/parent::gmd:CI_OnlineResource">
                            <gmd:transferOptions>
                                <gmd:MD_DigitalTransferOptions>
                                    <gmd:onLine>
                                        <gmd:CI_OnlineResource>
                                            <gmd:linkage>
                                                <gmd:URL>
                                                  <xsl:value-of select="gmd:linkage/gmd:URL"/>
                                                </gmd:URL>
                                            </gmd:linkage>
                                            <gmd:protocol>
                                                <gco:CharacterString>http</gco:CharacterString>
                                            </gmd:protocol>
                                            <gmd:description>
                                                <gco:CharacterString>
                                                  <xsl:value-of
                                                  select="normalize-space(gmd:description/gco:CharacterString)"/>
                                                </gco:CharacterString>
                                            </gmd:description>
                                            <gmd:function>
                                                <gmd:CI_OnLineFunctionCode
                                                  codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_OnLineFunctionCode"
                                                  codeListValue="information">NSF Award information</gmd:CI_OnLineFunctionCode>
                                            </gmd:function>
                                        </gmd:CI_OnlineResource>
                                    </gmd:onLine>
                                </gmd:MD_DigitalTransferOptions>
                            </gmd:transferOptions>
                        </xsl:for-each>

                    </xsl:when>
                    <xsl:otherwise>
                        <!-- no transfer options; related pubs and resources are linked via aggregationInfo -->
                    </xsl:otherwise>
                </xsl:choose>
                <!-- accomodate service distributions described in SV_ServiceIdentification sections -->
                <xsl:if test=".//srv:serviceType">
                    <xsl:for-each select=".//gmd:identificationInfo/srv:SV_ServiceIdentification">
                        <!-- each service is in a separate transferOptions section -->
                        <gmd:transferOptions>
                            <gmd:MD_DigitalTransferOptions>
                                <!--  <xsl:comment>USGIN XSLT copies transfer options from SV_ServiceIdentification element in source metadata</xsl:comment> -->
                                <xsl:for-each
                                    select="srv:containsOperations/srv:SV_OperationMetadata">
                                    <!-- each operation gets a separate CI_OnlineResource link -->
                                    <gmd:onLine>
                                        <gmd:CI_OnlineResource>
                                            <gmd:linkage>
                                                <gmd:URL>
                                                  <xsl:value-of
                                                  select="srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"
                                                  />
                                                </gmd:URL>
                                            </gmd:linkage>
                                            <gmd:protocol>
                                                <gco:CharacterString>
                                                  <xsl:value-of
                                                  select="normalize-space(string(ancestor::srv:SV_ServiceIdentification/srv:serviceType))"
                                                  />
                                                </gco:CharacterString>
                                            </gmd:protocol>
                                            <xsl:if test="string-length(string(srv:DCP)) > 0">
                                                <gmd:applicationProfile>
                                                  <gco:CharacterString>
                                                  <xsl:value-of
                                                  select="normalize-space(string(srv:DCP))"/>
                                                  </gco:CharacterString>
                                                </gmd:applicationProfile>
                                            </xsl:if>
                                            <gmd:name>
                                                <gco:CharacterString>
                                                  <xsl:value-of
                                                  select="concat(srv:connectPoint/gmd:CI_OnlineResource/gmd:name/gco:CharacterString, ' ', srv:operationName/gco:CharacterString)"
                                                  />
                                                </gco:CharacterString>
                                            </gmd:name>
                                            <xsl:copy-of
                                                select="srv:connectPoint/gmd:CI_OnlineResource/gmd:description"
                                                copy-namespaces="no"/>
                                            <xsl:copy-of
                                                select="srv:connectPoint/gmd:CI_OnlineResource/gmd:function"/>

                                        </gmd:CI_OnlineResource>
                                    </gmd:onLine>
                                </xsl:for-each>
                            </gmd:MD_DigitalTransferOptions>
                        </gmd:transferOptions>

                    </xsl:for-each>
                </xsl:if>

            </gmd:MD_Distribution>
        </gmd:distributionInfo>
    </xsl:template>
    <!-- end distributionInformation processing -->


    <!-- utility templates -->
    <xsl:template name="usgin:dateFormat">
        <xsl:param name="inputDate" select="."/>
        <!-- input data should be either a gco:Date or a gco:DateTime node -->
        <!-- USGIN mandates use of DateTime, so will need to add 'T12:00:00Z' to gco:Date string -->
        <xsl:choose>
            <xsl:when test="$inputDate/gco:Date">
                <xsl:value-of
                    select="concat(normalize-space(translate(string($inputDate), '/', '-')), 'T12:00:00Z')"
                />
            </xsl:when>
            <xsl:when test="$inputDate/gco:DateTime">
                <xsl:choose>
                    <xsl:when test="count(normalize-space(string($inputDate/gco:DateTime))) = 18">
                        <xsl:value-of select="$inputDate/gco:DateTime"/>
                    </xsl:when>
                    <xsl:when test="count($inputDate/gco:DateTime) = 10">
                        <xsl:value-of select="concat($inputDate/gco:DateTime, 'T12:00:00Z')"/>
                    </xsl:when>
                    <xsl:when test="count($inputDate/gco:DateTime) = 11">
                        <xsl:value-of
                            select="concat(normalize-space(string($inputDate/gco:DateTime)), '00:00Z')"
                        />
                    </xsl:when>
                    <xsl:when test="count($inputDate/gco:DateTime) = 14">
                        <xsl:value-of select="concat($inputDate/gco:DateTime, ':00Z')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="string('1900-01-01T12:00:00Z')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- end of gco:dateTime handler -->
            <xsl:otherwise>
                <xsl:value-of select="string('1900-01-01T12:00:00Z')"/>
            </xsl:otherwise>
        </xsl:choose>
        <!-- end of inputDate handler -->
    </xsl:template>


    <xsl:template match="gmd:keyword"> </xsl:template>

    <xsl:template match="gmd:MD_Identifier">
        <gmd:MD_Identifier>
            <gmd:authority>
                <gmd:CI_Citation>
                    <gmd:title>
                        <!-- this is to insert invalid gmd elements in gcmd metadata into the authority title -->
                        <gco:CharacterString>
                            <xsl:value-of
                                select="normalize-space(string(gmd:codeSpace/gco:CharacterString))"/>
                            <xsl:if
                                test="gmd:codeSpace/gco:CharacterString and (gmd:version or gmd:description)">
                                <xsl:value-of select="string(', ')"/>
                            </xsl:if>
                            <xsl:if test="gmd:version">
                                <xsl:value-of
                                    select="concat(string('version:'), normalize-space(string(gmd:version/gco:CharacterString)))"/>
                                <xsl:if test="gmd:description">
                                    <xsl:value-of select="string(', ')"/>
                                </xsl:if>
                            </xsl:if>
                            <xsl:if test="gmd:description">
                                <xsl:value-of
                                    select="concat(string('description:'), normalize-space(string(gmd:version/gco:CharacterString)))"
                                />
                            </xsl:if>
                        </gco:CharacterString>
                    </gmd:title>
                    <gmd:date/>
                </gmd:CI_Citation>
            </gmd:authority>
            <gmd:code>
                <gco:CharacterString>
                    <xsl:value-of select="normalize-space(string(gmd:code/gco:CharacterString))"/>
                </gco:CharacterString>
            </gmd:code>
        </gmd:MD_Identifier>
    </xsl:template>

    <xsl:template match="gmd:aggregationInfo">
        <xsl:choose>
            <!-- if there's a title string, guess that have a valid aggregationInfo section in which the 
            citation identifies the related resource-->
            <xsl:when
                test="string-length(string(.//gmd:aggregateDataSetName//gmd:title/gco:CharacterString)) > 0">
                <!--                <xsl:copy-of select="." copy-namespaces="no"/>-->
                <!-- MD_Identifier is bogus in these, so can't copy -->
                <gmd:aggregationInfo>
                    <gmd:MD_AggregateInformation>
                        <gmd:aggregateDataSetName>
                            <gmd:CI_Citation>
                                <xsl:copy-of select=".//gmd:CI_Citation/gmd:title"
                                    copy-namespaces="no"/>
                                <xsl:copy-of select=".//gmd:CI_Citation/gmd:date"
                                    copy-namespaces="no"/>
                                <gmd:identifier>
                                    <xsl:apply-templates select=".//gmd:identifier"/>
                                </gmd:identifier>
                                <xsl:copy-of select=".//gmd:citedResponsibleParty"
                                    copy-namespaces="no"/>
                            </gmd:CI_Citation>
                        </gmd:aggregateDataSetName>
                        <gmd:associationType>
                            <xsl:choose>
                                <xsl:when
                                    test=".//gmd:associationType/gmd:DS_AssociationTypeCode/@codeListValue">
                                    <xsl:copy-of
                                        select=".//gmd:associationType/gmd:DS_AssociationTypeCode"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <gmd:DS_AssociationTypeCode
                                        codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_AssociationTypeCode"
                                        codeListValue="crossReference">
                                        <xsl:value-of
                                            select="
                                                string('cross reference')"
                                        />
                                    </gmd:DS_AssociationTypeCode>
                                </xsl:otherwise>
                            </xsl:choose>
                        </gmd:associationType>
                    </gmd:MD_AggregateInformation>
                </gmd:aggregationInfo>
            </xsl:when>
            <xsl:otherwise>
                <!-- guess that the related resource is shoe-horned into the Citation/CI_ResponsibleParty//CI_OnlineResource -->
                <gmd:aggregationInfo>
                    <gmd:MD_AggregateInformation>
                        <gmd:aggregateDataSetName>
                            <gmd:CI_Citation>
                                <gmd:title>
                                    <gco:CharacterString>
                                        <xsl:choose>
                                            <xsl:when
                                                test="contains(.//gmd:aggregateDataSetName//gmd:description/gco:CharacterString, string('                  &#10;'))">
                                                <xsl:value-of
                                                  select="
                                                        normalize-space(substring-before(substring-after(.//gmd:aggregateDataSetName//gmd:description/gco:CharacterString, string('                  &#10;')),
                                                        string('URLContentType:')))"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                  select="
                                                        normalize-space(substring-before(
                                                        substring-after(.//gmd:aggregateDataSetName//gmd:description/gco:CharacterString, string('Description:')),
                                                        string('URLContentType:')))"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </gco:CharacterString>
                                </gmd:title>
                                <gmd:alternateTitle>
                                    <gco:CharacterString>
                                        <xsl:value-of
                                            select="
                                                normalize-space(substring-before(substring-after(.//gmd:aggregateDataSetName//gmd:description/gco:CharacterString, string('URLContentType:')),
                                                string('URL Type:')))"
                                        />
                                    </gco:CharacterString>
                                </gmd:alternateTitle>

                                <xsl:choose>
                                    <xsl:when
                                        test=".//gmd:aggregateDataSetName/gmd:CI_Citation//gmd:date">
                                        <xsl:copy-of
                                            select=".//gmd:aggregateDataSetName/gmd:CI_Citation//gmd:date"
                                            copy-namespaces="no"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <gmd:date gco:nilReason="missing"/>
                                    </xsl:otherwise>
                                </xsl:choose>

                                <xsl:choose>
                                    <xsl:when
                                        test="contains(.//gmd:aggregateDataSetName//gmd:description/gco:CharacterString, string('doi:'))">
                                        <gmd:identifier>
                                            <gmd:MD_Identifier>
                                                <gmd:code>
                                                  <gco:CharacterString> doi:<xsl:value-of
                                                  select="
                                                                substring-before(substring-after(.//gmd:aggregateDataSetName//gmd:description/gco:CharacterString, string('doi:')),
                                                                string('. URLContentType:'))"
                                                  />
                                                  </gco:CharacterString>
                                                </gmd:code>
                                            </gmd:MD_Identifier>
                                        </gmd:identifier>
                                    </xsl:when>
                                    <xsl:when
                                        test="contains(lower-case(.//gmd:aggregateDataSetName//gmd:identifier//gmd:description/gco:CharacterString), string('doi'))">
                                        <gmd:identifier>
                                            <gmd:MD_Identifier>
                                                <gmd:code>
                                                  <gco:CharacterString> doi:<xsl:value-of
                                                  select=".//gmd:aggregateDataSetName//gmd:identifier//gmd:code/gco:CharacterString"
                                                  />
                                                  </gco:CharacterString>
                                                </gmd:code>
                                            </gmd:MD_Identifier>
                                        </gmd:identifier>
                                    </xsl:when>

                                    <xsl:otherwise>
                                        <gmd:identifier>
                                            <gmd:MD_Identifier>
                                                <gmd:code>
                                                  <gco:CharacterString>
                                                  <xsl:value-of
                                                  select=".//gmd:aggregateDataSetName//gmd:linkage/gmd:URL"
                                                  />
                                                  </gco:CharacterString>
                                                </gmd:code>
                                            </gmd:MD_Identifier>
                                        </gmd:identifier>
                                    </xsl:otherwise>
                                </xsl:choose>

                                <xsl:copy-of
                                    select=".//gmd:aggregateDataSetName//gmd:citedResponsibleParty"
                                    copy-namespaces="no"/>
                                <gmd:otherCitationDetails>
                                    <gco:CharacterString>
                                        <xsl:value-of
                                            select="string('responsible party element copied from  GCMD ISO encoding for compatibility with applications expecting link information there.  ')"/>
                                        <xsl:if
                                            test="contains(.//gmd:aggregateDataSetName//gmd:description/gco:CharacterString, string('                  &#10;'))">
                                            <xsl:value-of
                                                select="
                                                    normalize-space(substring-before(.//gmd:aggregateDataSetName//gmd:description/gco:CharacterString,
                                                    string('                  &#10;')))"
                                            />
                                        </xsl:if>
                                    </gco:CharacterString>
                                </gmd:otherCitationDetails>
                            </gmd:CI_Citation>
                        </gmd:aggregateDataSetName>
                        <gmd:associationType>
                            <gmd:DS_AssociationTypeCode
                                codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_AssociationTypeCode"
                                codeListValue="crossReference">
                                <xsl:value-of
                                    select="
                                        normalize-space(substring-after(.//gmd:aggregateDataSetName//gmd:description/gco:CharacterString,
                                        string('URL Type:')))"
                                />
                            </gmd:DS_AssociationTypeCode>
                        </gmd:associationType>
                    </gmd:MD_AggregateInformation>
                </gmd:aggregationInfo>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
