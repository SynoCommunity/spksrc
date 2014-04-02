#!/bin/sh

INSTALL_DIR="/usr/local/${PACKAGE}"
CPUMINER="${INSTALL_DIR}/bin/minerd"
CFG_FILE="${INSTALL_DIR}/var/settings.json"
LOG_FILE="${INSTALL_DIR}/var/cpuminer.log"

${CPUMINER} -c ${CFG_FILE} -t 1 2> ${LOG_FILE}