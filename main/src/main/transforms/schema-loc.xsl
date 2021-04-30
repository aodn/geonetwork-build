<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:mrc="http://standards.iso.org/iso/19115/-3/mrc/2.0"
                xmlns:ident="http://geonetwork-opensource.org/schemas/schema-ident"
                exclude-result-prefixes="xs ident mrc"
                version="2.0">

    <xsl:output indent="yes"/>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="linkToPortal">
        <xsl:copy>
            <xsl:value-of select="replace(text(), 'Access to the portal', 'Access to the record in catalogue')" />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>