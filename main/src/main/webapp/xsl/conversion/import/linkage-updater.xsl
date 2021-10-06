<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:geonet="http://www.fao.org/geonetwork"
                version="2.0"
                exclude-result-prefixes="geonet">
    
    <!--
        References:
        linkage-updater
          https://github.com/aodn/cloud-deploy/blob/1d2d700e41f40b5002ed7e619ca16bc2bde3b9ff/sample-config/ebprep_conf/templates/geonetwork3/linkage-updater.xsl.template
          linkage-updater?pattern=http://geoserver-123.aodn.org.au&replacement=http://geoserver-portal.aodn.org.au&pot_url=https://apps.aims.gov.au/metadata/view/${uuid}
    -->

    <xsl:output indent="yes"/>

    <xsl:variable name="config" select="document('../../../WEB-INF/data/config/url-substitutions/linkage-updater.xml')"/>
    
    <xsl:variable name="geowebcache" select="$config/config/geowebcache/@replaceWith" />
    <xsl:variable name="geoserver" select="$config/config/geoserver/@replaceWith" />
    <xsl:variable name="geoserver_wfs" select="$config/config/geoserver_wfs/@pattern" />
    
    <!-- default action is to copy -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:include href="../../../WEB-INF/data/config/url-substitutions/geonet-remove.xsl" />
    <xsl:include href="../../../WEB-INF/data/config/url-substitutions/geoserver-update.xsl" />
    <xsl:include href="../../../WEB-INF/data/config/url-substitutions/geowebcache-update.xsl" />
    <xsl:include href="../../../WEB-INF/data/config/url-substitutions/wfs-update.xsl" />

</xsl:stylesheet>
