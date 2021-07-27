<xsl:stylesheet version="2.0"
                xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"

                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gcoold="http://www.isotc211.org/2005/gco"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:mcp20="http://schemas.aodn.org.au/mcp-2.0"
                exclude-result-prefixes="#all">

  <xsl:param name="dataParamsConfig"/>
  <xsl:param name="urlSubstitutionsConfig"/>

  <xsl:variable name="targetUrl" select="document($urlSubstitutionsConfig)/config/url"/>
  <xsl:variable name="thesauriConfig" select="document($dataParamsConfig)/config"/>

  <xsl:template match="mcp20:dataParameters" mode="from19139to19115-3.2018-aodn">
    <!-- map each term to its keywordTypeCode/thesaurus (excluded parameters aren't included) -->
    <xsl:variable name="termMappings">
      <xsl:apply-templates mode="map-term" select=".//mcp20:platform[*/*/mcp20:DP_TypeCode/@codeListValue='longName']">
        <xsl:with-param name="typeCode" select="'platform'"/>
        <xsl:with-param name="defaultThesaurus" select="'platform'"/>
      </xsl:apply-templates>
      <xsl:apply-templates mode="map-term" select=".//mcp20:parameterName[*/*/mcp20:DP_TypeCode/@codeListValue='longName']">
        <xsl:with-param name="typeCode" select="'theme'"/>
        <xsl:with-param name="defaultThesaurus" select="'parameter'"/>
      </xsl:apply-templates>
      <!-- Add keywords for parameters with only a short name - as per IMAS usage -->
      <xsl:apply-templates mode="map-term" select=".//mcp20:dataParameter[not(.//mcp20:parameterName[*/*/mcp20:DP_TypeCode/@codeListValue='longName'])]
                                                    //mcp20:parameterName[*/mcp20:type/*/@codeListValue='shortName']">
        <xsl:with-param name="typeCode" select="'theme'"/>
        <xsl:with-param name="defaultThesaurus" select="'parameter'"/>
      </xsl:apply-templates>
      <xsl:apply-templates mode="map-term" select=".//mcp20:parameterDeterminationInstrument[*/*/mcp20:DP_TypeCode/@codeListValue='longName']">
        <xsl:with-param name="typeCode" select="'instrument'"/>
        <xsl:with-param name="defaultThesaurus" select="'instrument'"/>
      </xsl:apply-templates>
    </xsl:variable>

    <!-- create a descriptive keywords section for each typeCode, thesaurus combination -->
    <xsl:for-each-group select="$termMappings/termMapping[normalize-space(@term)]" group-by="concat(@typeCode, '#', @thesaurus)">
      <mri:descriptiveKeywords>
        <mri:MD_Keywords>
          <xsl:for-each-group select="current-group()" group-by="@term">
            <mri:keyword>
              <xsl:choose>
                <xsl:when test="current-group()[@termUri]">
                  <gcx:Anchor xlink:href="{current-group()[@termUri][1]/@termUri}">
                    <xsl:value-of select="current-grouping-key()"/>
                  </gcx:Anchor>
                </xsl:when>
                <xsl:otherwise>
                  <gco:CharacterString>
                    <xsl:value-of select="current-grouping-key()"/>
                  </gco:CharacterString>
                </xsl:otherwise>
              </xsl:choose>
            </mri:keyword>
          </xsl:for-each-group>
          <mri:type>
            <mri:MD_KeywordTypeCode codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#MD_KeywordTypeCode"
                                    codeListValue="{current-group()[1]/@typeCode}"/>
          </mri:type>
          <xsl:if test="current-group()[1]/@thesaurus">
            <xsl:variable name="thesaurus" select="$thesauriConfig/thesauri/thesaurus[@id=current-group()/@thesaurus]"/>
            <mri:thesaurusName>
              <cit:CI_Citation>
                <cit:title>
                  <gcx:Anchor><xsl:value-of select="$thesaurus/@title"/></gcx:Anchor>
                </cit:title>
                <cit:date>
                  <cit:CI_Date>
                    <cit:date>
                      <gco:Date>2020-03-03</gco:Date>
                    </cit:date>
                    <cit:dateType>
                      <cit:CI_DateTypeCode codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#CI_DateTypeCode"
                                           codeListValue="publication"/>
                    </cit:dateType>
                  </cit:CI_Date>
                </cit:date>
                <cit:identifier>
                  <mcc:MD_Identifier>
                    <mcc:code>
                      <gcx:Anchor xlink:href="{concat($targetUrl, '/eng/thesaurus.download?ref=', $thesaurus/@fileName)}">
                        <xsl:value-of select="concat('geonetwork.thesaurus.',$thesaurus/@fileName)"/></gcx:Anchor>
                    </mcc:code>
                  </mcc:MD_Identifier>
                </cit:identifier>
              </cit:CI_Citation>
            </mri:thesaurusName>
          </xsl:if>
        </mri:MD_Keywords>
      </mri:descriptiveKeywords>
    </xsl:for-each-group>
  </xsl:template>

  <!-- default mapping for terms -->

  <xsl:template mode="map-term" match="*">
    <xsl:param name="typeCode"/>
    <xsl:param name="defaultThesaurus"/>

    <termMapping term="{*/mcp20:term/*/text()}" termUri="{*/mcp20:vocabularyTermURL/*/text()}" typeCode="{$typeCode}" thesaurus="{$defaultThesaurus}"/>
  </xsl:template>

  <!-- mapping for terms without vocabulary references -->

  <xsl:template mode="map-term" match="*[not(*/mcp20:vocabularyTermURL/*/text() or */mcp20:vocabularyListURL/*/text())]" priority="100">
    <xsl:param name="typeCode"/>

    <termMapping term="{*/mcp20:term/*/text()}" typeCode="{$typeCode}"/>
  </xsl:template>

  <!-- don't add a mapping for excluded parameters -->

  <xsl:template mode="map-term" match="mcp20:parameterName[$thesauriConfig/excludedParameters/term[text()=current()/*/mcp20:term/*/text()]]"/>

  <!-- mapping for sampling parameters -->

  <xsl:template mode="map-term" match="mcp20:parameterName[$thesauriConfig/samplingParameters/term[text()=current()/*/mcp20:term/*/text()]]">
    <xsl:param name="typeCode"/>

    <termMapping term="{*/mcp20:term/*/text()}" termUri="{*/mcp20:vocabularyTermURL/*/text()}" typeCode="{$typeCode}" thesaurus="sampling-parameter"/>
  </xsl:template>

</xsl:stylesheet>