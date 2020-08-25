#!/bin/sh

# Package
PACKAGE="linuxtv"
DNAME="LinuxTV"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
LINUXTV="${INSTALL_DIR}/bin/linuxtv.sh -n $DNAME -a"

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
        ${LINUXTV} load $KO
        exit $?
        ;;
    stop)
        ${LINUXTV}unload $KO
        exit $?
        ;;
    restart)
        ${LINUXTV} unload $KO
        ${LINUXTV} load $KO
        exit $?
        ;;
    status)
        if ${LINUXTV} status $KO; then
            exit 0
        else
            exit 1
        fi
        ;;
    *)
        exit 1
        ;;
esac
