<?xml version="1.0" encoding="UTF-8" ?>
<!-- Index a record for the main language -->
<xsl:stylesheet xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:gml320="http://www.opengis.net/gml"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:util="java:org.fao.geonet.util.XslUtil"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                version="2.0"
                exclude-result-prefixes="#all">

  <xsl:include href="default.xsl"/>

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

  <!-- Catch layer name and index them -->
  <xsl:template mode="index"
                match="/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource[gmd:linkage/gmd:URL!='' and not(contains(lower-case(gmd:linkage/gmd:URL), 'service=wms') and not(string(normalize-space(gmd:protocol/gco:CharacterString))))]">
      <Field name="layer" string="{normalize-space(gmd:name/gco:CharacterString|gmd:name/gmx:MimeFileType)}" store="false" index="true"/>
  </xsl:template>

</xsl:stylesheet>
