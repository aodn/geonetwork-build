<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0">

    <!-- This transform is used to customise strings used in GeoNetwork - its applied to iso19115-3.2018/loc/eng/strings.xml -->
    <!-- and iso19139/loc/eng/strings.xml -->

    <xsl:output indent="yes"/>

    <!-- Default rule is to copy attributes and nodes -->

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Change link to the portal description  -->

    <xsl:template match="linkToPortal"><linkToPortal>Access to the record in catalogue</linkToPortal></xsl:template>

</xsl:stylesheet>