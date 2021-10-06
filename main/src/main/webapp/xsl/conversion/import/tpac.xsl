<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="2.0">
    
    <!--
        References:
        tpac
            add-collection-config?config-dir=https://raw.githubusercontent.com/aodn/collection-config/master/tpac
    -->

    <xsl:variable name="config" select="document('../../../WEB-INF/data/config/url-substitutions/collection-add')"/>
    <xsl:variable name="config-dirs" select="$config/config/tpac/@config-dir" />

    <xsl:include href="../../../WEB-INF/data/config/schema_plugins/iso19115-3.2018/process/add-collection-config.xsl"/>


</xsl:stylesheet>
