#!/bin/sh
###################################################################################################
# deployAll
# Script to deploy OSB, SOA or BPM
#
# author: Martien van den Akker
# (C) october 2017
# Darwin-IT Professionals
###################################################################################################
DEPLOYMENT_ENVIRONMENT=$1
ENV_PROP_DIR=$2
ENV_PROP_FILE=$ENV_PROP_DIR/$DEPLOYMENT_ENVIRONMENT.properties
#
#Usage
usage(){
  echo  "[INFO] Run script $0.sh  <osoa|obpm|tsoa|tbpm> <Environment property location>"
  echo $0 obpm ~/conf
  echo
  exit
}
#
#Usage
help(){
  echo "."
  echo "[INFO]Create script $ENV_PROP_FILE, with the following (example) content"
  echo "overwrite=true"
  echo "user=wls_admin"
  echo "password=<password you know>"
  echo "forceDefault=true"
  echo "deploy.keepInstancesOnRedeploy=true"
  echo "deploy.server=<your SOA server>"
  echo "deploy.port=8001"
  echo "deploy.serverURL=http://\${server}:\${port}"
  echo "deploy.admin.server=o-bpm-1-admin-vhn.ont.org.darwin-it.local"
  echo "deploy.admin.port=7001"
  echo "deploy.adminServerURL=t3\://${deploy.admin.server}\:${deploy.admin.port}"
  echo "# Config plan replacement properties"
  echo "soasuite.URL=${deploy.serverURL}"
  echo "soaserver.endpoint=${deploy.server}\:${deploy.port}"
  echo "bpm.URL=o-bpm-1.ont.org.darwin-it.local"
  echo "soa.URL=o-soa-1.ont.org.darwin-it.local"
  echo "osb.URL=o-osb-1.ont.org.darwin-it.local"
  echo
  exit
}
#
# Check if FMW_HOME is set
#
# if not set default it to $ORACLE_HOME
if [[ -z $FMW_HOME ]]; then
  if [[ ! -z $ORACLE_HOME ]]; then
    echo "[INFO] FMW_HOME not set, it will be defaulted to ORACLE_HOME: $ORACLE_HOME"
    export FMW_HOME=$ORACLE_HOME
  fi
fi
#
# Set WLS environment
#
if [[ ! -z $FMW_HOME ]]; then  
  export WL_HOME=$FMW_HOME/wlserver
  . $WL_HOME/server/bin/setWLSEnv.sh
  echo "FMW_HOME: $FMW_HOME"
  echo "WL_HOME: $WL_HOME"
  echo
fi  

#
if [[ -z $FMW_HOME ]]; then
  echo "[ERROR] FMW_HOME not set."
  echo "set FMW_HOME environment  "
  usage
#
# Check if environment is specified on command line
#
elif [[ -z $DEPLOYMENT_ENVIRONMENT ]]; then
  echo "[ERROR] The deployment environment is not specified."
  usage
#
# Check if environment property directory is specified on command line
#
elif [[ -z $ENV_PROP_DIR ]]; then
  echo "[ERROR] The directory with 'properties' file is not specified."
  usage
#
# Check if property directory exists
#   
elif [[ ! -d "$ENV_PROP_DIR" ]]; then
  echo "[ERROR] The deployment environment configuration directory $ENV_PROP_DIR does not exists."
  help
#
# Check if property file itself exists
# 
elif [[ ! -f "$ENV_PROP_FILE" ]]; then
  echo "[ERROR] The deployment environment configuration file $ENV_PROP_FILE does not exists."
  help
#
# Check if property file contains proprties matching environment
# 
elif ! grep -q "server" "$ENV_PROP_FILE"; then
  echo "[ERROR] Properties for $DEPLOYMENT_ENVIRONMENT environment not found."
  help
else
  echo "[OK] The deployment environment is specified: $DEPLOYMENT_ENVIRONMENT."
  echo "[OK] The directory with 'properties' file is specified: $ENV_PROP_DIR."
  echo "[OK] The deployment environment configuration directory $ENV_PROP_DIR exists."
  echo "[OK] The deployment environment environment configuration file $ENV_PROP_FILE exists."
  echo "[OK] Properties for $DEPLOYMENT_ENVIRONMENT environment found."
fi
# Start ant deploy.
echo
echo "Start ant deploy"
echo "."
ant -f build.xml prepareInfrastructure -Ddeployment.plan.environment=$DEPLOYMENT_ENVIRONMENT -Denv.prop.dir=$ENV_PROP_DIR 