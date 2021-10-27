<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0">

    <xsl:variable name="data-dir">
        <xsl:choose>
            <xsl:when test="system-property('geonetwork.dir')">
                <xsl:value-of select="system-property('geonetwork.dir')" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="resolve-uri('../../../WEB-INF/data')" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

</xsl:stylesheet>