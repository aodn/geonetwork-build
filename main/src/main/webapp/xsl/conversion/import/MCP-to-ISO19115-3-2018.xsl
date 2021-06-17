<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
                
    <!-- MCP to 19115-3:2018 import transform -->
                 
    <xsl:import href="../../../WEB-INF/data/config/schema_plugins/iso19115-3.2018/convert/ISO19139.MCP/fromMCP.xsl"/>

    <!-- IMOS specific config for dataParams and urlSubstitutions -->
    <!-- Look at using a java system property to allow this to be specified on startup -->

    <xsl:param name="dataParamsConfig" select="'../config/mcpdataparameters_config.xml'"/>
    <xsl:param name="urlSubstitutionsConfig" select="'../config/url-substitutions/prod.xml'"/>

</xsl:stylesheet>
