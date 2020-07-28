<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all">

  <!-- Import core template -->
  <xsl:include href="subtemplate-transformation-core.xsl"/>

  <!-- Allow elements wrapping gml elements to be used as sub-templates-->
  <xsl:template name="remove-top-element">
    <xsl:apply-templates select="*" mode="from19139to19115-3.2018"/>
  </xsl:template>
</xsl:stylesheet>
