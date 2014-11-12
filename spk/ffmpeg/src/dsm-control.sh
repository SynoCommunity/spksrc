#!/bin/sh

# Package
PACKAGE="ffmpeg"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}/bin/"
FFMPEG_TARGET="/usr/bin/${PACKAGE}"
FFSERVER_TARGET="/usr/bin/ffserver"

FFPROBE_TARGET="/usr/bin/ffprobe"

start_daemon ()
{
    if [ ! -e "${FFMPEG_TARGET}" ]; then
        ln -s ${INSTALL_DIR}/ffmpeg ${FFMPEG_TARGET}
    fi
    if [ ! -e "${FFPROBE_TARGET}" ]; then
        ln -s ${INSTALL_DIR}/ffprobe ${FFPROBE_TARGET}
    fi
    if [ ! -e "${FFSERVER_TARGET}" ]; then
        ln -s ${INSTALL_DIR}/ffserver ${FFSERVER_TARGET}
    fi
}

stop_daemon ()
{
    rm -f ${FFMPEG_TARGET}
    rm -f ${FFPROBE_TARGET}
    rm -f ${FFSERVER_TARGET}
}


case $1 in
    start)
        start_daemon
        exit 0
    ;;
    stop)
        stop_daemon
        exit 0
    ;;
    status)
    if [ -e ${FFMPEG_TARGET} ]; then
        exit 0
    else
        exit 1
    fi
    ;;
    log)
        exit 0
    ;;
esac
