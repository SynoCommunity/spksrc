#!/bin/sh

# Package
PACKAGE="synokernel-linuxtv"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
FIRMWARE_PATH="/var/packages/${PACKAGE}/target/lib/firmware/"
SYNOCLI_KMODULE="/usr/local/bin/synocli-kernelmodule -n ${PACKAGE} -f ${FIRMWARE_PATH} -a"

KO="media/rc/rc-core.ko \
    media/mc/mc.ko \
    media/v4l2-core/videodev.ko \
    media/common/tveeprom.ko \
    media/common/videobuf2/videobuf2-common.ko \
    media/common/videobuf2/videobuf2-v4l2.ko \
    media/common/videobuf2/videobuf2-memops.ko \
    media/common/videobuf2/videobuf2-vmalloc.ko \
    media/dvb-core/dvb-core.ko \
    media/tuners/si2157.ko \
    media/dvb-frontends/lgdt3306a.ko \
    media/usb/em28xx/em28xx.ko \
    media/usb/em28xx/em28xx-dvb.ko"

case $1 in
    start)
        ${SYNOCLI_KMODULE} load $KO
        exit $?
        ;;
    stop)
        ${SYNOCLI_KMODULE}unload $KO
        exit $?
        ;;
    restart)
        ${SYNOCLI_KMODULE} unload $KO
        ${SYNOCLI_KMODULE} load $KO
        exit $?
        ;;
    status)
        if ${SYNOCLI_KMODULE} status $KO; then
            exit 0
        else
            exit 1
        fi
        ;;
    *)
        exit 1
        ;;
esac
