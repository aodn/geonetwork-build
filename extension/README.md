### IMOS GeoNetwork Extensions

This maven sub-module contains AODN extensions to GeoNetwork. The versions of common dependencies
used by the extensions and common metadata are defined here along with the extensions themselves.

Each extension is built as a separate jar which is then included in the WEB-INF/lib
directory of the geonetwork war by the maven overlay project [main](../main/README.md)
during the build.
