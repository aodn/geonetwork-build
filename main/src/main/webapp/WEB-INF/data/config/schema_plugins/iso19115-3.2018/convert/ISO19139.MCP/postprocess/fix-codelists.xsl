<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:dqm="http://standards.iso.org/iso/19157/-2/dqm/1.0"
                exclude-result-prefixes="#all">

  <xsl:variable name="codelistloc" select="'http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml'"/>

  <!-- codelists: set @codeList path -->
  <xsl:template mode="postprocess" match="lan:LanguageCode[@codeListValue]" priority="10">
    <lan:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/">
      <xsl:apply-templates mode="postprocess" select="@*[name(.)!='codeList']"/>
    </lan:LanguageCode>
  </xsl:template>

  <xsl:template mode="postprocess" match="dqm:*[@codeListValue]" priority="10">
    <xsl:copy>
      <xsl:apply-templates mode="postprocess" select="@*"/>
      <xsl:attribute name="codeList">
        <xsl:value-of select="concat($codelistloc,'#',local-name(.))"/>
      </xsl:attribute>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="postprocess" match="*[@codeListValue]">
    <xsl:copy>
      <xsl:apply-templates mode="postprocess" select="@*"/>
      <xsl:attribute name="codeList">
        <xsl:value-of select="concat($codelistloc,'#',local-name(.))"/>
      </xsl:attribute>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
