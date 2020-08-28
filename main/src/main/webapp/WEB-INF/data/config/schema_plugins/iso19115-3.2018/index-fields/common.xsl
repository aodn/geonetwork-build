<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
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
                xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.1"
                xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:gfc="http://standards.iso.org/iso/19110/gfc/1.1"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:util="java:org.fao.geonet.util.XslUtil"
                xmlns:joda="java:org.fao.geonet.domain.ISODate"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gn-fn-core="http://geonetwork-opensource.org/xsl/functions/core"
                xmlns:gn-fn-index="http://geonetwork-opensource.org/xsl/functions/index"
                xmlns:gn-fn-iso19115-3.2018="http://geonetwork-opensource.org/xsl/functions/profiles/iso19115-3.2018"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                exclude-result-prefixes="#all">

  <!-- Include core templates -->

  <xsl:import href="common-core.xsl"/>

  <!-- Override core contactIndexing template to fix issues indexing and displaying multiple contact info (address,
       email, phone) details until core fix is available.  Where multiple different contactInfo elements are recorded
       for a party - index/show the first only -->

  <xsl:template name="ContactIndexing">
    <xsl:param name="type" select="'resource'" required="no" as="xs:string"/>
    <xsl:param name="fieldPrefix" select="'responsibleParty'" required="no" as="xs:string"/>
    <xsl:param name="lang"/>
    <xsl:param name="langId"/>

    <!-- Only used in ISO19139 -->
    <xsl:variable name="position" select="'0'"/>

    <!-- Name is optional if logo or identifier is provided -->
    <xsl:if test="cit:name">
      <xsl:copy-of select="gn-fn-iso19115-3.2018:index-field('orgName', cit:name, $langId)"/>
    </xsl:if>

    <xsl:variable name="uuid" select="@uuid"/>
    <xsl:variable name="role" select="../../cit:role/*/@codeListValue"/>
    <xsl:variable name="email" select="cit:contactInfo[1]/cit:CI_Contact/
                             cit:address/cit:CI_Address/
                             cit:electronicMailAddress/gco:CharacterString[normalize-space()!='']|
                 cit:individual//cit:contactInfo[1]/cit:CI_Contact/
                                cit:address/cit:CI_Address/
                                cit:electronicMailAddress/gco:CharacterString[normalize-space()!='']"/>
    <xsl:variable name="roleTranslation" select="util:getCodelistTranslation('cit:CI_RoleCode', string($role), string($lang))"/>
    <xsl:variable name="logo" select="cit:logo/mcc:MD_BrowseGraphic/mcc:fileName/gco:CharacterString"/>
    <xsl:variable name="website" select="cit:contactInfo[1]//cit:onlineResource[1]/*/cit:linkage/gco:CharacterString"/>
    <xsl:variable name="phones"
                  select="cit:contactInfo[1]/cit:CI_Contact/cit:phone/*/cit:number/gco:CharacterString"/>
    <!--<xsl:variable name="phones"
                  select="cit:contactInfo/cit:CI_Contact/cit:phone/concat(*/cit:numberType/*/@codeListValue, ':', */cit:number/gco:CharacterString)"/>-->
    <xsl:variable name="address" select="string-join(cit:contactInfo[1]/*/cit:address/*/(
                                          cit:deliveryPoint|cit:postalCode|cit:city|
                                          cit:administrativeArea|cit:country)/gco:CharacterString/text(), ', ')"/>
    <xsl:variable name="individualNames" select="cit:individual//cit:name/gco:CharacterString"/>
    <xsl:variable name="positionName" select="cit:individual//cit:positionName/gco:CharacterString"/>

    <xsl:variable name="orgName">
      <xsl:apply-templates mode="localised" select="cit:name">
        <xsl:with-param name="langId" select="concat('#', $langId)"/>
      </xsl:apply-templates>
    </xsl:variable>

    <Field name="{$type}_{$fieldPrefix}_{$role}"
           string="{$orgName}"
           store="false"
           index="true"/>

    <Field name="{$fieldPrefix}"
           string="{concat($roleTranslation, '|',
                           $type, '|',
                           $orgName, '|',
                           $logo, '|',
                           string-join($email, ','), '|',
                           string-join($individualNames, ','), '|',
                           string-join($positionName, ','), '|',
                           $address, '|',
                           string-join($phones, ','), '|',
                           $uuid, '|',
                           $position, '|',
                           $website)}"
           store="true" index="false"/>

    <xsl:for-each select="$email">
      <Field name="{$fieldPrefix}Email" string="{string(.)}" store="true" index="true"/>
      <Field name="{$fieldPrefix}RoleAndEmail" string="{$role}|{string(.)}" store="true" index="true"/>
    </xsl:for-each>
    <xsl:for-each select="@uuid">
      <Field name="{$fieldPrefix}Uuid" string="{string(.)}" store="true" index="true"/>
      <Field name="{$fieldPrefix}RoleAndUuid" string="{$role}|{string(.)}" store="true" index="true"/>
    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
