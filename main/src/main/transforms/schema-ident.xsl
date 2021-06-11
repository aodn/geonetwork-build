<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mrc="http://standards.iso.org/iso/19115/-3/mrc/2.0"
    xmlns:ident="http://geonetwork-opensource.org/schemas/schema-ident"
    exclude-result-prefixes="xs ident mrc"
    version="2.0">

    <!-- This transform is applied to iso19115-3.2018/schema-ident.xml to add sub template (directory entry)  -->
    <!-- support for mrc:units -->

    <xsl:output indent="yes"/>

    <!-- default action is to copy attributes and nodes -->

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- add mrc:units to iso19115-3:2018 elements that can be used as sub templates (directory entries)-->
    
    <xsl:template match="ident:elements">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
            <mrc:units/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
