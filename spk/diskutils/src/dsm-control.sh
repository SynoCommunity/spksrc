#!/bin/sh

# Package
PACKAGE="diskutils"
DNAME="Disk Utils"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"


case $1 in
    start)
        exit 0
        ;;
    stop)
        exit 0
        ;;
    status)
        exit 1
        ;;
    log)
        exit 1
        ;;
    *)
        exit 1
        ;;
esac
