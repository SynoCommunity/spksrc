#!/bin/sh

INSTALL_DIR="/usr/local/${PACKAGE}"
CPUMINER="${INSTALL_DIR}/bin/minerd"
CFG_FILE="${INSTALL_DIR}/var/settings.json"

${CPUMINER} -c ${CFG_FILE} -t 4