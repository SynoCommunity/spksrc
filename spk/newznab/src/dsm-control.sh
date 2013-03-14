#!/bin/sh

# Package
PACKAGE="newznab"
DNAME="Newznab"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web"
ENABLED_FILE="/var/packages/${PACKAGE}/enabled"

daemon_status ()
{
    if [ -f ${ENABLED_FILE} ]; then
        return
    fi
    return 1
}


case $1 in
    start)
        exit 0
        ;;
    stop)
        exit 0
        ;;
    status)
        if daemon_status; then
            echo ${DNAME} is running
            exit 0
        else
            echo ${DNAME} is not running
            exit 1
        fi
        ;;
    log)
        exit 1
        ;;
    *)
        exit 1
        ;;
esac
