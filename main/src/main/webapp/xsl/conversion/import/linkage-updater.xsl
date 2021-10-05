<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:geonet="http://www.fao.org/geonetwork"
                version="2.0"
                exclude-result-prefixes="#all">
    
    <!-- Use this for CSW harvesters -->
    <!--
        References:
        portal-linkage-updater
          https://github.com/aodn/core-geonetwork/blob/93bbd3b85f33522327ee9e64a2ec0ff9ea1a4ef5/web/src/main/webapp/WEB-INF/data/config/schema_plugins/iso19139/process/portal-linkage-updater.xsl
          portal-linkage-updater?pot_url=https://metadata.imas.utas.edu.au/geonetwork/srv/eng/catalog.search#/metadata/${uuid}
        linkage-updater
          https://github.com/aodn/cloud-deploy/blob/1d2d700e41f40b5002ed7e619ca16bc2bde3b9ff/sample-config/ebprep_conf/templates/geonetwork3/linkage-updater.xsl.template
          linkage-updater?pattern=http://geoserver-123.aodn.org.au&replacement=http://geoserver-portal.aodn.org.au&pot_url=https://apps.aims.gov.au/metadata/view/${uuid}
    -->

    <xsl:variable name="config" select="document('../../../WEB-INF/data/config/url-substitutions/linkage-updater.xml')"/>
    
    <xsl:variable name="pot_replace" select="$config/config/pot/@replaceWith" />
    <xsl:variable name="pot_add" select="$config/config/pot/@add" />
    <xsl:variable name="thredds" select="$config/config/thredds/@replaceWith" />
    <xsl:variable name="geowebcache" select="$config/config/geowebcache/@replaceWith" />
    <xsl:variable name="geoserver" select="$config/config/geoserver/@replaceWith" />
    <xsl:variable name="processes" select="$config/config/processes/@replaceWith" />
    <xsl:variable name="geoserver_wfs" select="$config/config/geoserver_wfs/@pattern" />
    
    <xsl:variable name="metadata_uuid" select="//gmd:fileIdentifier/*/text()" />
    <xsl:variable name="pot_add_url" select="replace($pot_add, '\$\{uuid\}', $metadata_uuid)" />

    <!-- default action is to copy -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Always remove geonet:* elements. -->
    <xsl:template match="geonet:*"/>

    <!--  Point of truth -->
    <!-- ISO 19115 -->
    <!-- Replace existing POT -->
    <xsl:template match="mdb:metadataLinkage/cit:CI_OnlineResource/cit:linkage/gco:CharacterString">
        <xsl:copy>
            <xsl:value-of select="if (not($pot_replace = '')) then replace(text(), '//(.+?)/', concat('//',string($pot_replace),'/')) else text()"/>
        </xsl:copy>
    </xsl:template>
    <!-- Add POT if none exists -->
    <!-- Add point of truth online resource element to the first transferOptions element in the MD_Distribution section 
        if pot_url provided and it doesn't exist already -->
    <xsl:variable name="has-pot" select="//gmd:MD_Distribution//gmd:protocol/*/text()[.='WWW:LINK-1.0-http--metadata-URL']"/>
    <xsl:variable name="add-pot" select="$pot_add_url and not($has-pot)"/>
    <xsl:template match="gmd:MD_Distribution[$add-pot]/gmd:transferOptions[1]/gmd:MD_DigitalTransferOptions[1]">
        <xsl:copy>
            <xsl:apply-templates select="node()"/>
            <gmd:onLine>
                <gmd:CI_OnlineResource>
                    <gmd:linkage>
                        <gmd:URL><xsl:value-of select="string($pot_add_url)"/></gmd:URL>
                    </gmd:linkage>
                    <gmd:protocol>
                        <gco:CharacterString>WWW:LINK-1.0-http--metadata-URL</gco:CharacterString>
                    </gmd:protocol>
                    <gmd:description>
                        <gco:CharacterString>Point of truth URL of this metadata record</gco:CharacterString>
                    </gmd:description>
                </gmd:CI_OnlineResource>
            </gmd:onLine>
        </xsl:copy>
    </xsl:template>    
    

    <!-- Thredds -->
    <!-- ISO 19115 -->
    <xsl:template match="/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:transferOptions/mrd:MD_DigitalTransferOptions/mrd:onLine/cit:CI_OnlineResource/cit:linkage/gco:CharacterString[matches(text(), '//thredds(.*?)\.aodn\.org\.au/')]">
        <xsl:choose>
            <xsl:when test="not($thredds = '')">
                <xsl:value-of select="replace(text(), '//thredds(.*?)\.aodn\.org\.au/', concat('//',string($thredds),'/'))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="text()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Geoserver -->
    <!-- ISO 19115 -->
    <xsl:template match="/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:transferOptions/mrd:MD_DigitalTransferOptions/mrd:onLine/cit:CI_OnlineResource/cit:linkage/gco:CharacterString[matches(text(), '//geoserver(.*?)\.aodn\.org\.au/')]">
        <xsl:choose>
            <xsl:when test="not($geoserver = '')">
                <xsl:value-of select="replace(text(), '//geoserver(.*?)\.aodn\.org\.au/', concat('//',string($geoserver),'/'))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="text()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ISO 19139 -->
    <xsl:template match="gmd:URL[matches(text(), '//geoserver(.*?)\.aodn\.org\.au/')]">
        <xsl:choose>
            <xsl:when test="not($geoserver = '')">        
                <xsl:copy>
                    <xsl:value-of select="replace(text(), '//geoserver(.*?)\.aodn\.org\.au/', concat('//',string($geoserver),'/'))"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:value-of select="text()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>            
    </xsl:template>    
   

    <!-- GeoWebcache -->
    <!-- ISO 19115 -->
    <xsl:template match="cit:CI_OnlineResource/cit:linkage/gco:CharacterString[../../cit:protocol/*/text()='OGC:WMS-1.1.1-http-get-map']">
        <xsl:choose>
            <xsl:when test="not($geowebcache = '')">
                <xsl:copy><xsl:value-of select="replace(., concat('//geoserver(.*?)\.aodn\.org\.au/','geoserver'), concat('//',string($geowebcache), '/geowebcache/service'))"/></xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy><xsl:value-of select="text()"/></xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ISO 19139 -->
    <xsl:template match="gmd:URL[../../gmd:protocol/*/text()='OGC:WMS-1.1.1-http-get-map']">
        <xsl:choose>
            <xsl:when test="not($geowebcache = '')">
                <xsl:copy>
                    <xsl:value-of select="replace(., concat('//geoserver(.*?)\.aodn\.org\.au/','geoserver'), concat('//',string($geowebcache), '/geowebcache/service'))"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:value-of select="text()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>                
    </xsl:template>    

    <!-- Processes -->
    <!-- ISO 19115 -->
    <xsl:template match="/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:transferOptions/mrd:MD_DigitalTransferOptions/mrd:onLine/cit:CI_OnlineResource/cit:linkage/gco:CharacterString[matches(text(), '//processes(.*?)\.aodn\.org\.au/')]">
        <xsl:choose>
            <xsl:when test="not($processes = '')">
                <xsl:value-of select="replace(text(), '//processes(.*?)\.aodn\.org\.au/', concat('//',string($processes),'/'))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="text()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Geoserver WFS -->
    <!-- ISO 19115 -->
    <xsl:template match="cit:CI_OnlineResource[cit:protocol/gco:CharacterString/text()='OGC:WFS-1.0.0-http-get-capabilities' and contains(cit:linkage/cit:URL/text(), $geoserver_wfs)]">
        <xsl:choose>
            <xsl:when test="not($geoserver_wfs = '')">
                <xsl:variable name="collection_name" select="cit:name/gco:CharacterString/text()"/>
                <cit:CI_OnlineResource>
                    <cit:linkage>
                        <gco:CharacterString>
                            <xsl:value-of select="concat('http://', string($geoserver_wfs), '/geoserver/ows')"/>
                        </gco:CharacterString>
                    </cit:linkage>
                    <cit:protocol>
                        <gco:CharacterString>
                            <xsl:value-of select="'AODN:WFS-EXTERNAL-1.0.0-http-get-capabilities'"/>
                        </gco:CharacterString>
                    </cit:protocol>
                    <cit:name>
                        <gco:CharacterString>
                            <xsl:value-of select="$collection_name"/>
                        </gco:CharacterString>
                    </cit:name>
                    <cit:description>
                        <gco:CharacterString>This OGC WFS service returns filtered geographic information. The returned data 
                            is available in multiple formats including CSV.
                        </gco:CharacterString>
                    </cit:description>
                </cit:CI_OnlineResource>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ISO 19139 -->
    <xsl:template match="gmd:onLine[gmd:CI_OnlineResource[contains(gmd:linkage/gmd:URL/text(), $geoserver_wfs)]/gmd:protocol/*/text() = 'OGC:WFS-1.0.0-http-get-capabilities']">
        <xsl:choose>
            <xsl:when test="not($geoserver_wfs = '')">
                <xsl:variable name="collection_name" select="gmd:name/gco:CharacterString/text()"/>
                <gmd:onLine>
                    <gmd:CI_OnlineResource>
                        <gmd:linkage>
                            <xsl:value-of select="concat('http://', string($geoserver_wfs), '/geoserver/ows')"/>
                        </gmd:linkage>
                        <gmd:protocol>
                            <gco:CharacterString>
                                <xsl:value-of select="'AODN:WFS-EXTERNAL-1.0.0-http-get-capabilities'"/>
                            </gco:CharacterString>
                        </gmd:protocol>
                        <gmd:name>
                            <gco:CharacterString>
                                <xsl:value-of select="$collection_name"/>
                            </gco:CharacterString>
                        </gmd:name>
                        <gmd:description>
                            <gco:CharacterString>This OGC WFS service returns filtered geographic information. The returned data
                                is available in multiple formats including CSV.
                            </gco:CharacterString>
                        </gmd:description>
                    </gmd:CI_OnlineResource>
                </gmd:onLine>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
