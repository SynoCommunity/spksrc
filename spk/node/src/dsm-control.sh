#!/bin/sh

# Package
PACKAGE="node"
DNAME="Node.js"


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
	echo "${INSTALL_DIR}/install.log"
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
