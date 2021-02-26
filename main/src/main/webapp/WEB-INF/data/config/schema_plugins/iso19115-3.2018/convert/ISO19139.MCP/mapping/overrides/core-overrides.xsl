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
  
  <xsl:variable name="associatedResourceAsMetadataReferenceOnly" select="false()"/>

  <!-- Override core gmd:identification mapping so we can include sections required for data parameters -->
  
  <xsl:template match="gmd:identificationInfo" mode="from19139to19115-3.2018">
    <mdb:identificationInfo>
      <xsl:apply-templates select="@*" mode="from19139to19115-3.2018"/>
      <xsl:for-each select="./*">
        <xsl:variable name="nameSpacePrefix">
          <xsl:call-template name="getNamespacePrefix"/>
        </xsl:variable>
        <xsl:element name="{concat($nameSpacePrefix,':',local-name(.))}">
          <xsl:apply-templates select="@*[local-name()!='isoType']" mode="from19139to19115-3.2018"/>
          <xsl:apply-templates select="gmd:citation" mode="from19139to19115-3.2018"/>
          <xsl:call-template name="writeCharacterStringElement">
            <xsl:with-param name="elementName" select="'mri:abstract'"/>
            <xsl:with-param name="nodeWithStringToWrite" select="gmd:abstract"/>
          </xsl:call-template>
          <xsl:call-template name="writeCharacterStringElement">
            <xsl:with-param name="elementName" select="'mri:purpose'"/>
            <xsl:with-param name="nodeWithStringToWrite" select="gmd:purpose"/>
          </xsl:call-template>
          <xsl:for-each select="gmd:credit">
            <xsl:call-template name="writeCharacterStringElement">
              <xsl:with-param name="elementName" select="'mri:credit'"/>
              <xsl:with-param name="nodeWithStringToWrite" select="."/>
            </xsl:call-template>
          </xsl:for-each>
            <xsl:call-template name="writeCodelistElement">
              <xsl:with-param name="elementName" select="'mri:status'"/>
              <xsl:with-param name="codeListValue" select="gmd:status/gmd:MD_ProgressCode/@codeListValue"/>
              <xsl:with-param name="codeListName" select="'mcc:MD_ProgressCode'"/>
            </xsl:call-template>
          <xsl:apply-templates select="gmd:pointOfContact" mode="from19139to19115-3.2018"/>
          <xsl:apply-templates select="mcp20:resourceContactInfo" mode="from19139to19115-3.2018"/>
            <xsl:call-template name="writeCodelistElement">
              <xsl:with-param name="elementName" select="'mri:spatialRepresentationType'"/>
              <xsl:with-param name="codeListName" select="'mcc:MD_SpatialRepresentationTypeCode'"/>
              <xsl:with-param name="codeListValue" select="gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue"/>
            </xsl:call-template>
          <xsl:apply-templates select="gmd:spatialResolution" mode="from19139to19115-3.2018"/>
          <!-- This is here to handle early adopters of temporalResolution -->
          <xsl:apply-templates select="gmd:temporalResolution" mode="from19139to19115-3.2018"/>
          <xsl:apply-templates select="mcp20:samplingFrequency" mode="mcpsamplingfrequency"/>
          <xsl:apply-templates select="gmd:topicCategory" mode="from19139to19115-3.2018"/>
          <xsl:apply-templates select="gmd:extent[not(child::mcp20:EX_Extent)] | srvold:extent" mode="from19139to19115-3.2018"/>
          <xsl:apply-templates select="gmd:extent[child::mcp20:EX_Extent]" mode="mcpextent"/>
          <!-- map aggregationInfo to additionalDocumentation -->
          <xsl:message><xsl:value-of select="concat('SSSS ',$mapAggregationInfoToAdditionalDocumentation)"/></xsl:message>
          <xsl:if test="$mapAggregationInfoToAdditionalDocumentation">
            <xsl:apply-templates select="gmd:aggregationInfo" mode="mcpto19115-3"/>
          </xsl:if>
          <xsl:apply-templates select="gmd:resourceMaintenance" mode="from19139to19115-3.2018"/>
          <xsl:apply-templates select="gmd:graphicOverview" mode="from19139to19115-3.2018"/>
          <xsl:apply-templates select="gmd:resourceFormat" mode="from19139to19115-3.2018"/>
          <xsl:apply-templates select="gmd:descriptiveKeywords" mode="from19139to19115-3.2018"/>
          <xsl:apply-templates select="mcp20:dataParameters" mode="from19139to19115-3.2018-aodn"/>
          <xsl:apply-templates select="gmd:resourceSpecificUsage" mode="from19139to19115-3.2018"/>
          <xsl:apply-templates select="gmd:resourceConstraints[not(mcp20:MD_Commons)]" mode="from19139to19115-3.2018"/>
          <xsl:apply-templates select="gmd:resourceConstraints[mcp20:MD_Commons]" mode="mcpcommons"/>
          <xsl:if test="not($mapAggregationInfoToAdditionalDocumentation)">
            <xsl:apply-templates select="gmd:aggregationInfo" mode="from19139to19115-3.2018"/>
          </xsl:if>
          <xsl:call-template name="collectiveTitle"/>
          <xsl:apply-templates select="gmd:language" mode="from19139to19115-3.2018"/>
          <xsl:apply-templates select="gmd:characterSet" mode="from19139to19115-3.2018"/>
          <xsl:call-template name="writeCharacterStringElement">
            <xsl:with-param name="elementName" select="'mri:environmentDescription'"/>
            <xsl:with-param name="nodeWithStringToWrite" select="gmd:environmentDescription"/>
          </xsl:call-template>
          <xsl:call-template name="writeCharacterStringElement">
            <xsl:with-param name="elementName" select="'mri:supplementalInformation'"/>
            <xsl:with-param name="nodeWithStringToWrite" select="gmd:supplementalInformation"/>
          </xsl:call-template>
          <!-- Service Identification Information -->
          <xsl:if test="local-name()='SV_ServiceIdentification'">
            <xsl:if test="srvold:serviceType">
              <srv:serviceType>
                <gco:ScopedName>
                  <xsl:value-of select="srvold:serviceType/gcoold:LocalName"/>
                </gco:ScopedName>
              </srv:serviceType>
            </xsl:if>
            <xsl:call-template name="writeCharacterStringElement">
              <xsl:with-param name="elementName" select="'srv:serviceTypeVersion'"/>
              <xsl:with-param name="nodeWithStringToWrite" select="srvold:serviceTypeVersion"/>
            </xsl:call-template>
            <xsl:call-template name="writeCodelistElement">
              <xsl:with-param name="elementName" select="'srv:couplingType'"/>
              <xsl:with-param name="codeListName" select="'srv:SV_CouplingType'"/>
              <xsl:with-param name="codeListValue" select="srvold:couplingType/srvold:SV_CouplingType/@codeListValue"/>
            </xsl:call-template>
            <xsl:apply-templates select="srvold:containsOperations" mode="from19139to19115-3.2018"/>
            <xsl:apply-templates select="srvold:operatesOn" mode="from19139to19115-3.2018"/>
          </xsl:if>
        </xsl:element>
      </xsl:for-each>
    </mdb:identificationInfo>
  </xsl:template>

  <!-- Core fix - avoid putting out empty citedResponsibleParties for just onlineResources (responsible parties without names) -->

  <xsl:template match="/*/gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty" mode="from19139to19115-3.2018">
    <xsl:if
      test="count(gmd:CI_ResponsibleParty/gmd:individualName/gcoold:CharacterString) + count(gmd:CI_ResponsibleParty/gmd:organisationName/gcoold:CharacterString) + count(gmd:CI_ResponsibleParty/gmd:positionName/gcoold:CharacterString) != 0">
      <cit:citedResponsibleParty>
        <xsl:apply-templates mode="from19139to19115-3.2018"/>
      </cit:citedResponsibleParty>
    </xsl:if>
  </xsl:template>

  <!-- Fix core issue where aggregateDataSetIdentifier is dropped if there is no citedResponsibleParty -->
   
  <xsl:template match="gmd:aggregationInfo/gmd:MD_AggregateInformation/gmd:aggregateDataSetName/gmd:CI_Citation/gmd:citedResponsibleParty" mode="from19139to19115-3.2018">
    <xsl:if test="not(preceding-sibling::gmd:citedResponsibleParty) and ancestor::gmd:MD_AggregateInformation/gmd:aggregateDataSetIdentifier">
      <!-- **********************************************************************
      The first citedResponsibleParty is special because the identifier
      from the gmd:aggregateDataSetIdentifier goes before it.
      ********************************************************************** -->
      <cit:identifier>
        <xsl:apply-templates select="ancestor::gmd:MD_AggregateInformation/gmd:aggregateDataSetIdentifier/gmd:MD_Identifier" mode="from19139to19115-3.2018"/>
      </cit:identifier>
    </xsl:if>
    <xsl:if test="gmd:CI_ResponsibleParty[count(gmd:individualName/gcoold:CharacterString) + count(gmd:organisationName/gcoold:CharacterString) + count(gmd:positionName/gcoold:CharacterString) > 0]">
      <cit:citedResponsibleParty>
        <xsl:apply-templates mode="from19139to19115-3.2018"/>
      </cit:citedResponsibleParty>
    </xsl:if>
  </xsl:template>
  
  <!-- Fix core issue with records not validating because Association type code with nilReason being dropped -->

  <xsl:template match="gmd:aggregationInfo" priority="5" mode="from19139to19115-3.2018">
    <!--
   gmd:MD_AggregateInformation was renamed gmd:associatedResource in order
	 to clarify the intent of the class. It is used to provide information about
	 resources that are associated with the resource being described.
    -->
    <mri:associatedResource>
      <xsl:element name="mri:MD_AssociatedResource">
        <xsl:copy-of select="gmd:MD_AggregateInformation/@*"/>
        <!-- The name element is mapped from the existing gmd:aggregateDataSetName class.
					 The metadataReference replaces the gmd:aggregateDataSetIdentifier in order to
					 clarify the fact that it identifies and gives the location of the metadata
					 for the associated resources. -->

        <xsl:if test="not($associatedResourceAsMetadataReferenceOnly)">
          <xsl:choose>
            <xsl:when test="exists(gmd:MD_AggregateInformation/gmd:aggregateDataSetName)
              and exists(gmd:MD_AggregateInformation/gmd:aggregateDataSetIdentifier)">
              <!-- both name an identifier exist - use standard template -->
              <mri:name>
                <xsl:apply-templates select="gmd:MD_AggregateInformation/gmd:aggregateDataSetName/gmd:CI_Citation" mode="from19139to19115-3.2018"/>
              </mri:name>
            </xsl:when>
            <xsl:when test="exists(gmd:MD_AggregateInformation/gmd:aggregateDataSetName)">
              <!-- only an name exists - write it into a CI_Citation -->
              <mri:name>
                <xsl:apply-templates select="gmd:MD_AggregateInformation/gmd:aggregateDataSetName/gmd:CI_Citation" mode="from19139to19115-3.2018"/>
              </mri:name>
            </xsl:when>
            <xsl:when test="exists(gmd:MD_AggregateInformation/gmd:aggregateDataSetIdentifier)">
              <!-- only an identifier exists - write it into a CI_Citation -->
              <mri:name>
                <cit:CI_Citation>
                  <!-- No citation title or date exists -->
                  <cit:title gco:nilReason="unknown"/>
                  <cit:date gco:nilReason="unknown"/>
                  <cit:identifier>
                    <xsl:apply-templates select="gmd:MD_AggregateInformation/gmd:aggregateDataSetIdentifier/gmd:MD_Identifier" mode="from19139to19115-3.2018"/>
                  </cit:identifier>
                </cit:CI_Citation>
              </mri:name>
            </xsl:when>
          </xsl:choose>
        </xsl:if>

        <xsl:call-template name="writeCodelistElement">
          <xsl:with-param name="elementName" select="'mri:associationType'"/>
          <xsl:with-param name="codeListName" select="'mri:DS_AssociationTypeCode'"/>
          <xsl:with-param name="codeListValue" select="gmd:MD_AggregateInformation/gmd:associationType/gmd:DS_AssociationTypeCode/@codeListValue"/>
          <xsl:with-param name="required" select="true()"/>
        </xsl:call-template>
        <xsl:call-template name="writeCodelistElement">
          <xsl:with-param name="elementName" select="'mri:initiativeType'"/>
          <xsl:with-param name="codeListName" select="'mri:DS_InitiativeTypeCode'"/>
          <xsl:with-param name="codeListValue" select="gmd:MD_AggregateInformation/gmd:initiativeType/gmd:DS_InitiativeTypeCode/@codeListValue"/>
        </xsl:call-template>

        <xsl:if test="$associatedResourceAsMetadataReferenceOnly">
          <mri:metadataReference uuidref="{gmd:MD_AggregateInformation/gmd:aggregateDataSetIdentifier/*/gmd:code/*/text()}"/>
        </xsl:if>

      </xsl:element>
    </mri:associatedResource>
  </xsl:template>

  <!-- Handle gmx scope codes used in some mcp records -->
  <!-- Core fix - copy nilReason for name -->

  <xsl:template match="gmd:hierarchyLevel" priority="5" mode="from19139to19115-3.2018">
    <!-- ************************************************************************ -->
    <!-- gmd:hierarchyLevel and gmd:hierarchyLevelName are combined into a
			   new class: MD_MetadataScope to avoid ambiguity when there are multiple elements. -->
    <!-- ************************************************************************ -->
    <mdb:metadataScope>
      <mdb:MD_MetadataScope>
        <xsl:choose>
          <xsl:when test="gmd:MD_ScopeCode[@codeListValue = 'publication'] |
                                  gmx:MX_ScopeCode[@codeListValue = 'publication']">
            <xsl:call-template name="writeCodelistElement">
              <xsl:with-param name="elementName" select="'mdb:resourceScope'"/>
              <xsl:with-param name="codeListName" select="'mcc:MD_ScopeCode'"/>
              <xsl:with-param name="codeListValue" select="'document'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="writeCodelistElement">
              <xsl:with-param name="elementName" select="'mdb:resourceScope'"/>
              <xsl:with-param name="codeListName" select="'mcc:MD_ScopeCode'"/>
              <xsl:with-param name="codeListValue" select="gmd:MD_ScopeCode/@codeListValue|
                                  gmx:MX_ScopeCode/@codeListValue"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="../gmd:hierarchyLevelName/@*[local-name()='nilReason']">
            <mdb:name>
              <xsl:attribute name="gco:nilReason" select="../gmd:hierarchyLevelName/@*[local-name()='nilReason']"/>
              <gco:CharacterString/>
            </mdb:name>
          </xsl:when>
          <xsl:otherwise>
            <mdb:name>
              <gco:CharacterString>
                <xsl:value-of select="../gmd:hierarchyLevelName/gcoold:CharacterString"/>
              </gco:CharacterString>
            </mdb:name>
          </xsl:otherwise>
        </xsl:choose>
      </mdb:MD_MetadataScope>
    </mdb:metadataScope>
  </xsl:template>
  
  <!-- remove point of truth from distribution section -->

  <xsl:template match="gmd:onLine[descendant::gmd:protocol[gcoold:CharacterString='WWW:LINK-1.0-http--metadata-URL']]" priority="5" mode="from19139to19115-3.2018"/>

  <!-- map md commons metadata constraints -->
  
  <xsl:template match="gmd:metadataConstraints[mcp20:MD_Commons]" mode="from19139to19115-3.2018">
    <xsl:apply-templates select="." mode="mcpcommons"/>
  </xsl:template>
  
</xsl:stylesheet>
