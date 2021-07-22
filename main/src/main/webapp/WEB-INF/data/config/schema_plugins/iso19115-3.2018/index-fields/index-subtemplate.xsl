<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
                xmlns:mrc="http://standards.iso.org/iso/19115/-3/mrc/2.0"
                xmlns:mac="http://standards.iso.org/iso/19115/-3/mac/2.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Add required indexing IMOS sub templates (directory entries) -->

  <!-- Import core subtemplate indexing -->

  <xsl:include href="index-subtemplate-core.xsl"/>

  <!-- Index a title for mrc:units subtemplates -->

  <xsl:template mode="index" match="mrc:units">
    <Field name="_title" string="{gml:BaseUnit/gml:name/text()}" store="true" index="true"/>
    <xsl:call-template name="subtemplate-common-fields"/>
  </xsl:template>

</xsl:stylesheet>
