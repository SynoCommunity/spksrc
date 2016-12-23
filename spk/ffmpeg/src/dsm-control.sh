#!/bin/sh

# Package
PACKAGE="ffmpeg"
DNAME="ffmpeg"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}/bin/"

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
esac
