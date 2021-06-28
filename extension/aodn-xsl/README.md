### AODN XSL Extensions

This extension contains utility functions for use in XSL.  In particular
it contains a java function for converting gml bounding polygons in
ISO19115-3/19139 metadata documents into WKT strings that are indexed by GeoNetwork
 and returned to the portal in search results for display in Step 1.

GeoNetwork uses [Saxon](https://www.saxonica.com/welcome/welcome.xml) as the xsl processing engine and Saxon allows
java code on the classpath to be
[invoked from within an xsl stylesheet](https://www.saxonica.com/html/documentation10/extensibility/functions/).
 So building this function here and including the jar containing it in the WEB-INF/lib directory
allows this function to be invoked in AODN indexing stylesheets called by GeoNetwork.
