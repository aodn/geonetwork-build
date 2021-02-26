<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gcoold="http://www.isotc211.org/2005/gco"
                xmlns:gmi="http://www.isotc211.org/2005/gmi"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gsr="http://www.isotc211.org/2005/gsr"
                xmlns:gss="http://www.isotc211.org/2005/gss"
                xmlns:gts="http://www.isotc211.org/2005/gts"
                xmlns:srvold="http://www.isotc211.org/2005/srv"
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
                xmlns:mda="http://standards.iso.org/iso/19115/-3/mda/1.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mdt="http://standards.iso.org/iso/19115/-3/mdt/1.0"
                xmlns:mex="http://standards.iso.org/iso/19115/-3/mex/1.0"
                xmlns:mic="http://standards.iso.org/iso/19115/-3/mic/1.0"
                xmlns:mil="http://standards.iso.org/iso/19115/-3/mil/1.0"
                xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/2.0"
                xmlns:mds="http://standards.iso.org/iso/19115/-3/mds/1.0"
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
                xmlns:mcp20="http://schemas.aodn.org.au/mcp-2.0"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                exclude-result-prefixes="#all">

  <xsl:param name="dataParamsConfig"/>

  <xsl:variable name="excludedParameters" select="document($dataParamsConfig)/config/excludedParameters"/>

  <xsl:template match="mcp20:dataParameters" mode="from19139to19115-3.2018">
    <mdb:contentInfo>
      <mrc:MD_CoverageDescription>
        <mrc:attributeDescription gco:nilReason="inapplicable"/>
        <mrc:attributeGroup>
          <mrc:MD_AttributeGroup>
            <mrc:contentType>
              <mrc:MD_CoverageContentTypeCode codeList='http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#MD_CoverageContentTypeCode' codeListValue='physicalMeasurement'/>
            </mrc:contentType>
            <xsl:for-each-group select="mcp20:DP_DataParameters/mcp20:dataParameter/mcp20:DP_DataParameter"
                                group-by="(mcp20:parameterName/*[mcp20:type/*/@codeListValue='longName']|mcp20:parameterName/*[mcp20:type/*/@codeListValue='shortName'])[1]/mcp20:term/*/text()">
              <xsl:variable name="dataParameter" select="current-group()[1]"/>
              <xsl:variable name="longName" select="$dataParameter/mcp20:parameterName[*/*/mcp20:DP_TypeCode/@codeListValue='longName']"/>

              <xsl:if test="not($excludedParameters/term[text()=$longName/*/mcp20:term/*/text()])">     <!-- can't be an excluded parameter -->
                <mrc:attribute>
                  <mrc:MD_SampleDimension>
                    <xsl:choose>
                      <xsl:when test="$dataParameter/mcp20:parameterDescription/@*[local-name()='nilReason']">
                        <xsl:element name="mrc:description">
                          <xsl:attribute name="gco:nilReason" select="$dataParameter/mcp20:parameterDescription/@*[local-name()='nilReason']"/>
                          <gco:CharacterString/>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="$dataParameter/mcp20:parameterDescription">
                        <mrc:description>
                          <gco:CharacterString>
                            <xsl:value-of select="$dataParameter/mcp20:parameterDescription"/>
                          </gco:CharacterString>
                        </mrc:description>
                      </xsl:when>
                    </xsl:choose>
                    <xsl:for-each select="$dataParameter/mcp20:parameterName/mcp20:DP_Term">
                      <mrc:name>
                        <mcc:MD_Identifier>
                          <mcc:code>
                            <xsl:choose>
                              <xsl:when test="mcp20:vocabularyTermURL/gmd:URL">
                                <gcx:Anchor xlink:href="{mcp20:vocabularyTermURL/gmd:URL}">
                                  <xsl:value-of select="mcp20:term/*/text()"/>
                                </gcx:Anchor>
                              </xsl:when>
                              <xsl:otherwise>
                                <gco:CharacterString>
                                  <xsl:value-of select="mcp20:term/*/text()"/>
                                </gco:CharacterString>
                              </xsl:otherwise>
                            </xsl:choose>
                          </mcc:code>
                          <xsl:choose>
                            <xsl:when test=".//mcp20:vocabularyListURL/gmd:URL">
                              <mcc:codeSpace>
                                <gco:CharacterString>
                                  <xsl:value-of select=".//mcp20:vocabularyListURL/gmd:URL"/>
                                </gco:CharacterString>
                              </mcc:codeSpace>
                            </xsl:when>
                          </xsl:choose>
                          <xsl:if test="mcp20:termDefinition">
                            <mcc:description>
                              <gco:CharacterString>
                                <xsl:value-of select="mcp20:termDefinition"/>
                              </gco:CharacterString>
                            </mcc:description>
                          </xsl:if>
                        </mcc:MD_Identifier>
                      </mrc:name>
                    </xsl:for-each>
                    <xsl:if test="string(number($dataParameter/mcp20:parameterMaximumValue/*)) != 'NaN'">
                      <mrc:maxValue>
                        <gco:Real><xsl:value-of select="$dataParameter/mcp20:parameterMaximumValue/*"/></gco:Real>
                      </mrc:maxValue>
                    </xsl:if>
                    <xsl:if test="string(number($dataParameter/mcp20:parameterMinimumValue/*)) != 'NaN'">
                      <mrc:minValue>
                        <gco:Real><xsl:value-of select="$dataParameter/mcp20:parameterMinimumValue/*"/></gco:Real>
                      </mrc:minValue>
                    </xsl:if>
                    <mrc:units>
                      <gml:BaseUnit gml:id="{generate-id()}">
                        <xsl:choose>
                          <xsl:when test="$dataParameter/mcp20:parameterUnits/mcp20:DP_Term/mcp20:vocabularyTermURL/gmd:URL">
                            <xsl:choose>
                              <xsl:when test="$dataParameter/mcp20:parameterUnits/mcp20:DP_Term/mcp20:vocabularyListURL/gmd:URL">
                                <gml:identifier codeSpace="{$dataParameter/mcp20:parameterUnits/mcp20:DP_Term/mcp20:vocabularyListURL/gmd:URL}">
                                  <xsl:value-of select="$dataParameter/mcp20:parameterUnits/mcp20:DP_Term/mcp20:vocabularyTermURL/gmd:URL"/>
                                </gml:identifier>
                              </xsl:when>
                              <xsl:otherwise>
                                <gml:identifier codeSpace="unknown">
                                  <xsl:value-of select="$dataParameter/mcp20:parameterUnits/mcp20:DP_Term/mcp20:vocabularyTermURL/gmd:URL"/>
                                </gml:identifier>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:when>
                          <xsl:otherwise>
                            <gml:identifier codeSpace="unknown"/>
                          </xsl:otherwise>
                        </xsl:choose>
                        <gml:name>
                          <xsl:value-of select="$dataParameter/mcp20:parameterUnits/mcp20:DP_Term/mcp20:term"/>
                        </gml:name>
                        <gml:unitsSystem/>
                      </gml:BaseUnit>
                    </mrc:units>
                  </mrc:MD_SampleDimension>
                </mrc:attribute>
              </xsl:if>
            </xsl:for-each-group>
          </mrc:MD_AttributeGroup>
        </mrc:attributeGroup>
      </mrc:MD_CoverageDescription>
    </mdb:contentInfo>
  </xsl:template>

  <xsl:template match="mcp20:dataParameters" mode="from19139to19115-3.2018-acquisition">
      <!-- platforms and there instruments -->
      <xsl:for-each-group select="./mcp20:DP_DataParameters/mcp20:dataParameter/mcp20:DP_DataParameter"
                          group-by="./mcp20:platform/*/mcp20:term/*/text()">
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
              <mac:platform>
                <mac:MI_Platform>
                  <mac:identifier>
                    <mcc:MD_Identifier>
                      <mcc:code>
                        <gcx:Anchor xlink:href="{current-group()[1]/mcp20:platform/mcp20:DP_Term/mcp20:vocabularyTermURL/gmd:URL}">
                          <xsl:value-of select="current-group()[1]/mcp20:platform/mcp20:DP_Term/mcp20:term"/>
                        </gcx:Anchor>
                      </mcc:code>
                    </mcc:MD_Identifier>
                  </mac:identifier>
                  <mac:description gco:nilReason="missing"/>
                  <xsl:choose>
                    <xsl:when test="current-group()/mcp20:parameterDeterminationInstrument">
                      <xsl:for-each-group
                              select="current-group()/mcp20:parameterDeterminationInstrument"
                              group-by="*/mcp20:term/*/text()">
                        <mac:instrument>
                          <mac:MI_Instrument>
                            <mac:identifier>
                              <mcc:MD_Identifier>
                                <mcc:code>
                                  <gcx:Anchor xlink:href="{current-group()[1]/*/mcp20:vocabularyTermURL/*/text()}">
                                    <xsl:value-of select="current-grouping-key()"/>
                                  </gcx:Anchor>
                                </mcc:code>
                              </mcc:MD_Identifier>
                            </mac:identifier>
                            <mac:type gco:nilReason="missing">
                              <gco:CharacterString/>
                            </mac:type>
                          </mac:MI_Instrument>
                        </mac:instrument>
                      </xsl:for-each-group>
                    </xsl:when>
                    <xsl:otherwise>
                      <mac:instrument gco:nilReason="missing"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </mac:MI_Platform>
              </mac:platform>
          </mac:MI_AcquisitionInformation>
        </mdb:acquisitionInformation>
      </xsl:for-each-group>
      <!-- instruments without platforms -->
      <xsl:for-each-group
              select="//mcp20:dataParameters/*/*/mcp20:DP_DataParameter[normalize-space(mcp20:platform/*/mcp20:term/*/text())='']"
              group-by="mcp20:parameterDeterminationInstrument/*/mcp20:term/*/text()">
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
              <mac:instrument>
                <mac:MI_Instrument>
                  <mac:identifier>
                    <mcc:MD_Identifier>
                      <mcc:code>
                        <gcx:Anchor xlink:href="{current-group()[1]/mcp20:parameterDeterminationInstrument/*/mcp20:vocabularyTermURL/*/text()}">
                          <xsl:value-of select="current-grouping-key()"/>
                        </gcx:Anchor>
                      </mcc:code>
                    </mcc:MD_Identifier>
                  </mac:identifier>
                  <mac:type gco:nilReason="missing">
                    <gco:CharacterString/>
                  </mac:type>
                </mac:MI_Instrument>
              </mac:instrument>
          </mac:MI_AcquisitionInformation>
        </mdb:acquisitionInformation>
      </xsl:for-each-group>
  </xsl:template>
</xsl:stylesheet>
