# GeoNetwork Build

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

## Licensing
This project is licensed under the terms of the GNU GPLv3 license.
## Contents

This repository uses maven to:

* build supporting [AODN extension](extension/README.md) jars
  * [aodn-classifier](extension/aodn-classifier/README.md) - AODN portal facet generation plugin
  * [aodn-listeners](extension/aodn-listeners/README.md) - AODN metadata event listener plugins for logging metadata updates
  * [aodn-xsl](extension/aodn-xsl/README.md) - AODN xsl java indexing extensions for indexing bounding polygons as WKT
* build a war containing supporting extensions and making required changes to the GeoNetwork war
  using a maven overlay module
  
## To build

```
mvn clean package 
```

## Running in IntelliJ

IntelliJ doesn't cope well with the processing performed in the maven overlay so you'll need to use a maven build to build the project rather than relying on the IntelliJ build prior to deploying to a tomcat instance.

![image](https://user-images.githubusercontent.com/1860215/121621288-3c9de380-caaf-11eb-9790-7420caad56cb.png)

Note in this example we've specified the following system properties use a configuration overrides file similar to what's used when the app is deployed.

    -Dgeonetwork.jeeves.configuration.overrides.file=/home/craigj/temp/geonetwork-build-overrides.xml

It's also possible to specify a separate location for the data directory used to store uploaded files, schema plugins
the lucene index and other GeoNetwork state using the geonetwork.dir system property.  For example for my local
IntelliJ setup I use:

    -Dgeonetwork.dir=/home/craigj/temp/geonetwork-build-data-dir

as well as the config overrides parameter above.  Be careful with this option though as
changes to the data directory included in the war won't automatically get deployed to 
a separate data directory.
 
![image](https://user-images.githubusercontent.com/1860215/121621720-0e6cd380-cab0-11eb-8b5f-d57632f82fe6.png)

## Connecting to postgres

To connect to a postgres database instead of the default H2 one, use a configuration overrides file that 
imports the spring jndi configuration:

    <spring>
        <import file="/WEB-INF/config-db/jndi-postgres-postgis.xml"/>
    </spring>

A configuration overrides that does just that can be found at [jndi-override.xml](jndi-override.xml).

The jndi connection details will then need to be added to the context for this application. A sample context.xml
file to do this can be found at [context.xml example](main/src/main/webapp/META-INF/context_sample.xml).
Copy this file to  main/src/main/webapp/META-INF/context.xml and change the connection details to point to
your postgres database.

To use this configuration add the location of the configuration overrides file to your startup options e.g.

    -Dgeonetwork.jeeves.configuration.overrides.file={geonetwork-build directory}/jndi-override.xml
