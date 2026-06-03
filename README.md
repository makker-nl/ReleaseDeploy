# ReleaseDeploy
Simple Standalone ReleaseDeploy framework based on ANT and WLST.

# Introduction
This framework is created to support a large customer project that consist of an ADF project, SOA and OSB service application projects and BPM process application projects.
The frame work consist of a separate Release framework that gathers the applications to be released into a zip file.
It also (optionally) Releases a Deployoment framework into the resulting archive. This Deployment framework is able to deploy the artifact to Fusion Middleware.
Both frameworks use Apache Ant from the Fusion Middleware home. You might wonder why not Maven? Maven is particularly meant to do builds resolving dependencies on build time and result in an artifact that is uploaded to an Artifact Repository like Nexus.
This framework is primarly meant to deliver those artifacts in an archive that can be used by sys admins to deploy those to an Fusion Middleware environment in an automated way.

# Setup
## Release definition
In the Releases folder define a release properties file with the name format _release_.${release_name}.${release_nr}._properties._.
Since you do not need to release every application in your system in every release, you can create different files per release number.

Give it the following content:

````
# Release properties of soademo application
# Comma separated list of applications to release:
rel.applications=soademo
#Location to move the generated release to
rel.dest.dir=${releaseDir}/dist/soademo
#
# Release the Deploy Framework:
deploy.enabled=true
# Release the Generic  Project, with common artefacts:
generic.enabled=true
# Release the infraPrep framework:
infraPrep.enabled=false
# Release Metadata Services applications:
#mds.enabled=true
mds.enabled=false
#
# Comma separated list of MDS Applications to release:
# Leave empty if MDS should not be deployed
mds.applications=
# Source directory of soademo application.
# If a relative path is given, then the should be relative to _rel.dest.dir_..
soademo.src.dir=../../Services/soa/soademo
soademo.dest.base=services/soa
#
# Location of the MDS repository of DWN.
# If a relative path is given, then the should be relative _rel.dest.dir_..
mds.DWN.repository=../../Services/MDS
````
Modify here the properties:
| Attribute              | Description                                     | example value |
|========================|=================================================|===============|
| rel.applications       | Comma separated list of applications to release | soademo       |
| rel.dest.dir           | Location to move the generated release to. Variable ${releaseDir} is an Ant property that is created from the corresponding arguments | ${releaseDir}/dist/soademo |
| deploy.enabled         | Release the Deploy Framework                    | true          |
| generic.enabled        | Release the Generic  Project, with common artefacts (properties, helper functions) | true |
| infraPrep.enabled      | Release the infraPrep framework                 | false         |
| mds.enabled            | Release Metadata Services applications          | false         |
| mds.applications       | Comma separated list of MDS Applications to release. Leave empty if MDS should not be deployed|   |
| _Applications_         | Repeat the following properties for occurrence in _rel.applications_ |       |
| soademo.src.dir        | Source directory of soademo application. If a relative path is given, then the should be relative to _rel.dest.dir_. | ../../Services/soa/soademo |
| soademo.dest.base      | Base folder of the application within the archive | services/soa |
| _MDS Applications_     | Repeat the following properties for occurrence in _mds.applications_ |       |
| mds.soademo.repository | Location of the MDS repository of _soademo_.  If a relative path is given, then the should be relative to  _rel.dest.dir_. | ../../Services/MDS |



# Release
Run


# Deploy

Create a file  with the following (example) content
````
overwrite=true
user=wls_admin
password=<password you know>
forceDefault=true
deploy.keepInstancesOnRedeploy=true
deploy.server=<your SOA server>
deploy.port=8001
deploy.serverURL=http://\${server}:\${port}
deploy.admin.server=o-bpm-1-admin-vhn.ont.org.darwin-it.local
deploy.admin.port=7001
deploy.adminServerURL=t3\://${deploy.admin.server}\:${deploy.admin.port}
# Config plan replacement properties
soasuite.URL=${deploy.serverURL}
soaserver.endpoint=${deploy.server}\:${deploy.port}
bpm.URL=o-bpm-1.ont.org.darwin-it.local
soa.URL=o-soa-1.ont.org.darwin-it.local
osb.URL=o-osb-1.ont.org.darwin-it.local
````