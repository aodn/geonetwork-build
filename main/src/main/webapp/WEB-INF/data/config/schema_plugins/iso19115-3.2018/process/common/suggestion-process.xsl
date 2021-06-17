<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"
                exclude-result-prefixes="#all">

    <!-- Suggestion process parameters used by all IMOS suggestions -->

    <!-- Language of the GUI -->
    <xsl:param name="guiLang" select="'eng'"/>

    <!-- Webapp name-->
    <xsl:param name="baseUrl" select="''"/>

    <!-- Catalog URL from protocol to lang -->
    <xsl:param name="catalogUrl" select="''"/>
    <xsl:param name="nodeId" select="''"/>

</xsl:stylesheet>
