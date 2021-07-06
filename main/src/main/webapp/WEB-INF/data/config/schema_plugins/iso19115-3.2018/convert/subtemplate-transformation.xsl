<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all">

  <!-- Add a transform that can be used in the data-transformation attribute of the data-gn-directory-entry-selector element -->
  <!-- in config-editor.xml for mrc:units that removes the top element included in the directory entry -->
  <!-- prior to inserting the directory entry into the metadata - the sub-template can't be created without this element -->
  <!-- but we can't insert it -->

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
