#!/bin/sh

# Package
PACKAGE="mc"
DNAME="Midnight Commander"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"


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
