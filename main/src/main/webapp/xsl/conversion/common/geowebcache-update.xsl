<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                version="2.0">

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

</xsl:stylesheet>
