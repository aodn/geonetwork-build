#!/bin/bash    

unzip -j "geonetwork.war" "META-INF/maven/*.properties" -d "geonetwork"

groupId=`grep groupId geonetwork/pom.properties | cut -d'=' -f2`
artifactId=`grep artifactId geonetwork/pom.properties | cut -d'=' -f2`
version=`grep version geonetwork/pom.properties | cut -d'=' -f2`
mavenUrl='s3://${env.ARTIFACT_BUCKET}/repo/maven'

mvn deploy:deploy-file -Dfile=geonetwork.war \
 -DgroupId=${groupId} -DartifactId=${artifactId} -Dversion=${version} -DgeneratePom=true \
 -Durl=${mavenUrl}

included_artifacts="common core domain"
for artifactId in \${included_artifacts}; do
    filename="${artifactId}-${version}.jar"
    unzip -j "geonetwork.war" "WEB-INF/lib/${filename}" -d "geonetwork"
    mvn deploy:deploy-file -Dfile="geonetwork/\${filename}" \
     -DgroupId=${groupId} -DartifactId=${artifactId} -Dversion=${version} -DgeneratePom=true \
     -Durl=${mavenUrl}
done

