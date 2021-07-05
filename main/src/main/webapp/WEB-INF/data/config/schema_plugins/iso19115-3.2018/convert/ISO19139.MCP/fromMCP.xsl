<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:mcp14="http://bluenet3.antcrc.utas.edu.au/mcp"
  version="2.0">

    <xsl:import href="fromISO19139MCP2.xsl"/>
    <xsl:import href="to19139.mcp-2.0.xsl"/>
    <xsl:import href="postprocess.xsl"/>
    
    <xsl:param name="dataParamsConfig" select="'../config/mcpdataparameters_config.xml'"/>

    <xsl:param name="urlSubstitutionsConfig">
        <xsl:choose>
            <xsl:when test="system-property('catalogue.urlsubstitutions.file')">
                <xsl:value-of select="system-property('catalogue.urlsubstitutions.file')" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'../config/url-substitutions/prod.xml'" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>

    <xsl:template match="/">
        <xsl:variable name="convertedMetadata">
            <xsl:choose>
                <xsl:when test="mcp14:*">
                    <xsl:variable name="mcp20Metadata">
                        <xsl:apply-templates mode="mcp-1.4" select="/"/>
                    </xsl:variable>
                    <xsl:apply-templates mode="mcp-2.0" select="$mcp20Metadata"/>                    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="mcp-2.0" select="/"/>                    
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:apply-templates mode="postprocess" select="$convertedMetadata"/>
    </xsl:template>
</xsl:stylesheet>
