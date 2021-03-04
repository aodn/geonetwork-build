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

  <!-- Use mri instead of mdb when namespacing elements - mcp uses mri elements -->
      
  <xsl:template name="getNamespacePrefix">
    <!-- this template determines the correct namespace prefix depending on the position of the element in the new XML -->
    <xsl:variable name="prefix">
      <xsl:choose>
        <xsl:when test="name()='gmi:MI_Metadata'">
          <xsl:text>mdb</xsl:text>
        </xsl:when>
        <xsl:when test="starts-with(name(),'gmx:')">
          <xsl:text>gcx</xsl:text>
        </xsl:when>
        <xsl:when test="starts-with(name(),'gco:')">
          <xsl:text>gco</xsl:text>
        </xsl:when>
        <xsl:when test="starts-with(name(),'gml:')">
          <xsl:text>gml</xsl:text>
        </xsl:when>
        <xsl:when test="starts-with(name(),'gts:')">
          <xsl:text>gco</xsl:text>
        </xsl:when>
        <xsl:when test="starts-with(name(),'srv:') and not(name()='srv:extent')">
          <xsl:text>srv</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor-or-self::gmd:PT_FreeText">
          <xsl:text>lan</xsl:text>
        </xsl:when>
        <xsl:when
          test="starts-with(name(),'gmi:') and not(ancestor-or-self::gmi:MI_AcquisitionInformation)
          and not(ancestor-or-self::gmi:QE_CoverageResult) and not(ancestor-or-self::gmi:LE_ProcessStep)
          and not(ancestor-or-self::gmi:LE_Source) and not(ancestor-or-self::gmi:MI_CoverageDescription)">
          <xsl:text>msr</xsl:text>
        </xsl:when>
        <xsl:when test="starts-with(name(),'gmi:') and 
          (ancestor-or-self::gmi:LE_ProcessStep or ancestor-or-self::gmi:LE_Source)">
          <xsl:text>mrl</xsl:text>
        </xsl:when>
        <xsl:when test="starts-with(name(),'gmi:') and (ancestor-or-self::gmi:MI_CoverageDescription)">
          <xsl:text>mrc</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor-or-self::gmd:MD_Constraints
          or ancestor-or-self::gmd:MD_SecurityConstraints 
          or ancestor-or-self::gmd:MD_LegalConstraints
          ">
          <xsl:text>mco</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor-or-self::gmd:MD_BrowseGraphic">
          <xsl:text>mcc</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor-or-self::gmd:CI_ResponsibleParty or ancestor-or-self::gmd:CI_OnlineResource">
          <xsl:text>cit</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor-or-self::gmd:MD_ScopeCode or ancestor-or-self::gmx:MX_ScopeCode 
          or ancestor-or-self::gmd:MD_ScopeDescription">
          <xsl:text>mcc</xsl:text>
        </xsl:when>
        <xsl:when test="parent::gmd:MD_Identifier or self::gmd:MD_Identifier or parent::gmd:RS_Identifier or self::gmd:RS_Identifier">
          <xsl:text>mcc</xsl:text>
        </xsl:when>
        <!--
          Changed 2013-03-06 to fix PresentationFormCode <xsl:when test="parent::gmd:CI_Citation or self::gmd:CI_Citation">-->
        <xsl:when test="ancestor-or-self::gmd:CI_Citation">
          <xsl:text>cit</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor-or-self::gmd:MD_ApplicationSchemaInformation">
          <xsl:text>mas</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor-or-self::gmi:MI_AcquisitionInformation">
          <xsl:text>mac</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor-or-self::gmd:MD_PortrayalCatalogueReference">
          <xsl:text>mpc</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor-or-self::gmd:MD_SpatialRepresentationTypeCode">
          <xsl:text>mcc</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor-or-self::gmd:MD_ReferenceSystem">
          <xsl:text>mrs</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor-or-self::gmd:MD_MetadataExtensionInformation">
          <xsl:text>mex</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor-or-self::gmd:EX_Extent">
          <xsl:text>gex</xsl:text>
        </xsl:when>
        <xsl:when
          test="ancestor-or-self::gmd:MD_Georectified or ancestor-or-self::gmi:MI_Georectified
          or ancestor-or-self::gmd:MD_Georeferenceable or ancestor-or-self::gmi:MI_Georeferenceable
          or ancestor-or-self::gmd:MD_GridSpatialRepresentation or ancestor-or-self::gmd:MD_ReferenceSystem
          or name()=gmi:MI_Metadata">
          <xsl:text>msr</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor-or-self::gmd:DQ_Scope">
          <xsl:text>mcc</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor-or-self::gmd:MD_Distribution or ancestor-or-self::gmd:MD_Format">
          <xsl:text>mrd</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor-or-self::gmd:MD_Resolution or ancestor-or-self::gmd:MD_RepresentativeFraction or ancestor-or-self::gmd:MD_VectorSpatialRepresentation">
          <xsl:text>mri</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor-or-self::gmd:MD_MaintenanceInformation">
          <xsl:text>mmi</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor-or-self::gmd:MD_DataIdentification or ancestor-or-self::srvold:SV_ServiceIdentification">
          <!-- or ancestor-or-self::gmd:MD_SpatialRepresentationTypeCode"> this test is not necessary -->
          <xsl:text>mri</xsl:text>
        </xsl:when>
        <xsl:when
          test="ancestor-or-self::gmd:MD_CoverageDescription or ancestor-or-self::gmi:MI_CoverageDescription
          or ancestor-or-self::gmd:MD_FeatureCatalogueDescription or ancestor-or-self::gmd:MD_ImageDescription">
          <xsl:text>mrc</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor-or-self::gmi:QE_CoverageResult">
          <xsl:text>mdq</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor-or-self::gmd:LI_Lineage">
          <xsl:text>mrl</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor-or-self::gmd:DQ_DataQuality">
          <xsl:text>mdq</xsl:text>
        </xsl:when>
        <xsl:when test="parent::gmi:MI_Metadata">
          <xsl:text>mdb</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor-or-self::mcp20:MD_DataIdentification">
          <xsl:text>mri</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>mdb</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$prefix"/>
  </xsl:template>
  
  <!-- Core fix - replace gml30:uom with uom on gml30:CoordinateSystemAxis -->

  <xsl:template match="gml30:CoordinateSystemAxis[@gml30:uom!='']" mode="from19139to19115-3.2018" priority="50">
    <xsl:element name="gml:{local-name(.)}" namespace="http://www.opengis.net/gml/3.2">
      <xsl:apply-templates select="@*[local-name()!='uom']" mode="from19139to19115-3.2018"/>
      <xsl:attribute name="uom"><xsl:value-of select="@gml30:uom"/></xsl:attribute>
      <xsl:apply-templates mode="from19139to19115-3.2018"/>
    </xsl:element>
  </xsl:template>

  <!-- Core fix - use gml prefix on gml elements -->
  
  <xsl:template match="gml30:*|gml:*" mode="from19139to19115-3.2018">
    <xsl:element name="gml:{local-name(.)}" namespace="http://www.opengis.net/gml/3.2">
      <xsl:apply-templates select="@*" mode="from19139to19115-3.2018"/>
      <xsl:apply-templates mode="from19139to19115-3.2018"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
