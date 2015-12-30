#!/bin/sh

# Package
PACKAGE="letsencrypt"
DNAME="Lets Encrypt"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PACKAGE_LOG="${INSTALL_DIR}/var/package.log"

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
        echo "${PACKAGE_LOG}"
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
