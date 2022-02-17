<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:tr="java:org.fao.geonet.api.records.formatters.SchemaLocalizations"
                version="2.0"
                extension-element-prefixes="saxon"
                exclude-result-prefixes="#all">

  <!-- Default to xsl-view behaviour when not overridden here -->

  <xsl:import href="../xsl-view/view.xsl"/>

  <!-- Render units -->

  <xsl:template mode="render-field"
                match="gml:identifier[. != '']|gml:name[. != '']">
    <xsl:param name="fieldName" select="''" as="xs:string"/>

    <xsl:variable name="elementName" select="name(.)"/>
    <dl>
      <dt>
        <xsl:value-of select="if ($fieldName)
                                then $fieldName
                                else tr:node-label(tr:create($schema), $elementName, null)"/>
      </dt>
      <dd>
        <xsl:choose>
          <!-- Display the value for simple field eg. gml:beginPosition. -->
          <xsl:when test="count(*) = 0">
            <xsl:apply-templates mode="render-value" select="text()"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="render-value" select="."/>
          </xsl:otherwise>
        </xsl:choose>&#160;
        <xsl:apply-templates mode="render-value" select="@*"/>
      </dd>
    </dl>
  </xsl:template>


  <!-- Render linkage handling missing names -->

  <xsl:template mode="render-field"
                match="*[cit:CI_OnlineResource and */cit:linkage/* != '']"
                priority="100">
    <dl class="gn-link">
      <dt>
        <xsl:value-of select="tr:node-label(tr:create($schema), name(), null)"/>
      </dt>
      <dd>
        <xsl:variable name="linkDescription">
          <xsl:apply-templates mode="render-value"
                               select="*/cit:description"/>
        </xsl:variable>
        <a href="{*/cit:linkage/*}" target="_blank">
          <xsl:apply-templates mode="render-value"
                               select="if (*/cit:name/* != '') then */cit:name else */cit:linkage"/>&#160;
        </a>
        <p>
          <xsl:value-of select="normalize-space($linkDescription)"/>
        </p>
      </dd>
    </dl>
  </xsl:template>

</xsl:stylesheet>

