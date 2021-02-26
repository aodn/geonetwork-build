<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"
                exclude-result-prefixes="#all">

    <xsl:output indent="yes"/>

    <xsl:include href="postprocess/substitute-urls.xsl"/>
    <xsl:include href="postprocess/fix-codelists.xsl"/>

    <!-- default action is to copy -->

    <xsl:template mode="postprocess" match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates mode="postprocess" select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>

