<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:mrc="http://standards.iso.org/iso/19115/-3/mrc/2.0"
                xmlns:mac="http://standards.iso.org/iso/19115/-3/mac/2.0"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                version="2.0"
                exclude-result-prefixes="#all">

  <xsl:import href="common/suggestion-process.xsl"/>

  <xsl:output indent="yes"/>

  <!-- Identify missing coverage parameters                                                           -->
  <!-- Any parameter listed in keywords that is not included in a contentInfo coverage description is -->
  <!-- considered missing                                                                             -->

  <xsl:variable name="keyword-parameters"
                select="//mri:MD_Keywords[mri:thesaurusName/*/cit:title/*='AODN Discovery Parameter Vocabulary']/mri:keyword[normalize-space(*/text())!='']"/>
  <xsl:variable name="coverage-parameters"
                select="//mrc:MD_SampleDimension/mrc:name/mcc:MD_Identifier/mcc:code/*/text()"/>
  <xsl:variable name="missing-coverage-parameters"
                select="$keyword-parameters[not($coverage-parameters and index-of($coverage-parameters, */text()))]"/>

  <!-- Identify missing acquisition information platforms                                             -->
  <!-- Any platform listed in keywords that isn't included in the acquisition information section     -->
  <!-- is considered missing -->

  <xsl:variable name="keyword-platforms"
                select="//mri:MD_Keywords[mri:thesaurusName/*/cit:title/*='AODN Platform Vocabulary']/mri:keyword[normalize-space(*/text())!='']"/>
  <xsl:variable name="acquisition-platforms" select="//mac:MI_Platform/mac:identifier/mcc:MD_Identifier/mcc:code/*/text()"/>
  <xsl:variable name="missing-acquisition-platforms"
                select="$keyword-platforms[not($acquisition-platforms and index-of($acquisition-platforms, */text()))]"/>

  <!-- ======================== -->
  <!-- Suggestion API templates -->
  <!-- ======================== -->

  <!-- Identify process contained in this file -->

  <xsl:template name="list-add-missing-parameters-and-platforms">
    <suggestion process="add-missing-parameters-and-platforms"/>
  </xsl:template>

  <!-- Analyze the metadata record and return available suggestion for this process -->

  <xsl:template name="analyze-add-missing-parameters-and-platforms">
    <xsl:param name="root"/>

    <xsl:if test="$missing-coverage-parameters or $missing-acquisition-platforms">
      <xsl:variable name="missing-params-msg">
        <xsl:if test="$missing-coverage-parameters">
          <xsl:value-of select="concat('Add ''', string-join($missing-coverage-parameters/*/text(),''', '''), ''' parameter(s) to coverage description.')"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="missing-platforms-msg">
        <xsl:if test="$missing-acquisition-platforms">
          <xsl:value-of select="concat('Add ''', string-join($missing-acquisition-platforms/*/text(),''', '''), ''' platform(s) to acquisition information.')"/>
        </xsl:if>
      </xsl:variable>
      <suggestion process="add-missing-parameters-and-platforms">
        <name><xsl:value-of select="concat($missing-params-msg, ' ', $missing-platforms-msg)"/></name>
        <operational>true</operational>
      </suggestion>
    </xsl:if>

  </xsl:template>

  <!-- ================= -->
  <!-- Apply suggestions -->
  <!-- ================= -->

  <!-- Default action - copy very node and attribute -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Remove geonet:* elements. -->
  <xsl:template match="geonet:*" priority="2"/>

  <!-- Add missing contentInfo/acquisitionInformation sections if required -->

  <xsl:template match="mdb:MD_Metadata">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="mdb:metadataIdentifier"/>
      <xsl:apply-templates select="mdb:defaultLocale"/>
      <xsl:apply-templates select="mdb:parentMetadata"/>
      <xsl:apply-templates select="mdb:metadataScope"/>
      <xsl:apply-templates select="mdb:contact"/>
      <xsl:apply-templates select="mdb:dateInfo"/>
      <xsl:apply-templates select="mdb:metadataStandard"/>
      <xsl:apply-templates select="mdb:metadataProfile"/>
      <xsl:apply-templates select="mdb:alternativeMetadataReference"/>
      <xsl:apply-templates select="mdb:otherLocale"/>
      <xsl:apply-templates select="mdb:metadataLinkage"/>
      <xsl:apply-templates select="mdb:spatialRepresentationInfo"/>
      <xsl:apply-templates select="mdb:referenceSystemInfo"/>
      <xsl:apply-templates select="mdb:metadataExtensionInfo"/>
      <xsl:apply-templates select="mdb:identificationInfo"/>
      <xsl:apply-templates select="mdb:contentInfo"/>
      <xsl:if test="$missing-coverage-parameters
                and not(mdb:contentInfo[mrc:MD_CoverageDescription/mrc:attributeGroup/*/*/mrc:MD_CoverageContentTypeCode/@codeListValue='physicalMeasurement'])">
        <xsl:call-template name="add-content-info"/>
      </xsl:if>
      <xsl:apply-templates select="mdb:distributionInfo"/>
      <xsl:apply-templates select="mdb:dataQualityInfo"/>
      <xsl:apply-templates select="mdb:resourceLineage"/>
      <xsl:apply-templates select="mdb:portrayalCatalogueInfo"/>
      <xsl:apply-templates select="mdb:metadataConstraints"/>
      <xsl:apply-templates select="mdb:applicationSchemaInfo"/>
      <xsl:apply-templates select="mdb:metadataMaintenance"/>
      <xsl:apply-templates select="mdb:acquisitionInformation"/>
      <xsl:if test="$missing-acquisition-platforms
                and not(mdb:acquisitionInformation[*/mac:scope/*/*/mcc:MD_ScopeCode/@codeListValue='dataset'])">
        <xsl:call-template name="add-acquisition-info"/>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <!-- Add missing attributes to the first physical measurement attribute group in the first coverage description with physical measurements if required -->

  <xsl:template match="mdb:contentInfo[mrc:MD_CoverageDescription/mrc:attributeGroup/*/*/mrc:MD_CoverageContentTypeCode/@codeListValue='physicalMeasurement'][1]
        /mrc:MD_CoverageDescription[mrc:attributeGroup/*/*/mrc:MD_CoverageContentTypeCode/@codeListValue='physicalMeasurement'][1]
        /*/mrc:MD_AttributeGroup[*/mrc:MD_CoverageContentTypeCode/@codeListValue='physicalMeasurement'][1]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="mrc:contentType"/>
      <xsl:apply-templates select="mrc:attribute"/>
      <xsl:for-each select="$missing-coverage-parameters">
        <xsl:call-template name="add-parameter">
          <xsl:with-param name="parameter" select="."/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <!-- Add missing platforms to the first acquisition information section for the dataset -->

  <xsl:template match="mac:MI_AcquisitionInformation[mac:scope/*/*/mcc:MD_ScopeCode/@codeListValue='dataset'][1]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="mac:scope"/>
      <xsl:apply-templates select="mac:instrument"/>
      <xsl:apply-templates select="mac:operation"/>
      <xsl:apply-templates select="mac:platform"/>
      <xsl:for-each select="$missing-acquisition-platforms">
        <xsl:call-template name="add-platform">
          <xsl:with-param name="platform" select="."/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:apply-templates select="mac:acquisitionPlan"/>
      <xsl:apply-templates select="mac:objective"/>
      <xsl:apply-templates select="mac:acquisitionRequirement"/>
      <xsl:apply-templates select="mac:environmentalConditions"/>
    </xsl:copy>
  </xsl:template>

  <!-- Template to add a missing contentInfo section - adds all missing coverage parameters to this contentInfo section -->

  <xsl:template name="add-content-info">
    <mdb:contentInfo>
      <mrc:MD_CoverageDescription>
        <mrc:attributeDescription gco:nilReason="inapplicable"/>
        <mrc:attributeGroup>
          <mrc:MD_AttributeGroup>
            <mrc:contentType>
              <mrc:MD_CoverageContentTypeCode codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#MD_CoverageContentTypeCode"
                                              codeListValue="physicalMeasurement"/>
            </mrc:contentType>
            <xsl:for-each select="$missing-coverage-parameters">
              <xsl:call-template name="add-parameter">
                <xsl:with-param name="parameter" select="."/>
              </xsl:call-template>
            </xsl:for-each>
          </mrc:MD_AttributeGroup>
        </mrc:attributeGroup>
      </mrc:MD_CoverageDescription>
    </mdb:contentInfo>
  </xsl:template>

  <!-- Template to add a missing parameter - requires keyword parameter to add to be passed -->

  <xsl:template name="add-parameter">
    <xsl:param name="parameter"/>
    <mrc:attribute>
      <mrc:MD_SampleDimension>
        <mrc:name>
          <mcc:MD_Identifier>
            <mcc:code>
              <xsl:copy-of select="$parameter/*"/>
            </mcc:code>
          </mcc:MD_Identifier>
        </mrc:name>
      </mrc:MD_SampleDimension>
    </mrc:attribute>
  </xsl:template>

  <!-- Template to add a missing acquisition information section for the dataset - all missing platforms are added -->

  <xsl:template name="add-acquisition-info">
    <mdb:acquisitionInformation>
      <mac:MI_AcquisitionInformation>
        <mac:scope>
          <mcc:MD_Scope>
            <mcc:level>
              <mcc:MD_ScopeCode codeList="http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#MD_ScopeCode"
                                codeListValue="dataset"/>
            </mcc:level>
          </mcc:MD_Scope>
        </mac:scope>
        <xsl:for-each select="$missing-acquisition-platforms">
          <xsl:call-template name="add-platform">
            <xsl:with-param name="platform" select="."/>
          </xsl:call-template>
        </xsl:for-each>
      </mac:MI_AcquisitionInformation>
    </mdb:acquisitionInformation>
  </xsl:template>

  <!-- Template to add a platform to and acquisition section information section - all instrumemts are added -->

  <xsl:template name="add-platform">
    <xsl:param name="platform"/>
    <mac:platform>
      <mac:MI_Platform>
        <mac:identifier>
          <mcc:MD_Identifier>
            <mcc:code>
              <xsl:copy-of select="$platform/*"/>
            </mcc:code>
          </mcc:MD_Identifier>
        </mac:identifier>
        <mac:description gco:nilReason="missing"/>
      </mac:MI_Platform>
    </mac:platform>
  </xsl:template>

</xsl:stylesheet>
