#!/bin/sh

# Package
PACKAGE="helloworld"
DNAME="HelloWorld"

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
        echo "${INSTALL_DIR}/install.log"
        exit 0
    ;;
esac
