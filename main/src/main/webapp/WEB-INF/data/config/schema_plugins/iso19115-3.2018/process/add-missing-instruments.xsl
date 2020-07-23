<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:geonet="http://www.fao.org/geonetwork"
    xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
    xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
    xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:gmx="http://www.isotc211.org/2005/gmx"
    xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
    xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
    xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
    xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
    xmlns:mrc="http://standards.iso.org/iso/19115/-3/mrc/2.0"
    xmlns:mac="http://standards.iso.org/iso/19115/-3/mac/2.0"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    version="2.0"
    exclude-result-prefixes="#all">

  <xsl:import href="common/suggestion-process.xsl"/>

  <xsl:output indent="yes"/>

    <!-- Identify missing acquisition platform instruments                                                  -->
    <!-- Instruments listed in keywords that are not listed for platforms in the acquisition information    -->
    <!-- section are considered missing                                                                     -->

    <xsl:variable name="keyword-instruments"
        select="//mri:MD_Keywords[mri:thesaurusName/*/cit:title/*='AODN Instrument Vocabulary']/mri:keyword[normalize-space(*/text())!='']"/>

    <xsl:variable name="missing-instruments">
        <xsl:variable name="acquisition-platforms"
            select="//mac:MI_Platform[mac:identifier/mcc:MD_Identifier/mcc:code/*/text()[normalize-space()!='']]"/>
        <xsl:for-each select="$acquisition-platforms">
            <xsl:variable name="platform" select="."/>
            <xsl:variable name="platform-name" select="mac:identifier/mcc:MD_Identifier/mcc:code/*/text()"/>
            <xsl:for-each select="$keyword-instruments[not(index-of($platform/mac:instrument/*/mac:identifier/mcc:MD_Identifier/mcc:code/*/text(),*/text()))]">
                <xsl:variable name="instrument" select="*/text()"/>
                <missing-instrument platform="{$platform-name}" instrument="{$instrument}"/>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:variable>

    <!-- ======================== -->
    <!-- Suggestion API templates -->
    <!-- ======================== -->

    <!-- Identify process contained in this file -->

    <xsl:template name="list-add-missing-instruments">
        <suggestion process="add-missing-instruments"/>
    </xsl:template>

    <!-- Analyze the metadata record and return available suggestion for this process -->

    <xsl:template name="analyze-add-missing-instruments">
        <xsl:param name="root"/>

        <xsl:if test="$missing-instruments/*">
            <xsl:variable name="missing-platform-instruments-msg">
                <xsl:for-each-group select="$missing-instruments/missing-instrument" group-by="@platform">
                    <xsl:value-of select="concat('Add ''', string-join(current-group()/@instrument, ''', '''), ''' instrument(s) to ''', current-grouping-key(), ''' platform. ')"/>
                </xsl:for-each-group>
            </xsl:variable>
            <suggestion process="add-missing-instruments">
                <name><xsl:value-of select="$missing-platform-instruments-msg"/></name>
                <operational>true</operational>
            </suggestion>
        </xsl:if>

    </xsl:template>

    <!-- ================= -->
    <!-- Apply suggestions -->
    <!-- ================= -->

    <!-- Default action - copy very node and attribute -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Remove geonet:* elements. -->
    <xsl:template match="geonet:*" priority="2"/>

    <!-- Add missing instruments to acquisition platforms -->

    <xsl:template match="mac:MI_Platform">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="mac:citation"/>
            <xsl:apply-templates select="mac:identifier"/>
            <xsl:apply-templates select="mac:citation"/>
            <xsl:apply-templates select="mac:description"/>
            <xsl:apply-templates select="mac:sponsor"/>
            <xsl:apply-templates select="mac:instrument"/>
            <xsl:variable name="current-instruments" select="mac:instrument/*/mac:identifier/mcc:MD_Identifier/mcc:code/*/text()"/>
            <xsl:for-each select="$keyword-instruments[not(index-of($current-instruments,*/text()))]">
                <xsl:call-template name="add-instrument">
                    <xsl:with-param name="instrument" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:apply-templates select="mac:otherPropertyType"/>
            <xsl:apply-templates select="mac:otherProperty"/>
            <xsl:apply-templates select="mac:history"/>
        </xsl:copy>
    </xsl:template>

    <!-- Template to add an instrument to a platform - requires the instrument keyword to be added to be passed -->

    <xsl:template name="add-instrument">
        <xsl:param name="instrument"/>
        <mac:instrument>
            <mac:MI_Instrument>
                <mac:identifier>
                    <mcc:MD_Identifier>
                        <mcc:code>
                            <xsl:copy-of select="$instrument/*"/>
                        </mcc:code>
                    </mcc:MD_Identifier>
                </mac:identifier>
                <mac:type gco:nilReason="missing">
                    <gco:CharacterString/>
                </mac:type>
            </mac:MI_Instrument>
        </mac:instrument>
    </xsl:template>

</xsl:stylesheet>
