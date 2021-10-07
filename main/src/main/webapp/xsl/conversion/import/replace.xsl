<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:geonet="http://www.fao.org/geonetwork"
                exclude-result-prefixes="geonet"
                version="2.0">

    <!--
        References:
        replace
          https://github.com/aodn/cloud-deploy/blob/1d2d700e41f40b5002ed7e619ca16bc2bde3b9ff/sample-config/ebprep_conf/templates/geonetwork3/replace.xsl.template
          replace?pattern=http://nzodn.nz&replacement=https://nzodn.nz
    -->

    <xsl:output indent="yes"/>

    <xsl:include href="../common/get-data-dir.xsl" />
    <xsl:variable name="config" select="document(concat($data-dir,'/config/url-substitutions/replace.xml'))" />

    <xsl:variable name="pattern" select="$config/config/niwa/@pattern" />
    <xsl:variable name="replacement" select="$config/config/niwa/@replacement" />

    <!-- default action is to copy -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Always remove geonet:* elements. -->
    <xsl:template match="geonet:*"/>

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
