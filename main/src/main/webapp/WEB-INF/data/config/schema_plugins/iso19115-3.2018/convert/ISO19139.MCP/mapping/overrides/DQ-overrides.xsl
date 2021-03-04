<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gcoold="http://www.isotc211.org/2005/gco"
                xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:srvold="http://www.isotc211.org/2005/srv"
                xmlns:gsr="http://www.isotc211.org/2005/gsr"
                xmlns:gss="http://www.isotc211.org/2005/gss"
                xmlns:gml30="http://www.opengis.net/gml"
                xmlns:cat="http://standards.iso.org/iso/19115/-3/cat/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.0"
                xmlns:mac="http://standards.iso.org/iso/19115/-3/mac/2.0"
                xmlns:mas="http://standards.iso.org/iso/19115/-3/mas/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:mda="http://standards.iso.org/iso/19115/-3/mda/2.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mdt="http://standards.iso.org/iso/19115/-3/mdt/2.0"
                xmlns:mex="http://standards.iso.org/iso/19115/-3/mex/1.0"
                xmlns:mic="http://standards.iso.org/iso/19115/-3/mic/1.0"
                xmlns:mil="http://standards.iso.org/iso/19115/-3/mil/1.0"
                xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/2.0"
                xmlns:mds="http://standards.iso.org/iso/19115/-3/mds/2.0"
                xmlns:mmi="http://standards.iso.org/iso/19115/-3/mmi/1.0"
                xmlns:mpc="http://standards.iso.org/iso/19115/-3/mpc/1.0"
                xmlns:mrc="http://standards.iso.org/iso/19115/-3/mrc/2.0"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
                xmlns:msr="http://standards.iso.org/iso/19115/-3/msr/2.0"
                xmlns:mai="http://standards.iso.org/iso/19115/-3/mai/1.0"
                xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:mcp20="http://schemas.aodn.org.au/mcp-2.0"
                exclude-result-prefixes="#all">

  <!-- Core fixes for data quality lineage changes -->

  <xsl:template match="gmd:dataQualityInfo" mode="from19139to19115-3.2018">
    <xsl:if test="gmd:DQ_DataQuality/gmd:report">
      <!-- ISO 19157 -->
      <mdb:dataQualityInfo>
        <mdq:DQ_DataQuality>
          <xsl:if test="gmd:DQ_DataQuality/gmd:scope">
            <mdq:scope>
              <xsl:choose>
                <xsl:when test="gmd:DQ_DataQuality/gmd:scope/@*">
                  <xsl:copy-of select="gmd:DQ_DataQuality/gmd:scope/@*"/>
                </xsl:when>
                <xsl:otherwise>
                  <mcc:MD_Scope>
                    <xsl:apply-templates select="gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/*" mode="from19139to19115-3.2018"/>
                  </mcc:MD_Scope>
                </xsl:otherwise>
              </xsl:choose>
            </mdq:scope>
          </xsl:if>
          <xsl:for-each select="gmd:DQ_DataQuality/gmd:report">
            <xsl:for-each select="*">
              <xsl:element name="mdq:report">
                <!-- DQ_NonQuantitativeAttributeAccuracy changed to DQ_NonQuantitativeAttributeCorrectness -->
                <xsl:variable name="dataQualityReportType">
                  <xsl:choose>
                    <xsl:when test="local-name()='DQ_NonQuantitativeAttributeAccuracy'">
                      <xsl:value-of select="'DQ_NonQuantitativeAttributeCorrectness'"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="local-name()"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:element name="{concat('mdq:',$dataQualityReportType)}">
                  <xsl:if test="gmd:nameOfMeasure or gmd:measureIdentification or gmd:measureDescription">
                    <!-- output quality measure information only if gmd:measureIdentification or gmd:measureDescription exist -->
                    <mdq:measure>
                      <mdq:DQ_MeasureReference>
                        <xsl:apply-templates select="gmd:measureIdentification" mode="from19139to19115-3.2018"/>
                        <xsl:call-template name="writeCharacterStringElement">
                          <xsl:with-param name="elementName" select="'mdq:nameOfMeasure'"/>
                          <xsl:with-param name="nodeWithStringToWrite" select="gmd:nameOfMeasure"/>
                        </xsl:call-template>
                        <xsl:call-template name="writeCharacterStringElement">
                          <xsl:with-param name="elementName" select="'mdq:measureDescription'"/>
                          <xsl:with-param name="nodeWithStringToWrite" select="gmd:measureDescription"/>
                        </xsl:call-template>
                      </mdq:DQ_MeasureReference>
                    </mdq:measure>
                  </xsl:if>
                  <xsl:if
                    test="gmd:evaluationMethodDescription or gmd:evaluationProcedure/gmd:CI_Citation 
                    or gmd:evaluationMethodType/gmd:DQ_EvaluationMethodTypeCode/@codeListValue">
                    <!-- output quality evaluation method information only if gmd:evaluationMethodDescription 
                      or gmd:evaluationProcedure/gmd:CI_Citation 
                      or gmd:evaluationMethodType/gmd:DQ_EvaluationMethodTypeCode/@codeListValue exist -->
                    <mdq:evaluationMethod>
                      <mdq:DQ_FullInspection>
                        <xsl:if test="gmd:dateTime/gcoold:DateTime">
                          <mdq:dateTime>
                            <gco:DateTime>
                              <xsl:value-of select="gmd:dateTime/gcoold:DateTime"/>
                            </gco:DateTime>
                          </mdq:dateTime>
                        </xsl:if>
                        <xsl:call-template name="writeCharacterStringElement">
                          <xsl:with-param name="elementName" select="'mdq:evaluationMethodDescription'"/>
                          <xsl:with-param name="nodeWithStringToWrite" select="gmd:evaluationMethodDescription"/>
                        </xsl:call-template>
                        <mdq:evaluationProcedure>
                          <xsl:apply-templates select="gmd:evaluationProcedure/gmd:CI_Citation" mode="from19139to19115-3.2018"/>
                        </mdq:evaluationProcedure>
                        <xsl:call-template name="writeCodelistElement">
                          <xsl:with-param name="elementName" select="'mdq:evaluationMethodType'"/>
                          <xsl:with-param name="codeListName" select="'mdq:DQ_EvaluationMethodTypeCode'"/>
                          <xsl:with-param name="codeListValue" select="gmd:evaluationMethodType/gmd:DQ_EvaluationMethodTypeCode/@codeListValue"/>
                        </xsl:call-template>
                      </mdq:DQ_FullInspection>
                    </mdq:evaluationMethod>
                    <xsl:apply-templates select="gmd:result" mode="from19139to19115-3.2018"/>
                  </xsl:if>
                  <!-- gmd:result uses default templates -->
                  <xsl:apply-templates select="gmd:result" mode="from19139to19115-3.2018"/>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:for-each>
        </mdq:DQ_DataQuality>
      </mdb:dataQualityInfo>
    </xsl:if>
    <!--
    gmd:lineage moves directly under MD_Metadata
    -->
    <xsl:for-each select="gmd:DQ_DataQuality[gmd:lineage]">
      <!--
      gmd:DataQuality objects without lineage go to ISO 19157
      -->
      <xsl:element name="mdb:resourceLineage">
        <mrl:LI_Lineage>
          <xsl:call-template name="writeCharacterStringElement">
            <xsl:with-param name="elementName" select="'mrl:statement'"/>
            <xsl:with-param name="nodeWithStringToWrite" select="./gmd:lineage/gmd:LI_Lineage/gmd:statement"/>
          </xsl:call-template>
          <xsl:choose>
            <xsl:when test="./gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode/@codeListValue != ''">
              <xsl:apply-templates select="../gmd:DQ_DataQuality" mode="dataQualityScope"/>
            </xsl:when>
            <xsl:when test="./gmd:scope/gmd:DQ_Scope/gmd:level/gmx:MX_ScopeCode/@codeListValue != ''">
              <xsl:apply-templates select="../gmd:DQ_DataQuality" mode="dataQualityScope"/>
            </xsl:when>
            <xsl:when test=".//gmd:MD_ScopeDescription/gmd:dataset/gcoold:CharacterString">
              <xsl:apply-templates select="../gmd:DQ_DataQuality" mode="dataQualityScope"/>
            </xsl:when>
            <xsl:otherwise>
              <mrl:scope />
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates select="./gmd:lineage/gmd:LI_Lineage/gmd:source" mode="from19139to19115-3.2018"/>
          <xsl:apply-templates select="./gmd:lineage/gmd:LI_Lineage/gmd:processStep" mode="from19139to19115-3.2018"/>
        </mrl:LI_Lineage>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="gmd:DQ_DataQuality" mode="dataQualityScope">
    <xsl:variable name="dataQualityScopeObject" select="./gmd:scope/gmd:DQ_Scope"/>
    <mrl:scope>
      <mcc:MD_Scope>
        <xsl:choose>
        <xsl:when test="$dataQualityScopeObject//gmd:MD_ScopeCode/@codeListValue|
                        $dataQualityScopeObject//gmx:MX_ScopeCode/@codeListValue">
          <xsl:call-template name="writeCodelistElement">
            <xsl:with-param name="elementName" select="'mcc:level'"/>
            <xsl:with-param name="codeListName" select="'mcc:MD_ScopeCode'"/>
            <xsl:with-param name="codeListValue"
                            select="$dataQualityScopeObject//gmd:MD_ScopeCode/@codeListValue|
                                    $dataQualityScopeObject//gmx:MX_ScopeCode/@codeListValue"/>
            <xsl:with-param name="required" select="true()"/>
          </xsl:call-template>
        </xsl:when>
          <xsl:otherwise>
            <mcc:level />
          </xsl:otherwise>
        </xsl:choose>
        <xsl:for-each select="$dataQualityScopeObject//gmd:EX_Extent">
          <mcc:extent>
            <xsl:apply-templates select="." mode="from19139to19115-3.2018"/>
          </mcc:extent>
        </xsl:for-each>
        <xsl:for-each select="$dataQualityScopeObject//gmd:MD_ScopeDescription">
          <mcc:levelDescription>
            <mcc:MD_ScopeDescription>
              <xsl:apply-templates select="*" mode="from19139to19115-3.2018"/>
              <!--<xsl:call-template name="writeCharacterStringElement">
              <xsl:with-param name="elementName" select="'cit:other'"/>
              <xsl:with-param name="stringToWrite" select="gmd:statement"/>
            </xsl:call-template>-->
            </mcc:MD_ScopeDescription>
          </mcc:levelDescription>
        </xsl:for-each>
      </mcc:MD_Scope>
    </mrl:scope>
  </xsl:template>
  
</xsl:stylesheet>
