<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
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

  <!--

                Original                                  Cloned
  Polygon       37662a66-ec3a-4ece-9db0-31930c181725 - OK ea44b65c-ca5a-4d70-a102-f0b4b3db0240 - No polygon created in clone
  MultiSurface  c317b0fe-02e8-4ff9-96c9-563fd58e82ac - OK c9c662cb-381f-4dd9-8e09-f9b70d12e513 - OK
  BoundingBox   c78801d0-bffe-11dc-a463-00188b4c0af8 - OK b60c55b5-58f3-4da7-96ab-95843ebb7155 - OK
  Single point
    BoundingBox bc6bb3ec-bfa0-4a2a-ab01-8c3e337a9013

-->

  <!-- Bounding polygons are displayed with max and min NSEW values -->

  <xsl:template mode="render-field"
                match="gex:EX_BoundingPolygon/gex:polygon"
                priority="100">

    <xsl:variable name="poslist"
                  as="xs:string*"
                  select="tokenize(
                    gml:MultiSurface/gml:surfaceMember/gml:Polygon/gml:exterior/gml:LinearRing/gml:posList|
                    gml:Polygon/gml:exterior/gml:LinearRing/gml:posList,
                    ' '
                  )"
    />
    <xsl:variable name="poslistNumbers"
                  select="for $i in $poslist return number($i)"/>
    <xsl:variable name="latitudes" select="$poslistNumbers[position() mod 2 = 0]"/>
    <xsl:variable name="longitudes" select="$poslistNumbers[position() mod 2 != 0]"/>
    <xsl:variable name="west" select="min($longitudes)" />
    <xsl:variable name="east" select="max($longitudes)" />
    <xsl:variable name="north" select="max($latitudes)" />
    <xsl:variable name="south" select="min($latitudes)" />
    <xsl:variable name="index" select="count(ancestor::mri:extent/preceding-sibling::mri:extent/*/*[local-name() = 'geographicElement']/*) + count(../../preceding-sibling::gex:geographicElement) + 1"/>
    <br/>
    <xsl:choose>
      <xsl:when test="string($west) = 'NaN' or string($east) = 'NaN' or string($north) = 'NaN' or string($south) = 'NaN'" />
      <xsl:when test=".//gml:Polygon|.//gml:MultiSurface|.//gex:EX_GeographicBoundingBox and $west != $east and $north != $south">
        <xsl:copy-of select="gn-fn-render:extent($metadataUuid,
          $index,
          $west, $south, $east, $north)"/>
      </xsl:when>
      <xsl:when test=".//gml:Polygon|.//gml:MultiSurface|.//gex:EX_GeographicBoundingBox and $west = $east and $north = $south">
        <xsl:copy-of select="gn-fn-render:point-on-map($north, $west)"/>
      </xsl:when>
      <xsl:otherwise>
        <span>No spatial extents found</span>
      </xsl:otherwise>
    </xsl:choose>
    <br/>
    <br/>
  </xsl:template>

  <!-- Bounding boxes are displayed with max and min NSEW values -->

  <xsl:template mode="render-field"
                match="gex:EX_GeographicBoundingBox"
                priority="100">

    <xsl:variable name="west" select="number(./gex:westBoundLongitude/gco:Decimal)" />
    <xsl:variable name="east" select="number(./gex:eastBoundLongitude/gco:Decimal)" />
    <xsl:variable name="north" select="number(./gex:northBoundLatitude/gco:Decimal)" />
    <xsl:variable name="south" select="number(./gex:southBoundLatitude/gco:Decimal)" />

    <br/>
    <xsl:choose>
      <xsl:when test="string($west) = 'NaN' or string($east) = 'NaN' or string($north) = 'NaN' or string($south) = 'NaN'" />
      <xsl:when test="$west != $east and $north != $south">
        <xsl:copy-of select="gn-fn-render:extent($metadataUuid,
            count(ancestor::mri:extent/preceding-sibling::mri:extent/*/*[local-name() = 'geographicElement']/*) +
            count(../../preceding-sibling::gex:geographicElement) + 1,
            $west, $north, $east, $south)"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="gn-fn-render:point-on-map($north, $west)"/>
      </xsl:otherwise>
    </xsl:choose>
    <br/>
    <br/>
  </xsl:template>

  <!-- Thumbnail extent -->

  <xsl:template mode="getExtent" match="mdb:MD_Metadata">
    <section class="gn-md-side-extent">
      <h2>
        <i class="fa fa-fw fa-map-marker"><xsl:comment select="'image'"/></i>
        <span><xsl:comment select="name()"/>
          <xsl:value-of select="$schemaStrings/spatialExtent"/>
        </span>
      </h2>

      <xsl:choose>
        <xsl:when test=".//gex:EX_BoundingPolygon/gex:polygon/gml:Polygon|.//gex:EX_BoundingPolygon/gex:polygon/gml:MultiSurface">
          <xsl:copy-of select="gn-fn-render:extent-no-max-min($metadataUuid)"/>
        </xsl:when>
        <xsl:when test=".//gex:EX_GeographicBoundingBox">
          <xsl:apply-templates mode="render-field"
                               select=".//gex:EX_GeographicBoundingBox">
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <span>No spatial extents found</span>
        </xsl:otherwise>
      </xsl:choose>
    </section>
  </xsl:template>


</xsl:stylesheet>

