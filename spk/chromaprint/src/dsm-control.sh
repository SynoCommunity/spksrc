#!/bin/sh

# Package
PACKAGE="chromaprint"
DNAME="Chromaprint"

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
        exit 0
        ;;
    log)
        exit 0
        ;;
    *)
        exit 1
        ;;
esac

