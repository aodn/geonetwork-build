<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:gml320="http://www.opengis.net/gml"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:util="java:org.fao.geonet.util.XslUtil"
                xmlns:saxon="http://saxon.sf.net/"
                version="2.0"
                extension-element-prefixes="saxon"
                exclude-result-prefixes="#all">

  <!-- Default to xsl-view behaviour when not overridden here -->

  <xsl:import href="../xsl-view/view.xsl"/>

  <!-- Turn off default metadata citation  -->

  <xsl:template mode="getMetadataCitation" match="gmd:MD_Metadata"/>

  <!-- Display bounding polygon -->

  <xsl:template mode="render-field"
                match="gmd:EX_BoundingPolygon[normalize-space(.) != '']">

    <xsl:variable name="geometry_node" select="gmd:polygon/gml:MultiSurface|gmd:polygon/gml:LineString|
                                       gmd:polygon/gml320:MultiSurface|gmd:polygon/gml320:LineString"/>

    <xsl:variable name="geometry" select="normalize-space(saxon:serialize($geometry_node, 'default-serialize-mode'))"/>

    <xsl:if test="$geometry">
      <xsl:variable name="background"
                    select="util:getSettingValue('region/getmap/background')"/>
      <xsl:variable name="width"
                    select="util:getSettingValue('region/getmap/width')"/>
      <xsl:variable name="mapproj"
                    select="util:getSettingValue('region/getmap/mapproj')"/>

      <img class="gn-img-extent"
           alt="{$schemaStrings/thumbnail}"
           src="{$nodeUrl}eng/region.getmap.png?mapsrs={if ($mapproj != '')
                                         then $mapproj
                                         else 'EPSG:3857'}&amp;width={
                                         if ($width != '')
                                         then $width
                                         else '600'
                                         }&amp;background=settings&amp;geomsrs=EPSG:4326&amp;geomtype=GML32&amp;geom={normalize-space($geometry)}"/>
    </xsl:if>

    <br/>
    <br/>
  </xsl:template>

</xsl:stylesheet>

