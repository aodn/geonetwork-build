<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                version="2.0"
                exclude-result-prefixes="#all">

  <xsl:output indent="yes"/>

  <xsl:param name="urlSubstitutionsConfig"/>

  <!-- load substitutions config -->

  <xsl:variable name="config" select="document(resolve-uri($urlSubstitutionsConfig))"/>

  <!-- url substitutions to be performed -->

  <xsl:variable name="urlSubstitutions" select="$config/config/substitution"/>

  <xsl:variable name="urlSubstitutionSelector" select="string-join($urlSubstitutions/@match, '|')"/>

  <!-- target url -->

  <xsl:variable name="url" select="$config/config/url/text()"/>

  <!-- uuid of record being processed -->

  <xsl:variable name="uuid" select="//mdb:metadataIdentifier/mcc:MD_Identifier/mcc:code/*/text()"/>

  <!-- assert config is available and contains substitutions when matching root node -->

  <xsl:template mode="postprocess" match="/">
    <!-- abort if we can't load the url substitutions file or there are no substitutions -->
    <xsl:if test="not(doc-available($urlSubstitutionsConfig))">
        <xsl:message terminate="yes" select="concat('Could not load url substitutions configuration file: ', $urlSubstitutionsConfig)"/>
    </xsl:if>
    <!-- abort if there are no substitutions to apply -->
    <xsl:if test="not($urlSubstitutionSelector)">
        <xsl:message terminate="yes" select="concat('No substitutions specified in: ', $urlSubstitutionsConfig)"/>
    </xsl:if>
    <!-- All good - apply templates -->
    <xsl:apply-templates mode="postprocess" select="node()"/>
  </xsl:template>

  <!-- substitute production service endpoints with integration testing endpoints -->

  <xsl:template mode="postprocess" match="cit:linkage/gco:CharacterString[matches(., $urlSubstitutionSelector)]">
    <xsl:copy>
      <xsl:apply-templates mode="substitute" select="text()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="postprocess" match="@xlink:href[matches(., $urlSubstitutionSelector)]">
    <xsl:attribute name="xlink:href">
      <xsl:apply-templates mode="substitute" select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template mode="substitute" match="@*|text()">
    <xsl:variable name="url" select="."/>
    <xsl:for-each select="$urlSubstitutions">
      <xsl:if test="matches($url, string(@match))">
        <xsl:value-of select="replace($url, string(@match), string(@replaceWith))"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template mode="postprocess" match="mri:abstract/gco:CharacterString[matches(., $urlSubstitutionSelector)]">
    <xsl:variable name="abstractText" select="text()"/>
    <xsl:copy>
      <xsl:for-each select="$urlSubstitutions">
        <xsl:if test="matches($abstractText, string(@match))">
          <xsl:value-of select="replace($abstractText, string(@match), string(@replaceWith))"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <!-- replace local thumbnail references used in gn2 with api calls to target instance in gn3 -->

  <xsl:template mode="postprocess" match="mri:graphicOverview/mcc:MD_BrowseGraphic/mcc:fileName/*[normalize-space() and not(matches(., '(http|ftp|https)://'))]">
    <xsl:copy>
      <xsl:value-of select="concat($url, '/api/records/', $uuid, '/attachments/', text())"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

