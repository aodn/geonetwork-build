<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                version="2.0">

    <!-- Geoserver WFS -->
    <!-- ISO 19115 -->
    <xsl:template match="cit:CI_OnlineResource[cit:protocol/gco:CharacterString/text()='OGC:WFS-1.0.0-http-get-capabilities' and contains(cit:linkage/cit:URL/text(), $geoserver_wfs)]">
        <xsl:choose>
            <xsl:when test="not($geoserver_wfs = '')">
                <xsl:variable name="collection_name" select="cit:name/gco:CharacterString/text()"/>
                <cit:CI_OnlineResource>
                    <cit:linkage>
                        <gco:CharacterString>
                            <xsl:value-of select="concat('http://', string($geoserver_wfs), '/geoserver/ows')"/>
                        </gco:CharacterString>
                    </cit:linkage>
                    <cit:protocol>
                        <gco:CharacterString>
                            <xsl:value-of select="'AODN:WFS-EXTERNAL-1.0.0-http-get-capabilities'"/>
                        </gco:CharacterString>
                    </cit:protocol>
                    <cit:name>
                        <gco:CharacterString>
                            <xsl:value-of select="$collection_name"/>
                        </gco:CharacterString>
                    </cit:name>
                    <cit:description>
                        <gco:CharacterString>This OGC WFS service returns filtered geographic information. The returned data 
                            is available in multiple formats including CSV.
                        </gco:CharacterString>
                    </cit:description>
                </cit:CI_OnlineResource>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ISO 19139 -->
    <xsl:template match="gmd:onLine[gmd:CI_OnlineResource[contains(gmd:linkage/gmd:URL/text(), $geoserver_wfs)]/gmd:protocol/*/text() = 'OGC:WFS-1.0.0-http-get-capabilities']">
        <xsl:choose>
            <xsl:when test="not($geoserver_wfs = '')">
                <xsl:variable name="collection_name" select="gmd:name/gco:CharacterString/text()"/>
                <gmd:onLine>
                    <gmd:CI_OnlineResource>
                        <gmd:linkage>
                            <xsl:value-of select="concat('http://', string($geoserver_wfs), '/geoserver/ows')"/>
                        </gmd:linkage>
                        <gmd:protocol>
                            <gco:CharacterString>
                                <xsl:value-of select="'AODN:WFS-EXTERNAL-1.0.0-http-get-capabilities'"/>
                            </gco:CharacterString>
                        </gmd:protocol>
                        <gmd:name>
                            <gco:CharacterString>
                                <xsl:value-of select="$collection_name"/>
                            </gco:CharacterString>
                        </gmd:name>
                        <gmd:description>
                            <gco:CharacterString>This OGC WFS service returns filtered geographic information. The returned data
                                is available in multiple formats including CSV.
                            </gco:CharacterString>
                        </gmd:description>
                    </gmd:CI_OnlineResource>
                </gmd:onLine>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
