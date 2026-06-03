#!/bin/bash
################################################################################
# deployAll
# Script to deploy OSB, SOA or BPM
#
# @Author: Martien van den Akker, Darwin-IT Professionals/Oracle Netherlands B.V.
#
# Changes:
# Who         When           What
# MvdA        2017-10-02     Initial Creation.
# MvdA        2026-06-02     Refactoring and debugged.
#
################################################################################

#
SCRIPTPATH=$(dirname $0)
GENERIC_DIR=${SCRIPTPATH}/../Generic
. ${GENERIC_DIR}/bash_helper_functions.sh


# Show usage info
function usage() {
        logerror "$0: $1"
        logwarn "usage $0 -e DEPLOYMENT_ENVIRONMENT -l ENV_PROP_DIR"
        logwarn "DEPLOYMENT_ENVIRONMENT: osoa|obpm|tsoa|tbpm"
        logwarn "ENV_PROP_DIR: <Environment property location>"
        exit 1
}


# Check Arguments
function check_args(){
  while getopts "e:l:" arg; do
          case $arg in
                  e) export DEPLOYMENT_ENVIRONMENT=$OPTARG  ;;
                  l) export ENV_PROP_DIR=$OPTARG            ;;
                  *) usage "Unexpected argument: ${arg}"    ;;
          esac
  done
  if [ -z ${DEPLOYMENT_ENVIRONMENT:+x} ]; then
    usage "Provide DEPLOYMENT_ENVIRONMENT"
  fi
  if [ -z ${ENV_PROP_DIR:+x} ]; then
    usage "Provide ENV_PROP_DIR"
  fi
  ENV_PROP_FILE_NAME=${DEPLOYMENT_ENVIRONMENT}.properties
  ENV_PROP_FILE="${ENV_PROP_DIR}/${ENV_PROP_FILE_NAME}"
  if [ ! -s "${ENV_PROP_FILE}" ]; then
    usage "Environment properties ${ENV_PROP_FILE} not found. Provide ENV_PROP_DIR folder with an existing ENV_PROP_FILE_NAME"
  fi
  if [ -z ${FMW_HOME:+x} ]; then
    usage "export FMW_HOME to a Fusion Middleware (WebLogic or JDeveloper) Home folder"
  fi
  if [ -z ${JAVA_HOME:+x} ]; then
    usage "export JAVA_HOME to a supported JDK home (Java 8 for FMW 12.2.1.4, Java 17+ for FMW 14.1.2.0+)"
  fi
  if [ ! -s "${ANT_HOME}/bin/ant" ]; then
    usage "Ant not found in ${ANT_HOME}/bin"
  fi
  if ! grep -q "server" "${ENV_PROP_FILE}"; then
    usage "Properties for ${DEPLOYMENT_ENVIRONMENT} environment not found. Make sure that ${ENV_PROP_FILE_NAME} has the required properies."
  fi
  set -euo pipefail
}

function main(){
  check_args "$@"
  loginfo "Start deploying"
  ant -f build.xml deployAll -Denv.prop.dir=${ENV_PROP_DIR} -Ddeployment.plan.environment=${DEPLOYMENT_ENVIRONMENT}
}

main "$@"



