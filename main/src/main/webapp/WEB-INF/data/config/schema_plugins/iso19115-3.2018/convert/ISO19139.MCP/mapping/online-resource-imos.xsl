<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                exclude-result-prefixes="#all">

  <!-- Map description to name if name is empty and description isn't -->

  <xsl:template match="gmd:CI_OnlineResource[normalize-space(gmd:name/*)='' and normalize-space(gmd:description/*)!='']"
                mode="from19139to19115-3.2018"
                priority="100">
    <xsl:element name="cit:CI_OnlineResource">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="gmd:linkage" mode="from19139to19115-3.2018"/>
      <xsl:apply-templates select="gmd:protocol" mode="from19139to19115-3.2018"/>
      <xsl:apply-templates select="gmd:applicationProfile" mode="from19139to19115-3.2018"/>
      <xsl:element name="cit:name">
        <xsl:apply-templates select="gmd:description/(@*|node())" mode="from19139to19115-3.2018"/>
      </xsl:element>
      <xsl:apply-templates select="gmd:function" mode="from19139to19115-3.2018"/>
    </xsl:element>
  </xsl:template>
  
</xsl:stylesheet>