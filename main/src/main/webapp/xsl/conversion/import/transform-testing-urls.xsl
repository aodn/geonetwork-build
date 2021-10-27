<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0">

    <xsl:include href="../../../WEB-INF/data/config/schema_plugins/iso19115-3.2018/process/transform-testing-urls.xsl" use-when="system-property('geonetwork.dir')=''"/>
    <xsl:include href="/srv/geonetwork/data_dir/config/schema_plugins/iso19115-3.2018/process/transform-testing-urls.xsl" use-when="system-property('geonetwork.dir')='/srv/geonetwork/data_dir'"/>

</xsl:stylesheet>
