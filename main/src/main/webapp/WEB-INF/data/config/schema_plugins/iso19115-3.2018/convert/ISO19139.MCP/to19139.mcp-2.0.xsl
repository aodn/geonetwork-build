<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
						xmlns:gml="http://www.opengis.net/gml"
						xmlns:srv="http://www.isotc211.org/2005/srv"
						xmlns:gmx="http://www.isotc211.org/2005/gmx"
						xmlns:gco="http://www.isotc211.org/2005/gco"
						xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
						xmlns:xlink="http://www.w3.org/1999/xlink"
						xmlns:mcp="http://schemas.aodn.org.au/mcp-2.0"
						xmlns:mcp14="http://bluenet3.antcrc.utas.edu.au/mcp"
						xmlns:dwc="http://rs.tdwg.org/dwc/terms/"
						xmlns:gmd="http://www.isotc211.org/2005/gmd"
						exclude-result-prefixes="#all">

	<!-- ================================================================= -->
	<!-- XSLT to convert 19115/19139, MCP 1.3, 1.4 and 1.5-experimental records to
	     MCP 2.0                                                           -->
	<!-- TODO: Convert 1.5-experimental mcp:taxonomicExtent to 2.0
	                                                                       -->
	<!-- @author sppigot, April 2013                                       -->
	<!-- ================================================================= -->

	<xsl:variable name="metadataStandardName" select="'Australian Marine Community Profile of ISO 19115:2005/19139'"/>
	<xsl:variable name="metadataStandardVersion" select="'2.0'"/>
	<xsl:variable name="df">[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01]</xsl:variable>
	<xsl:variable name="now" select="format-dateTime(current-dateTime(),$df)"/>

	<!-- ================================================================= -->

	<xsl:template mode="mcp-1.4" match="mcp14:MD_Metadata|gmd:MD_Metadata" priority="100">
		<xsl:element name="mcp:MD_Metadata">
			<xsl:copy-of select="@*"/>
		 	<!-- only need to specify gmd, gmx, xlink, gml and dwc because mcp, gco
			     and xsi get added automagically because we are using their prefixes
					 in the definition of the new mcp:MD_Metadata element -->
		 	<xsl:namespace name="gmd" select="'http://www.isotc211.org/2005/gmd'"/>
		 	<xsl:namespace name="gmx" select="'http://www.isotc211.org/2005/gmx'"/>
		 	<xsl:namespace name="xlink" select="'http://www.w3.org/1999/xlink'"/>
		 	<xsl:namespace name="dwc" select="'http://rs.tdwg.org/dwc/terms/'"/>
			<xsl:namespace name="gml" select="'http://www.opengis.net/gml'"/>
			<xsl:attribute name="xsi:schemaLocation">http://schemas.aodn.org.au/mcp-2.0 http://schemas.aodn.org.au/mcp-2.0/schema.xsd http://www.isotc211.org/2005/srv http://schemas.opengis.net/iso/19139/20060504/srv/srv.xsd http://www.isotc211.org/2005/gmx http://www.isotc211.org/2005/gmx/gmx.xsd http://rs.tdwg.org/dwc/terms/ http://schemas.aodn.org.au/mcp-2.0/mcpDwcTerms.xsd</xsl:attribute>
			<xsl:attribute name="gco:isoType">gmd:MD_Metadata</xsl:attribute>
			<xsl:comment> Converted to MCP 2.0 on <xsl:value-of select="$now"/> </xsl:comment>
			<xsl:apply-templates mode="mcp-1.4" select="node()"/>
		</xsl:element>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template mode="mcp-1.4" match="gmd:metadataStandardName" priority="10">
		<xsl:copy copy-namespaces="no">
			<gco:CharacterString><xsl:value-of select="$metadataStandardName"/></gco:CharacterString>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template mode="mcp-1.4" match="gmd:metadataStandardVersion" priority="10">
		<xsl:copy copy-namespaces="no">
			<gco:CharacterString><xsl:value-of select="$metadataStandardVersion"/></gco:CharacterString>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template mode="mcp-1.4" match="mcp14:MD_DataCommons" priority="100">
		<mcp:MD_Commons mcp:commonsType="Data Commons" gco:isoType="gmd:MD_Constraints">
			<xsl:apply-templates mode="mcp-1.4" select="node()"/>
		</mcp:MD_Commons>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template mode="mcp-1.4" match="mcp14:MD_CreativeCommons" priority="100">
		<mcp:MD_Commons mcp:commonsType="Creative Commons" gco:isoType="gmd:MD_Constraints">
			<xsl:apply-templates mode="mcp-1.4" select="node()"/>
		</mcp:MD_Commons>
	</xsl:template>

	<!-- ================================================================= -->
	<!-- Map parameter name/units to term element                          -->
	<!-- ================================================================= -->

	<xsl:template mode="mcp-1.4" match="mcp14:DP_ParameterName|mcp14:DP_UnitsName" priority="100">
		<mcp:DP_Term>
			<mcp:term>
				<xsl:apply-templates mode="mcp-1.4" select="mcp14:name/*"/>
			</mcp:term>
			<xsl:apply-templates mode="mcp-1.4" select="mcp14:type"/>
			<xsl:apply-templates mode="mcp-1.4" select="mcp14:usedInDataset"/>
			<xsl:if test="mcp14:vocabularyListURL|mcp14:vocabularyListVersion|mcp14:vocabularyListAuthority">
				<mcp:vocabularyRelationship>
					<mcp:DP_VocabularyRelationship>
						<mcp:relationshipType>
							<mcp:DP_RelationshipTypeCode codeList="http://schemas.aodn.org.au/mcp-2.0/resources/Codelist/gmxCodelists.xml#DP_RelationshipTypeCode" codeListValue="skos:exactmatch">skos:exactmatch</mcp:DP_RelationshipTypeCode>
						</mcp:relationshipType>
						<mcp:vocabularyTermURL><gmd:URL/></mcp:vocabularyTermURL> <!-- not available in 1.4/1.5 -->
						<xsl:apply-templates mode="mcp-1.4" select="mcp14:vocabularyListURL"/>
						<xsl:apply-templates mode="mcp-1.4" select="mcp14:vocabularyListVersion"/>
						<xsl:apply-templates mode="mcp-1.4" select="mcp14:vocabularyListAuthority"/>
					</mcp:DP_VocabularyRelationship>
				</mcp:vocabularyRelationship>
			</xsl:if>
			<xsl:apply-templates mode="mcp-1.4" select="mcp14:localDefinition"/>
		</mcp:DP_Term>
	</xsl:template>

	<!-- ================================================================= -->
  <!-- Any node in the old mcp namespace not covered by a specific       -->
	<!-- template above will be converted to the new mcp namespace         -->
  <!-- ================================================================= -->

	<xsl:template mode="mcp-1.4" match="*[namespace-uri()='http://bluenet3.antcrc.utas.edu.au/mcp']" priority="10">
		<xsl:element name="mcp:{local-name()}">
			<xsl:copy-of select="@*"/>
			<xsl:if test="@codeList">
      	<xsl:attribute name="codeList">
        	<xsl:value-of select="concat('http://schemas.aodn.org.au/mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#',local-name(.))"/>
      	</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="mcp-1.4" select="node()"/>
		</xsl:element>
	</xsl:template>

	<!-- ================================================================= -->
  <!-- codelists: set @codeList path -->
  <!-- ================================================================= -->

  <xsl:template mode="mcp-1.4" match="*[@codeListValue]">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates mode="mcp-1.4" select="@*"/>
      <xsl:attribute name="codeList">
        <xsl:value-of select="concat('http://schemas.aodn.org.au/mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#',local-name(.))"/>
      </xsl:attribute>
      <xsl:value-of select="@codeListValue"/>
    </xsl:copy>
  </xsl:template>

	<!-- ================================================================= -->

	<xsl:template mode="mcp-1.4" match="@*|node()">
		 <xsl:copy copy-namespaces="no">
			  <xsl:apply-templates mode="mcp-1.4" select="@*|node()"/>
		 </xsl:copy>
	</xsl:template>

</xsl:stylesheet>
