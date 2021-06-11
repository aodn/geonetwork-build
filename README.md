### GeoNetwork Build

This repository contains customisations/AODN specific configuration applied to the GeoNetwork war
including:

* add missing platform and parameter suggestions
* directory entries for units of measure (refer [here](https://github.com/aodn/internal-discussions/wiki/Updating-units-of-measure-directory-entries-in-GN3) for how to update)
* MCP import stylesheet
* indexing of information required by the portal including facets
* logging changes to metadata
* IMOS specific logging levels
* xml view
* postgis jndi configuration for use by cloud deploy
* core fixes we couldn't wait for which could be applied to the war (see below)

Fixes applied included in a later release which can be removed when upgrading to them
* contact indexing (WEB-INF/data/config/schema_plugins/iso19115-3.2018/index-fields/common.xsl)
* remove geonet info required because of GN CSW harvesting bug (xsl/conversion/import/RemoveGeonetInfo.xsl)
* full view mrc:units display and linkage display (main/src/main/webapp/WEB-INF/data/config/schema_plugins/iso19115-3.2018/formatter/imos-full-view)

### Contents

This repository uses maven to:

* build supporting extension jars
  * aodn-classifier - AODN portal facet generation plugin
  * aodn-listeners - AODN metadata event listener plugins for logging metadata updates
  * aodn-xsl - AODN xsl java indexing extensions for indexing bounding polygons as WKT
* build a war containing supporting extensions and making required changes to the GeoNetwork war
  using a maven overlay module
  
### To build

```
mvn clean package 
```

### Running in IntelliJ

IntelliJ doesn't cope well with the processing performed in the maven overlay so you'll need to use a maven build to build the project rather than relying on the IntelliJ build prior to deploying to a tomcat instance.

![image](https://user-images.githubusercontent.com/1860215/121621288-3c9de380-caaf-11eb-9790-7420caad56cb.png)

Note in this example we've specified the following system properties use a configuration overrides file similar to what's used when the app is deployed.

```
-Dgeonetwork.jeeves.configuration.overrides.file=/home/craigj/temp/geonetwork-build-overrides.xml
```

![image](https://user-images.githubusercontent.com/1860215/121621720-0e6cd380-cab0-11eb-8b5f-d57632f82fe6.png)
