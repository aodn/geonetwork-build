<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:gmd="http://www.isotc211.org/2005/gmd"
        xmlns:gco="http://www.isotc211.org/2005/gco"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="2.0">
    
    <!--
        References:
        ga
          https://github.com/aodn/cloud-deploy/blob/1d2d700e41f40b5002ed7e619ca16bc2bde3b9ff/sample-config/ebprep_conf/templates/geonetwork3/ga.xsl.template
          https://github.com/aodn/cloud-deploy/blob/1d2d700e41f40b5002ed7e619ca16bc2bde3b9ff/sample-config/ebprep_conf/templates/geonetwork3/add-collection-config.xsl.template
          ga?config-dir=https://raw.githubusercontent.com/aodn/collection-config/master/geoscience-australia
    -->

    <xsl:variable name="config" select="document('../../../WEB-INF/data/config/url-substitutions/collection-add.xml')"/>
    <xsl:variable name="config-dir" select="$config/config/ga/@config-dir" />

    <xsl:include href="../../../WEB-INF/data/config/schema_plugins/iso19115-3.2018/process/add-collection-config.xsl"/>

    <!-- Fix incorrectly mapped MD_LegalConstraints/reference element -->

    <xsl:template match="gmd:MD_LegalConstraints/gmd:reference">
        <!-- not valid in iso19139 - map to otherConstraint -->
        <xsl:element name="gmd:otherConstraints">
            <xsl:element name="gco:CharacterString">
                <xsl:value-of select="gmd:CI_Citation/gmd:title/*/text()"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
