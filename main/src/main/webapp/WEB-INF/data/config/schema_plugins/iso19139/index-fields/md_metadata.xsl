<?xml version="1.0" encoding="UTF-8" ?>
<!-- Index a record for the main language -->
<xsl:stylesheet xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:converter="java:au.org.emii.xsl.GmlWktConverter"
                xmlns:saxon="http://saxon.sf.net/"
                version="2.0"
                exclude-result-prefixes="#all">

    <xsl:include href="default.xsl"/>

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

    <xsl:output name="serialisation-output-format" method="xml" omit-xml-declaration="yes"/>

    <!-- Index layer name for use by aws-wps to lookup the metadata record for an aggregation -->
    <xsl:template mode="index"
                  match="gmd:transferOptions/*/gmd:onLine/gmd:CI_OnlineResource[gmd:protocol/*/text()='IMOS:NCWMS--proto' or contains(gmd:protocol, 'http-get-map')]">
        <Field name="layer" string="{normalize-space(gmd:name/gco:CharacterString|gmd:name/gmx:MimeFileType)}" store="false" index="true"/>
    </xsl:template>

    <!-- Index bounding polygons as WKT for use by the portal to display the bounding polygons in the search results -->
    <xsl:template mode="index" match="gmd:polygon">
        <xsl:variable name="gml" select="saxon:serialize(., 'serialisation-output-format')"/>
        <Field name="geoPolygon" string="{converter:gmlToWkt($gml)}" store="true" index="false"/>
    </xsl:template>

    <!-- Index point of truth link for use as an additional CSW queryable -->
    <xsl:template mode="index" match="gmd:CI_OnlineResource[gmd:protocol/*/text()='WWW:LINK-1.0-http--metadata-URL']/gmd:linkage/gmd:URL">
        <Field name="pointOfTruthLink" string="{text()}" store="true" index="true"/>
    </xsl:template>

</xsl:stylesheet>
