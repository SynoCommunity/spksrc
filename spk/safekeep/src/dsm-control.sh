#!/bin/sh

# Package
PACKAGE="safekeep"
DNAME="SafeKeep"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
PYTHON="${INSTALL_DIR}/env/bin/python"

case $1 in
    start)
        exit 0
        ;;
    stop)
        exit 0
        ;;
    status)
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
