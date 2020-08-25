#!/bin/sh

# Package
PACKAGE="linuxtv"
DNAME="LinuxTV"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
LINUXTV="${INSTALL_DIR}/bin/linuxtv.sh"

KO="rc/rc-core.ko \
    mc/mc.ko \
    v4l2-core/videodev.ko \
    common/tveeprom.ko \
    common/videobuf2/videobuf2-common.ko \
    common/videobuf2/videobuf2-v4l2.ko \
    common/videobuf2/videobuf2-memops.ko \
    common/videobuf2/videobuf2-vmalloc.ko \
    dvb-core/dvb-core.ko"

case $1 in
    start)
        if ${LINUXTV} status; then
            echo ${DNAME} is already running
            exit 0
        else
            echo Starting ${DNAME} ...
            ${LINUXTV} load $KO
            exit $?
        fi
        ;;
    stop)
        if ${LINUXTV} status; then
            echo Stopping ${DNAME} ...
            ${LINUXTV} unload $KO
            exit $?
        else
            echo ${DNAME} is not running
            exit 0
        fi
        ;;
    restart)
        ${LINUXTV} unload $KO
        ${LINUXTV} load $KO
        exit $?
        ;;
    status)
        if ${LINUXTV} status; then
            echo ${DNAME} is running
            exit 0
        else
            echo ${DNAME} is not running
            exit 1
        fi
        ;;
    *)
        exit 1
        ;;
esac
