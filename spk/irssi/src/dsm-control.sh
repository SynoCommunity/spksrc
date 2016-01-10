#!/bin/sh

# Package
PACKAGE="irssi"
DNAME="Irssi"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"


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
    log)
        exit 1
        ;;
    *)
        exit 1
        ;;
esac
