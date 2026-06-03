#!/bin/bash
################################################################################
# Helper functions for bash
#
# @Author: Martien van den Akker, Oracle Netherlands B.V.
#
# Changes:
# Who         When           What
# MvdA        2026-06-02     Initial Creation.
################################################################################
#
export LOG_LVL_DEBUG="DEBUG"
export LOG_LVL_INFO="INFO"
export LOG_LVL_WARN="WARN"
export LOG_LVL_ERROR="ERROR"

#
# Do standard echo
function log() {
  local environment=${OCI_ENVIRONMENT:-""}
  local log_level=$1
  echo "[`date +%Y-%m-%d' '%T`] [$log_level] ${@:2}"
} # end log ()

# Log a debug message
function logdebug() {
  log $LOG_LVL_DEBUG "$*"
}

# Log an informational
function loginfo() {
  log $LOG_LVL_INFO "$*"
}

# Log a warning
function logwarn() {
  log $LOG_LVL_WARN "$*"
}

# Log an error
function logerror() {
  log $LOG_LVL_ERROR "$*"
}