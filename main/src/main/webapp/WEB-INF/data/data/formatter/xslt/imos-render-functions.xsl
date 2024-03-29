<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:gn-fn-render="http://geonetwork-opensource.org/xsl/functions/render"
                version="2.0"
                exclude-result-prefixes="#all"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <!-- Use region API to display metadata extent bounding box coordinates -->
    <xsl:function name="gn-fn-render:extent">
        <xsl:param name="uuid" as="xs:string"/>
        <xsl:param name="index" as="xs:integer"/>
        <xsl:param name="west" as="xs:double"/>
        <xsl:param name="south" as="xs:double"/>
        <xsl:param name="east" as="xs:double"/>
        <xsl:param name="north" as="xs:double"/>
        <xsl:variable name="numberFormat" select="'0.00'"/>
        <xsl:if test="$uuid and $west!=$east and $south!=$north">
            <div class="thumbnail extent">
                <div class="input-group coord coord-north">
                    <input type="text" class="form-control"
                           aria-label="{$schemaStrings/north}"
                           value="{format-number($north, $numberFormat)}" readonly=""/>
                    <span class="input-group-addon">N</span>
                </div>
                <div class="input-group coord coord-south">
                    <input type="text" class="form-control"
                           aria-label="{$schemaStrings/south}"
                           value="{format-number($south, $numberFormat)}" readonly=""/>
                    <span class="input-group-addon">S</span>
                </div>
                <div class="input-group coord coord-east">
                    <input type="text" class="form-control"
                           aria-label="{$schemaStrings/east}"
                           value="{format-number($east, $numberFormat)}" readonly=""/>
                    <span class="input-group-addon">E</span>
                </div>
                <div class="input-group coord coord-west">
                    <input type="text" class="form-control"
                           aria-label="{$schemaStrings/west}"
                           value="{format-number($west, $numberFormat)}" readonly=""/>
                    <span class="input-group-addon">W</span>
                </div>
                <img class="gn-img-extent"
                     alt="{$schemaStrings/thumbnail}"
                     src="{replace(replace($nodeUrl,'^https://','http://'),':433','')}api/records/{$uuid}/extents/{$index}.png"/>
            </div>
        </xsl:if>

    </xsl:function>

    <!-- Remove https and render the map -->
    <xsl:function name="gn-fn-render:extent-no-max-min">
        <xsl:param name="uuid" as="xs:string"/>
        <xsl:if test="$uuid">
            <div class="thumbnail extent">
                <img class="gn-img-extent"
                     alt="{$schemaStrings/thumbnail}"
                     src="{replace(replace($nodeUrl,'^https://','http://'),':433','')}api/records/{$uuid}/extents.png"/>
            </div>
        </xsl:if>
    </xsl:function>

    <!-- Single point -->
    <xsl:function name="gn-fn-render:point-on-map">
        <xsl:param name="lat" as="xs:double"/>
        <xsl:param name="long" as="xs:double"/>
        <!-- TODO: replace this with api call to /{portal}/api/0.1/regions/geom.png to display an image. Currently
              there is a bug in core-geonetwork where this does not work. -->
        <div>
            <span>
                Single point at longitude <xsl:value-of select="$long"/> and latitude <xsl:value-of select="$lat"/>
            </span>
        </div>
    </xsl:function>

</xsl:stylesheet>