#!/bin/sh

# Package
PACKAGE="bazarr"
DNAME="Bazarr"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="${INSTALL_DIR}/env"
GIT_DIR="/usr/local/git"
BAZARR_DIR="${INSTALL_DIR}/share/${PACKAGE}"
PID_FILE="${INSTALL_DIR}/var/bazarr.pid"

export PATH="${GIT_DIR}/bin:${PYTHON_DIR}/bin:${INSTALL_DIR}/bin:${PATH}";
