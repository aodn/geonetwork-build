<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:geonet="http://www.fao.org/geonetwork"
    exclude-result-prefixes="xs"
    version="2.0">

    <!-- workaround core issue with GeoNetwork including geonet:info in CSW responses -->
    
    <!-- default is to copy attribute or node (identity transform) -->

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Remove geonet:info elements from harvested CSW metadata until core GeoNetwork is fixed to not -->
    <!-- include them and that flows through to contributors -->

    <xsl:template match="geonet:info"/>

</xsl:stylesheet>
