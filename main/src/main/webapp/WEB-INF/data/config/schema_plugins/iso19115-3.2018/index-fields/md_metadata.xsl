<?xml version="1.0" encoding="UTF-8" ?>
<!-- Index a record for the main language -->
<xsl:stylesheet version="2.0"
            xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
            xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
            xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
            xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
            xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
            xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
            xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
            xmlns:converter="java:au.org.emii.xsl.GmlWktConverter"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:saxon="http://saxon.sf.net/"
            exclude-result-prefixes="#all">

    <xsl:include href="default.xsl"/>

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

    <xsl:output name="serialisation-output-format" method="xml" omit-xml-declaration="yes"/>

    <!-- Index layer name for use by aws-wps to lookup the metadata record for an aggregation -->
    <xsl:template mode="index"
                  match="mrd:transferOptions//cit:CI_OnlineResource[cit:protocol/*/text()='IMOS:NCWMS--proto' or contains(cit:protocol, 'http-get-map')]">
        <Field name="layer" string="{normalize-space(cit:name/gco:CharacterString|cit:name/gcx:MimeFileType)}" store="false" index="true"/>
    </xsl:template>

    <!-- Index bounding polygons as WKT for use by the portal to display the bounding polygons in the search results -->
    <xsl:template mode="index" match="gex:polygon">
        <xsl:variable name="gml" select="saxon:serialize(., 'serialisation-output-format')"/>
        <Field name="geoPolygon" string="{converter:gmlToWkt($gml)}" store="true" index="false"/>
    </xsl:template>

    <!-- Index point of truth link for use as an additional CSW queryable and as a link for portal usage-->
    <xsl:template mode="index" match="mdb:metadataLinkage[1]/cit:CI_OnlineResource">
        <Field name="pointOfTruthLink" string="{cit:linkage/*/text()}" store="true" index="false"/>
        <Field name="link" string="{concat(cit:name/*/text(), '|', cit:description/*/text(), '|', cit:linkage/*/text(),'|', cit:protocol/*/text(),'|1')}" store="true" index="false"/>
    </xsl:template>

    <!-- Index creative commons licensing information -->

    <xsl:template mode="index" match="mco:MD_LegalConstraints[contains(mco:reference/*/cit:citedResponsibleParty//cit:linkage/*/text(), 'http://creativecommons.org')]">
        <Field name="jurisdictionLink" string="{mco:reference/*/cit:citedResponsibleParty//cit:linkage/*/text()}" store="true" index="false" />
        <Field name="licenseName" string="{mco:reference/*/cit:title/*/text()}" store="true" index="false" />
        <Field name="licenseLink" string="{mco:reference/*/cit:onlineResource//cit:linkage/*/text()}" store="true" index="false" />
        <Field name="imageLink" string="{mco:graphic//cit:linkage/*/text()}" store="true" index="false" />
    </xsl:template>

</xsl:stylesheet>
