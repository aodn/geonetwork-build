<?xml version="1.0" encoding="UTF-8" ?>
<!-- Index a record for the main language -->
<xsl:stylesheet version="2.0"
            xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
            xmlns:dqm="http://standards.iso.org/iso/19157/-2/dqm/1.0"
            xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
            xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
            xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
            xmlns:mrc="http://standards.iso.org/iso/19115/-3/mrc/2.0"
            xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
            xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
            xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
            xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
            xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/2.0"
            xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
            xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.1"
            xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
            xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
            xmlns:gfc="http://standards.iso.org/iso/19110/gfc/1.1"
            xmlns:gml="http://www.opengis.net/gml/3.2"
            xmlns:geonet="http://www.fao.org/geonetwork"
            xmlns:gn-fn-iso19115-3.2018="http://geonetwork-opensource.org/xsl/functions/profiles/iso19115-3.2018"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:skos="http://www.w3.org/2004/02/skos/core#"
            exclude-result-prefixes="#all">

  <xsl:include href="default.xsl"/>

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

  <!-- Catch layer name and index them -->
  <xsl:template mode="index"
                match="/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:transferOptions/mrd:MD_DigitalTransferOptions/mrd:onLine/cit:CI_OnlineResource[cit:linkage/*!='' and not(contains(lower-case(cit:linkage/*), 'service=wms') and not(string(normalize-space(cit:protocol/gco:CharacterString))))]">
      <Field name="layer" string="{normalize-space(cit:name/gco:CharacterString|cit:name/gcx:MimeFileType)}" store="false" index="true"/>
  </xsl:template>

</xsl:stylesheet>
