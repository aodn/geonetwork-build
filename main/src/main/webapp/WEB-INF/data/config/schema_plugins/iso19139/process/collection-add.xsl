<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="2.0">
    
    <!--
        References:
        deakin
            add-collection-config?config-dir=https://raw.githubusercontent.com/aodn/collection-config/master/deakin-university
        tpac
            add-collection-config?config-dir=https://raw.githubusercontent.com/aodn/collection-config/master/tpac
    -->

    <xsl:param name="collection" />

    <xsl:variable name="config" select="document('../../../url-substitutions/collection-add.xml')"/>
    <xsl:variable name="config-dir" select="$config/config/$collection/@config-dir" />

    <xsl:include href="add-collection-config.xsl"/>

</xsl:stylesheet>
