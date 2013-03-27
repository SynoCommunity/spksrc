#!/bin/sh

# Package
PACKAGE="owncloud"
DNAME="ownCloud"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web"
LOG_FILE="${WEB_DIR}/${PACKAGE}/data/${PACKAGE}.log"


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
        echo ${LOG_FILE}
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
