#!/bin/bash

set -euxo pipefail

ARTIFACT_BUCKET=$1

# Read groupId, artifactId and version from the pom.properties file
unzip -j "geonetwork.war" "META-INF/maven/*.properties" -d "geonetwork"
groupId=`grep groupId geonetwork/pom.properties | cut -d'=' -f2`
artifactId=`grep artifactId geonetwork/pom.properties | cut -d'=' -f2`
version=`grep version geonetwork/pom.properties | cut -d'=' -f2`
mavenUrl="s3://${ARTIFACT_BUCKET}/repo/maven"

# deploy war to s3 maven repo
mvn deploy:deploy-file -Dfile=geonetwork.war \
 -DgroupId=${groupId} -DartifactId=${artifactId} -Dversion=${version} -DgeneratePom=true \
 -Durl=${mavenUrl}

# deploy included artifacts to s3 maven repo
included_artifacts="common core domain events"
for artifactId in ${included_artifacts}; do
    filename="${artifactId}-${version}.jar"
    unzip -j "geonetwork.war" "WEB-INF/lib/${filename}" -d "geonetwork"
    mvn deploy:deploy-file -Dfile="geonetwork/${filename}" \
     -DgroupId=${groupId} -DartifactId=${artifactId} -Dversion=${version} -DgeneratePom=true \
     -Durl=${mavenUrl}
done
