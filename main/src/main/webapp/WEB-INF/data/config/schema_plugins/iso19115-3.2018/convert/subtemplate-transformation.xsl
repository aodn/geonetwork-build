<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all">

  <!-- Import core template -->
  <xsl:include href="subtemplate-transformation-core.xsl"/>

  <!-- Allow elements wrapping gml elements to be used as sub-templates-->
  <xsl:template name="remove-top-element">
    <xsl:apply-templates select="*" mode="copy-all"/>
  </xsl:template>

  <!-- copy everything mode - identity transform-->
  <xsl:template match="@*|node()" mode="copy-all">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="copy-all"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
