<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                version="2.0"
                exclude-result-prefixes="#all">
    
    <!-- ISO 19115 -->
    <!-- Add POT if none exists -->
    <!-- Add point of truth online resource element to the first transferOptions element in the MD_Distribution section
        if pot_url provided and it doesn't exist already -->
    <xsl:variable name="metadata_uuid" select="//gmd:fileIdentifier/*/text()" />
    <xsl:variable name="pot_add_url" select="replace($pot_add, '\$\{uuid\}', $metadata_uuid)" />
    <xsl:variable name="has-pot" select="//gmd:MD_Distribution//gmd:protocol/*/text()[.='WWW:LINK-1.0-http--metadata-URL']"/>
    <xsl:variable name="add-pot" select="$pot_add_url and not($has-pot)"/>
    <xsl:template match="gmd:MD_Distribution[$add-pot]/gmd:transferOptions[1]/gmd:MD_DigitalTransferOptions[1]">
        <xsl:copy>
            <xsl:apply-templates select="node()"/>
            <gmd:onLine>
                <gmd:CI_OnlineResource>
                    <gmd:linkage>
                        <gmd:URL><xsl:value-of select="string($pot_add_url)"/></gmd:URL>
                    </gmd:linkage>
                    <gmd:protocol>
                        <gco:CharacterString>WWW:LINK-1.0-http--metadata-URL</gco:CharacterString>
                    </gmd:protocol>
                    <gmd:description>
                        <gco:CharacterString>Point of truth URL of this metadata record</gco:CharacterString>
                    </gmd:description>
                </gmd:CI_OnlineResource>
            </gmd:onLine>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
