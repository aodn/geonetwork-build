<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:gn-fn-render="http://geonetwork-opensource.org/xsl/functions/render"
                xmlns:tr="java:org.fao.geonet.api.records.formatters.SchemaLocalizations"
                version="2.0"
                exclude-result-prefixes="#all">

  <!-- IMOS fixes for 19115-3:2018 full view - remove when upgrading and fixes included -->

  <!-- Default to core full view behaviour when not overridden here -->

  <xsl:import href="../xsl-view/view.xsl"/>
  <xsl:import href="../../../../../data/formatter/xslt/imos-render-functions.xsl"/>

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

  <!-- Bounding polygons are displayed with max and min NSEW values -->

  <xsl:template mode="render-field"
                match="gex:EX_BoundingPolygon/gex:polygon"
                priority="100">

    <xsl:variable name="poslist"
                  as="xs:string*"
                  select="tokenize(gml:MultiSurface/gml:surfaceMember/gml:Polygon/gml:exterior/gml:LinearRing/gml:posList,' ')"/>
    <xsl:variable name="poslistNumbers"
                  select="for $i in $poslist return number($i)"/>
    <xsl:variable name="latitudes" select="$poslistNumbers[position() mod 2 = 0]"/>
    <xsl:variable name="longitudes" select="$poslistNumbers[position() mod 2 != 0]"/>

    <br/>
    <xsl:copy-of select="gn-fn-render:extent($metadataUuid,
        count(ancestor::mri:extent/preceding-sibling::mri:extent/*/*[local-name() = 'geographicElement']/*) +
        count(../../preceding-sibling::gex:geographicElement) + 1,
        min($longitudes), min($latitudes), max($longitudes), max($latitudes))"/>
    <br/>
    <br/>
  </xsl:template>

  <!-- Thumbnail extent works with https:// -->

  <xsl:template mode="getExtent" match="mdb:MD_Metadata">
    <section class="gn-md-side-extent">
      <h2>
        <i class="fa fa-fw fa-map-marker"><xsl:comment select="'image'"/></i>
        <span><xsl:comment select="name()"/>
          <xsl:value-of select="$schemaStrings/spatialExtent"/>
        </span>
      </h2>

      <xsl:choose>
        <xsl:when test=".//gex:EX_BoundingPolygon">
          <xsl:copy-of select="gn-fn-render:extent-no-max-min($metadataUuid)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="render-field"
                               select=".//gex:EX_GeographicBoundingBox">
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </section>
  </xsl:template>


</xsl:stylesheet>

