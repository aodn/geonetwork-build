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

     <xsl:variable name="config" select="document('/home/cmrose/git/geonetwork-build/main/src/main/webapp/WEB-INF/data/config/url-substitutions/linkage-updater.xml')"/>
<!--    <xsl:variable name="config" select="document('../../../../WEB-INF/data/config/url-substitutions/linkage-updater.xml')"/>-->
    
    <xsl:variable name="pot" select="$config/config/pot/@replaceWith" />
    <xsl:variable name="thredds" select="$config/config/thredds/@replaceWith" />
    <xsl:variable name="geowebcache" select="$config/config/geowebcache/@replaceWith" />
    <xsl:variable name="geoserver" select="$config/config/geoserver/@replaceWith" />
    <xsl:variable name="processes" select="$config/config/processes/@replaceWith" />
    <xsl:variable name="geoserver_wfs" select="$config/config/geoserver_wfs/@replaceWith" />

    <!-- default action is to copy -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Always remove geonet:* elements. -->
    <xsl:template match="geonet:*"/>

<!--    TODO: variants of this file should import the following common xsl-->

    <!--  Point of truth -->
    <!-- ISO 19115 -->
    <xsl:template match="mdb:metadataLinkage/cit:CI_OnlineResource/cit:linkage/gco:CharacterString">
        <xsl:copy>
            <xsl:value-of select="if (not($pot = '')) then replace(text(), '//(.+?)/', concat('//',string($pot),'/')) else text()"/>
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
    <!-- TODO: MCP ISO 19139 -->
   

    <!-- GeoWebcache -->
    <!-- ISO 19115 -->
    <xsl:template match="cit:CI_OnlineResource/cit:linkage/gco:CharacterString[../../cit:protocol/*/text()='OGC:WMS-1.1.1-http-get-map']">
        <xsl:choose>
            <xsl:when test="not($geowebcache = '')">
                <xsl:copy><xsl:value-of select="replace(., concat('//geoserver(.*?)\.aodn\.org\.au/','geoserver'), concat('//',string($geowebcache), '/geowebcache/service'))"/></xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="text()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- TODO: MCP ISO 19139 -->

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
    <xsl:template match="cit:CI_OnlineResource[child::cit:protocol[gco:CharacterString[text()='OGC:WFS-1.0.0-http-get-capabilities']]]">
        <xsl:choose>
            <xsl:when test="not($geoserver_wfs = '')">
                <xsl:variable name="collection_name" select="cit:name/gco:CharacterString/text()"/>
                <cit:CI_OnlineResource>
                    <cit:linkage>
                        <gco:CharacterString>
                            <xsl:value-of select="concat(string($geoserver_wfs), '/geoserver/ows')"/>
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
                <xsl:value-of select="text()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- TODO: MCP ISO 19139 (See the original /home/cmrose/git/cloud-deploy/sample-config/ebprep_conf/templates/geonetwork3/linkage-updater.xsl.template) -->
    <!-- need a sample file for this -->
    <xsl:template match="gmd:CI_OnlineResource[child::gmd:protocol[gco:CharacterString[text()='OGC:WFS-1.0.0-http-get-capabilities']]]">

        <xsl:variable name="collection_name"
                      select="gmd:name/gco:CharacterString/text()"/>
        <gmd:onLine>
            <gmd:CI_OnlineResource>
                <gmd:linkage>
                    <xsl:value-of select="concat(string($geoserver_wfs), '/geoserver/ows')"/>
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
    </xsl:template>
</xsl:stylesheet>
