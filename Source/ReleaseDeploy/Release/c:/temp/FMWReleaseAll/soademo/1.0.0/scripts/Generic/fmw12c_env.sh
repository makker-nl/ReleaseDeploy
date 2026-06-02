#!/bin/bash
echo set Jdeveloper SOA Quickstart 12cR2 environment
export ORACLE_BASE=/app/oracle
export JAVA_HOME=$ORACLE_BASE/product/jdk8
export FMW_HOME=$ORACLE_BASE/product/jdeveloper/12214_SOAQS
export JDEV_USER_HOME_SOA=/home/oracle/JDeveloper/SOA
export JDEV_USER_DIR_SOA=/home/oracle/JDeveloper/SOA
export OSB_HOME=${FMW_HOME}/osb
. ${FMW_HOME}/oracle_common/common/bin/setWlstEnv.sh
export PATH=${FMW_HOME}/oracle_common/common/bin:${PATH}