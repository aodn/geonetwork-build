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
  
    <!-- Fix core handling of codeLists - codelist location depends on element being added -->
    <!-- Add option to specify codelist is required so code list with a nilReason is added if not present -->
    
    <xsl:template name="writeCodelistElement">
        <xsl:param name="elementName"/>
        <xsl:param name="codeListName"/>
        <xsl:param name="codeListValue"/>
        <xsl:param name="required" select="false()"/>

        <xsl:variable name="localName" select="substring-after($codeListName, ':')"/>
        
        <!-- Codelist location depends on element code list applies to -->
        
        <xsl:variable name="codeListLocation">
          <xsl:choose>
            <xsl:when test="$codeListName = 'lan:LanguageCode'">
              <xsl:value-of select="'http://www.loc.gov/standards/iso639-2/'"/>
            </xsl:when>
            <xsl:when test="starts-with($codeListName, 'dqm:')">
              <xsl:value-of select="concat('http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#', $localName)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('http://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#', $localName)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="string-length($codeListValue) > 0">
            <xsl:element name="{$elementName}">
              <xsl:element name="{$codeListName}">
                <xsl:attribute name="codeList" select="$codeListLocation"/>
                <xsl:attribute name="codeListValue">
                  <!-- the anyValidURI value is used for testing with paths -->
                  <!--<xsl:value-of select="'anyValidURI'"/>-->
                  <!-- commented out for testing -->
                  <xsl:value-of select="$codeListValue"/>
                </xsl:attribute>
                <xsl:value-of select="$codeListValue"/>
              </xsl:element>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$required">
              <xsl:element name="{$elementName}">
                <xsl:attribute name="gco:nilReason">missing</xsl:attribute>
              </xsl:element>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
