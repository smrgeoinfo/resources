<?xml version="1.0"?>
<!--
    Document   : datadoi.xsl
    Created on : February 18, 2015, 11:49 AM
    Author     : vickiferrini
    Description: NEW IEDA Data DOI landing page.
-->

<xsl:stylesheet  xmlns:k3="http://datacite.org/schema/kernel-3" 
                 xmlns:k2="http://datacite.org/schema/kernel-2.2" 
                 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html"/>
<xsl:template match="/">

   
   <html>
    <head>
        <title>IEDA Data DOI</title>
        <!--          <link rel="stylesheet" href="/doi/datadoi.css"/>-->
        <link rel="stylesheet" href="http://get.iedadata.org/doi/datadoi.css"/>
        <link rel="stylesheet" href="http://www.marine-geo.org/css/mapv3.css"/>	
        <link rel="stylesheet" type="text/css" href="http://www.marine-geo.org/inc/jquery-ui-1.10.2.custom/css/smoothness/jquery-ui-1.10.2.custom.min.css" media="all" />
        <script src="http://maps.googleapis.com/maps/api/js?key=AIzaSyATYahozDIlFIM1mO7o66AocXi72mkPT18&amp;sensor=false&amp;libraries=drawing" type="text/javascript"></script>
        <script type="text/javascript" src="http://www.marine-geo.org/inc/jquery-1.9.1.js"></script>
        <script type="text/javascript" src="http://www.marine-geo.org/inc/jquery-ui-1.10.2.custom.min.js"></script>	
        <script type="text/javascript" src="http://www.marine-geo.org/inc/basemap_v3.js"></script>
        <!-- <script type="text/javascript" src="/doi/doimap.js"/>-->
        <script type="text/javascript" src="http://get.iedadata.org/doi/doimap.js"/>
    </head>
    
<xsl:element name="body">  
    <xsl:choose>
    <xsl:when test="/k3:resource/k3:alternateIdentifiers/k3:alternateIdentifier[@alternateIdentifierType='CSDMS']|/k2:resource/k2:alternateIdentifiers/k2:alternateIdentifier[@alternateIdentifierType='CSDMS']">
        <xsl:attribute name="onload">
            <xsl:text>window.location.href='</xsl:text>
            <xsl:text>http://csdms.colorado.edu/wiki/Model:</xsl:text>
            <xsl:value-of select="/k3:resource/k3:alternateIdentifiers/k3:alternateIdentifier|/k2:resource/k2:alternateIdentifiers/k2:alternateIdentifier" />  
            <xsl:text>'</xsl:text>
        </xsl:attribute>    
    </xsl:when>
    <xsl:otherwise>
     <div id="container">
            <div><a href="http://www.iedadata.org"><img onclick='http://www.iedadata.org' src='http://www.iedadata.org/sites/www.iedadata.org/files/arthemia_logo.jpg' alt='IEDA'/></a></div>
            <h1> 
                <xsl:text>Data DOI: </xsl:text> 
                <xsl:value-of select="/k3:resource/k3:identifier|/k2:resource/k2:identifier" />
            </h1>
            <div id="right-side">      
                <xsl:apply-templates select="/k3:resource/k3:geoLocations[k3:geoLocation]" />
            </div>
            <div>
                <div class="row" >
                    <div class="title"><xsl:text>Citation</xsl:text></div>
                    <div class="description">
                        <xsl:value-of select="/k3:resource/k3:creators/k3:creator/k3:creatorName[1]|/k2:resource/k2:creators/k2:creator/k2:creatorName[1]"/>                                             
                        <xsl:variable name="count" select="count(k3:resource/k3:creators/k3:creator/k3:creatorName)" />                        
                        <xsl:if test="count(k3:resource/k3:creators/k3:creator/k3:creatorName) > 1">
                             <xsl:text>, et al., </xsl:text>
                            </xsl:if>
                            <xsl:if test="count(k2:resource/k2:creators/k2:creator/k2:creatorName) > 1">
                             <xsl:text>, et al., </xsl:text>
                        </xsl:if>
                        <xsl:text> (</xsl:text> 
                        <xsl:value-of select="/k3:resource/k3:publicationYear|/k2:resource/k2:publicationYear"/>
                        <!--<xsl:value-of select="substring(/k3:resource/k3:dates/k3:date[@dateType='Created'],1,4)"/> -->
                        <xsl:text>), </xsl:text> 
                        <xsl:value-of disable-output-escaping="yes"  select="/k3:resource/k3:titles/k3:title|/k2:resource/k2:titles/k2:title"/><xsl:text>. </xsl:text> 
                         <xsl:value-of select="/k3:resource/k3:publisher|/k2:resource/k2:publisher"/>
                        <xsl:text>. doi:</xsl:text> 
                        <xsl:value-of select="/k3:resource/k3:identifier|/k2:resource/k2:identifier"/>
                    </div>
                </div>
                <div class="row">
                    <div class="title">Title:</div>
                    <div class="description">
                         <xsl:apply-templates select="/k3:resource/k3:titles/k3:title|/k2:resource/k2:titles/k2:title" />
                    </div>
                </div>
                
                <xsl:if test="/k3:resource/k3:descriptions/k3:description[@descriptionType='Abstract']"> 
                    <div class="row">
                        <div class="title">
                            <xsl:text>Abstract:</xsl:text>
                        </div>
                        <div class="description">
                            <xsl:apply-templates select="/k3:resource/k3:descriptions/k3:description[@descriptionType='Abstract']" />
                        </div>
                    </div>
                </xsl:if>
                <div class="row">
                    <div class="title"><xsl:text>Creator(s):</xsl:text></div>
                    <div class="description">
                       <xsl:apply-templates select="/k3:resource/k3:creators/k3:creator|k2:resource/k2:creators/k2:creator" />
                    </div>
                </div>
                <div class="row">
                        <xsl:apply-templates select="/k2:resource/k2:dates/k2:date|/k3:resource/k3:dates/k3:date" />
                </div>
                <div class="row">
                    <div class="title"><xsl:text>Data Type(s):</xsl:text></div>
                    <div class="description">
                       <xsl:apply-templates select="/k3:resource/k3:subjects/k3:subject|/k2:resource/k2:subjects/k2:subject" />
                    </div>
                </div>
                <xsl:if test="/k3:resource/k3:resourceType|/k2:resource/k2:resourceType">
                    <div class="row">
                        <div class="title"><xsl:text>Resource Type:</xsl:text></div>
                        <div class="description"> 
                            <xsl:apply-templates select="/k3:resource/k3:resourceType|/k2:resource/k2:resourceType" />
                        </div>
                    </div>
                </xsl:if> 
                <div class="row">
                    <div class="title"><xsl:text>File Format(s):</xsl:text></div>
                    <div class="description"> 
                        <xsl:apply-templates select="/k3:resource/k3:formats/k3:format|/k2:resource/k2:formats/k2:format">
                            <xsl:sort select="format" order="ascending" />
                        </xsl:apply-templates>
                    </div>
                </div>

                <div class="row" style="min-height:36px;">
                    <div class="title"><xsl:text>Data Curated by:</xsl:text></div>    
                    <xsl:apply-templates select="/k3:resource/k3:alternateIdentifiers/k3:alternateIdentifier[@alternateIdentifierType]|/k2:resource/k2:alternateIdentifiers/k2:alternateIdentifier[@alternateIdentifierType]" />
                    <div style="clear:both"></div>
                </div>
               
                <div class="row">
                    <div class="title"><xsl:text>Version:</xsl:text></div>
                    <div class="description">
                       <xsl:apply-templates select="/k3:resource/k3:version|/k2:resource/k2:version" />
                    </div>
                </div>                
                <div class="row">
                    <div class="title"><xsl:text>Language:</xsl:text></div>
                    <div class="description">
                       <xsl:apply-templates select="/k3:resource/k3:language|/k2:resource/k2:language" />
                    </div>
                </div>
                <div class="row">
                <div class="title"><xsl:text>License:</xsl:text></div>
                <div class="description">
                   <xsl:apply-templates select="/k3:resource/k3:rightsList/k3:rights|/k2:resource/k2:rights" />
                </div>
            </div>   
            </div>
            <div style="clear:both"></div>
            <xsl:if test="/k3:resource/k3:relatedIdentifiers/k3:relatedIdentifier|/k2:resource/k2:relatedIdentifiers/k2:relatedIdentifier"> 
                <h1>
                    <xsl:text>Related Information</xsl:text>
                </h1>
                <xsl:apply-templates select="/k3:resource/k3:relatedIdentifiers/k3:relatedIdentifier|/k2:resource/k2:relatedIdentifiers/k2:relatedIdentifier" />
            </xsl:if>
        </div>
    </xsl:otherwise>
   </xsl:choose>     
   </xsl:element> 
</html>
</xsl:template>

 
    <xsl:template match="/k3:resource/k3:dates/k3:date|/k2:resource/k2:dates/k2:date">
        <div class="title">
            <xsl:text>Date </xsl:text>
            <xsl:value-of select="./@dateType"/>
            <xsl:text>:</xsl:text>
        </div>    
        <div class="description">
            <xsl:value-of select="."/>
        </div>
    </xsl:template> 
    
    
    <xsl:template match="/k3:resource/k3:relatedIdentifiers/k3:relatedIdentifier|/k2:resource/k2:relatedIdentifiers/k2:relatedIdentifier">
      <div class="row">
        <div class="title">
            <xsl:value-of select="./@relationType"/>
            <xsl:text>:</xsl:text>
        </div>
      <xsl:choose> 
           <xsl:when test="@relatedIdentifierType='URL'"> 
             <div class="description">
                url: <a href="{.}" >
                    <xsl:value-of select="."/>
                </a>
              </div>
            </xsl:when>
            <xsl:when test="@relatedIdentifierType='DOI'"> 
             <div class="description">
                doi: <a href="http://dx.doi.org/{.}" >
                    <xsl:value-of select="."/>
                </a>
              </div>
            </xsl:when>
            <xsl:when test="@relatedIdentifierType='ISBN'"> 
             <div class="description">
                isbn: <a href="http://www.worldcat.org/search?qt=wikipedia&amp;q=isbn%3A{.}" >
                    <xsl:value-of select="."/>
                </a>
              </div>
            </xsl:when>
      </xsl:choose>
      </div>
    </xsl:template>     
  
      
     <xsl:template match="/k3:resource/k3:alternateIdentifiers/k3:alternateIdentifier|/k2:resource/k2:alternateIdentifiers/k2:alternateIdentifier">
           <xsl:choose> 
                <xsl:when test="@alternateIdentifierType='MGDS'">                  
                   <div class="description">
                       <a href="http://www.marine-geo.org"><xsl:text>Marine Geoscience Data System (MGDS)</xsl:text> </a>
                   </div>
                    <button type="button" class="btn" 
                       onclick="window.location='http://www.marine-geo.org/tools/files/{.}'">
                       Download Data
                   </button>
                </xsl:when>
                <xsl:when test="@alternateIdentifierType='URL'">                  
                    <div class="description">
                        <a href="http://www.earthchem.org/library"><xsl:text>EarthChem Library (ECL) </xsl:text> </a>
                    </div>
                    <button type="button" class="btn" 
                       onclick="window.location='{.}'">
                       Download Data
                   </button>
 
                </xsl:when> 

                <xsl:when test="@alternateIdentifierType='UTIG'">                  
                   <div class="description">
                       <a href="http://www-udc.ig.utexas.edu/sdc/"><xsl:text>Academic Seismic Portal @ UTIG </xsl:text></a>
                   </div>
                   <button type="button" class="btn" 
                       onclick="window.location='http://www-udc.ig.utexas.edu/sdc/DOI/datasetDOI.php?datasetuID={.}'">
                       Download Data
                   </button>
                   
                </xsl:when>  
           </xsl:choose>
    </xsl:template>   

   
    <xsl:template match="/k3:resource/k3:creators/k3:creator|k2:resource/k2:creators/k2:creator">
       <div><xsl:value-of select="k3:creatorName|k2:creatorName"/></div>
    </xsl:template>
    <xsl:template match="/k3:resource/k3:subjects/k3:subject|/k3:resource/k3:titles/k3:title|/k3:resource/k3:descriptions/k3:description|/k3:resource/k3:formats/k3:format|/k3:resource/k3:version|/k3:resource/k3:rightsList/k3:rights|/k2:resource/k2:subjects/k2:subject|/k2:resource/k2:titles/k2:title|/k2:resource/k2:descriptions/k2:description|/k2:resource/k2:formats/k2:format|/k2:resource/k2:version|/k2:resource/k2:rights">
        <div><xsl:value-of disable-output-escaping="yes"  select="."/></div>
    </xsl:template> 
    <xsl:template match="k3:resource/k3:resourceType|k2:resource/k2:resourceType">
        <div><xsl:value-of select="@resourceTypeGeneral"/></div>
    </xsl:template>
    
    <xsl:template match="/k3:resource/k3:geoLocations">
        <form id="geoLocations">
            <xsl:apply-templates select="k3:geoLocation" />
        </form>
        <div id="mapc"></div>
    </xsl:template>
    
    <xsl:template match="k3:geoLocation">
        <xsl:choose>
            <xsl:when test="./k3:geoLocationPoint">
                <xsl:element name="input">
                    <xsl:attribute name="class">
                        <xsl:text>geoLocationPoint</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:text>hidden</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:value-of select="./k3:geoLocationPoint" />
                    </xsl:attribute>
                </xsl:element>
            </xsl:when>
            <xsl:when test="./k3:geoLocationBox">
                <xsl:element name="input">
                    <xsl:attribute name="class">
                        <xsl:text>geoLocationBox</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:text>hidden</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:value-of select="./k3:geoLocationBox" />
                    </xsl:attribute>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template> 
</xsl:stylesheet>
