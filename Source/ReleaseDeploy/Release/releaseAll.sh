#!/bin/bash
################################################################################
# Release SOA,BPM and/or OSB projects
#
# @Author: Martien van den Akker, Oracle Netherlands B.V.
#
# Changes:
# Who         When           What
# MvdA        2026-06-02     Initial Creation.
#
################################################################################
#
#
#
SCRIPTPATH=$(dirname $0)
GENERIC_DIR=${SCRIPTPATH}/../Generic
. ${GENERIC_DIR}/bash_helper_functions.sh

# Show usage info
function usage() {
        logerror "$0: $1"
        logwarn "usage $0 -n RELEASE_NAME -r RELEASE_NR -l RELEASE_DIR"
        exit 1
}

# Check Arguments
function check_args(){
  while getopts "n:r:l:" arg; do
          case $arg in
                  n) export RELEASE_NAME=$OPTARG         ;;
                  r) export RELEASE_NR=$OPTARG           ;;
                  l) export RELEASE_DIR=$OPTARG          ;;
                  *) usage "Unexpected argument: ${arg}" ;;
          esac
  done
  if [ -z ${RELEASE_NAME:+x} ]; then
    usage "Provide RELEASE_NAME"
  fi
  if [ -z ${RELEASE_NR:+x} ]; then
    usage "Provide RELEASE_NR"
  fi
  if [ -z ${RELEASE_DIR:+x} ]; then
    usage "Provide RELEASE_DIR"
  fi
  if [ -z ${FMW_HOME:+x} ]; then
    usage "export FMW_HOME to a Fusion Middleware (WebLogic or JDeveloper) Home folder"
  fi
  if [ -z ${JAVA_HOME:+x} ]; then
    usage "export JAVA_HOME to a supported JDK home (Java 8 for FMW 12.2.1.4, Java 17+ for FMW 14.1.2.0+)"
  fi
    if [ -s "${ANT_HOME}\bin\ant" ]; then
    usage "Ant not found in ${ANT_HOME}\bin"
  fi
  export OSB_OPTS=""
  export OSB_OPTS+=" -Dweblogic.home=${WL_HOME}/server -Dosb.home=${OSB_HOME}"
  # export OSB_OPTS+=" -Djava.util.logging.config.class=oracle.core.ojdl.logging.LoggingConfiguration"
  # export OSB_OPTS+=" -Doracle.core.ojdl.logging.config.file=${CONFIGJAR_HOME}/logging.xml"

  export JAVA_OPTS+=" ${OSB_OPTS}"
  export ANT_OPTS+=" ${OSB_OPTS}"

  set -euo pipefail
}

function main(){
  check_args "$@"
  loginfo "Start releasing..."
  logdebug "FMW_HOME=${FMW_HOME}"
  logdebug "JAVA_HOME=${JAVA_HOME}"
  logdebug "ANT_HOME=${ANT_HOME}"
  logdebug "ANT_OPTS=${ANT_OPTS}"
  echo "Call ant for project ${RELEASE_NAME} and release ${RELEASE_NR} from release home ${RELEASE_DIR}"
  ant -f build.xml -DreleaseName=${RELEASE_NAME} -Drelease=${RELEASE_NR}  -DreleaseDir=${RELEASE_DIR}
}

main "$@"