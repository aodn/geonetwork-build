<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                version="2.0">
    
    <!-- Geoserver -->
    <!-- ISO 19115 -->
    <xsl:template match="/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:transferOptions/mrd:MD_DigitalTransferOptions/mrd:onLine/cit:CI_OnlineResource/cit:linkage/gco:CharacterString[matches(text(), '//geoserver(.*?)\.aodn\.org\.au/')]">
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

</xsl:stylesheet>
