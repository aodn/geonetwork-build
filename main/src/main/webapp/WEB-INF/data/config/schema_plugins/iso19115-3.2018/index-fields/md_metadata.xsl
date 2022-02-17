<?xml version="1.0" encoding="UTF-8" ?>
<!-- Index a record for the main language -->
<xsl:stylesheet version="2.0"
            xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
            xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
            xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
            xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
            xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
            xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
            xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
            xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
            xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
            xmlns:converter="java:au.org.emii.xsl.GmlWktConverter"
            xmlns:xlink="http://www.w3.org/1999/xlink"
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
        <Field name="pointOfTruthLink" string="{cit:linkage/*/text()}" store="true" index="true"/>
        <Field name="link" string="{concat(cit:name/*/text(), '|', cit:description/*/text(), '|', cit:linkage/*/text(),'|', cit:protocol/*/text(),'|1')}" store="true" index="false"/>
    </xsl:template>

    <!-- Index creative commons licensing information for display when downloading data -->

    <xsl:template mode="index" match="mco:MD_LegalConstraints[contains(mco:reference/*/cit:citedResponsibleParty//cit:linkage/*/text(), 'http://creativecommons.org')]">
        <Field name="MD_LegalConstraintsOtherConstraints" string="{mco:reference/*/cit:title/*/text()}" store="true" index="false" />
        <Field name="MD_LegalConstraintsOtherConstraints" string="{mco:reference/*/cit:onlineResource//cit:linkage/*/text()}" store="true" index="false" />
        <Field name="jurisdictionLink" string="{mco:reference/*/cit:citedResponsibleParty//cit:linkage/*/text()}" store="true" index="false" />
        <Field name="licenseName" string="{mco:reference/*/cit:title/*/text()}" store="true" index="false" />
        <Field name="licenseLink" string="{mco:reference/*/cit:onlineResource//cit:linkage/*/text()}" store="true" index="false" />
        <Field name="imageLink" string="{mco:graphic//cit:linkage/*/text()}" store="true" index="false" />
        <!-- index any other constraints such as accessConstraints or otherConstraints -->
        <xsl:apply-templates mode="index" select="@*|node()"/>
    </xsl:template>

    <!-- Index constraints for display when downloading data -->

    <xsl:template mode="index" match="mri:resourceConstraints/*/mco:accessConstraints/mco:MD_RestrictionCode/@codeListValue">
        <Field name="accessConstr" string="{string(.)}" store="true" index="false"/>
    </xsl:template>

    <xsl:template mode="index" match="mri:resourceConstraints/*/mco:otherConstraints/gco:CharacterString">
        <Field name="otherConstr" string="{string(.)}" store="true" index="false"/>
    </xsl:template>

    <xsl:template mode="index" match="mri:resourceConstraints/*/mco:classification/mco:MD_ClassificationCode/@codeListValue">
        <Field name="classif" string="{string(.)}" store="true" index="false"/>
    </xsl:template>

    <xsl:template mode="index" match="mri:resourceConstraints/*/mco:useLimitation/gco:CharacterString">
        <Field name="useLimitation" string="{string(.)}" store="true" index="false"/>
    </xsl:template>

    <!-- Index unique organisation names used in resource point of contacts/citation cited responsible parties  -->

    <xsl:template mode="index" match="mri:MD_DataIdentification">
        <xsl:for-each-group select="(mri:pointOfContact|mri:citation/*/cit:citedResponsibleParty)/cit:CI_Responsibility/cit:party/cit:CI_Organisation/cit:name/*/text()" group-by=".">
            <Field name="uniqueOrgName" string="{string(current-grouping-key())}" store="true" index="true"/>
        </xsl:for-each-group>
        <!-- continue indexing children -->
        <xsl:apply-templates mode="index" select="@*|node()"/>
    </xsl:template>

    <!-- Index keyword anchors for a thesaurus to allow facets to be configured using them (IMAS GCMD keywords) -->
    
    <xsl:template mode="index" match="mri:MD_Keywords">
        <xsl:variable name="thesaurusTitle"
                      select="replace(mri:thesaurusName/*/cit:title/gco:CharacterString/text(), ' ', '')"/>
        <xsl:variable name="thesaurusIdentifier"
                      select="mri:thesaurusName/*/cit:identifier/*/mcc:code/*/text()"/>

        <xsl:variable name="fieldName"
                      select="if ($thesaurusIdentifier != '')
                              then $thesaurusIdentifier
                              else $thesaurusTitle"/>
        <xsl:variable name="fieldNameTemp"
                      select="if (starts-with($fieldName, 'geonetwork.thesaurus'))
                                then substring-after($fieldName, 'geonetwork.thesaurus.')
                                else $fieldName"/>

        <xsl:for-each select="mri:keyword/gcx:Anchor/@xlink:href[normalize-space()!='']">
            <xsl:if test="$fieldNameTemp != ''">
                <!-- Index field thesaurus-{{thesaurusIdentifier}}-anchor={{anchor}} -->
                <Field name="{concat('thesaurus-', $fieldNameTemp, '.anchor')}" string="{string(.)}" store="true" index="true"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
