<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
    version="2.0">

    <!-- 19139 records -->

    <xsl:template match="gmd:URL[normalize-space($pattern) != '' and matches(text(), $pattern)]">
        <xsl:copy>
            <xsl:value-of select="replace(text(), $pattern, $replacement)"/>
        </xsl:copy>
    </xsl:template>

    <!-- 19115-3 records -->

    <xsl:template match="cit:linkage/*[normalize-space($pattern) != '' and matches(text(), $pattern)]">
        <xsl:copy>
            <xsl:value-of select="replace(text(), $pattern, $replacement)"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
