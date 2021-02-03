#!/bin/sh

# Package
PACKAGE="synokernel-usbserial"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
SYNOCLI_KMODULE="/usr/local/bin/synocli-kernelmodule -n ${PACKAGE} -a"
UDEV_RULE=60-${PACKAGE}.rules

KO="usb/serial/usbserial.ko \
    usb/serial/ftdi_sio.ko \
    usb/serial/cp210x.ko \
    usb/serial/pl2303.ko \
    usb/serial/ch341.ko \
    usb/serial/ti_usb_3410_5052.ko"

case $1 in
    start)
        ${SYNOCLI_KMODULE} load $KO

        # Create udev rules to set permissions to 666 
        # Doing this at package start so it gets done even after DSM upgrade.  
        ln -s ${INSTALL_DIR}/rules.d/${UDEV_RULE} /lib/udev/rules.d/${UDEV_RULE}
        udevadm control --reload-rules

        exit $?
        ;;
    stop)
        ${SYNOCLI_KMODULE}unload $KO

        # remove udev rules for USB serial permissions
        rm -f /lib/udev/rules.d/${UDEV_RULE}
        udevadm control --reload-rules

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
