<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:saxon="http://saxon.sf.net/"
  extension-element-prefixes="saxon"
  version="2.0">

  <!-- Add IMOS suggestions to core suggestions -->

  <xsl:import href="suggest-core.xsl"/>

  <xsl:include href="process/add-missing-parameters-and-platforms.xsl"/>
  <xsl:include href="process/add-missing-instruments.xsl"/>

  <xsl:variable name="processes">
    <p>add-missing-parameters-and-platforms</p>
    <p>add-missing-instruments</p>
  </xsl:variable>

</xsl:stylesheet>
