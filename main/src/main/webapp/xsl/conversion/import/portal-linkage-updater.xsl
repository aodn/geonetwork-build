<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:geonet="http://www.fao.org/geonetwork"
                version="2.0"
                exclude-result-prefixes="geonet">
    
    <!--
        References:
        portal-linkage-updater
          https://github.com/aodn/core-geonetwork/blob/93bbd3b85f33522327ee9e64a2ec0ff9ea1a4ef5/web/src/main/webapp/WEB-INF/data/config/schema_plugins/iso19139/process/portal-linkage-updater.xsl
          portal-linkage-updater?pot_url=https://metadata.imas.utas.edu.au/geonetwork/srv/eng/catalog.search#/metadata/${uuid}
    -->

    <xsl:output indent="yes"/>

    <xsl:include href="../common/get-data-dir.xsl" />
    <xsl:variable name="config" select="document(concat($data-dir,'/config/url-substitutions/portal-linkage-updater.xml'))" />

    <xsl:variable name="pot_add" select="$config/config/pot/@add" />
    <xsl:variable name="geowebcache" select="$config/config/geowebcache/@replaceWith" />
    <xsl:variable name="geoserver" select="$config/config/geoserver/@replaceWith" />
    <xsl:variable name="geoserver_wfs" select="$config/config/geoserver_wfs/@pattern" />
    
    <!-- default action is to copy -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:include href="../common/geonet-remove.xsl" />
    <xsl:include href="../common/geoserver-update.xsl" />
    <xsl:include href="../common/geowebcache-update.xsl" />
    <xsl:include href="../common/wfs-update.xsl" />
    <xsl:include href="../common/pot-add.xsl" />

</xsl:stylesheet>
