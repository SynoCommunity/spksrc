#!/bin/sh

# Package
PACKAGE="UsbSerialDrivers"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"


case $1 in
    start)

        insmod /lib/modules/usbserial.ko > /dev/null
        insmod /lib/modules/ftdi_sio.ko >/dev/null	
        insmod ${INSTALL_DIR}/modules/cp210x.ko >/dev/null
        insmod ${INSTALL_DIR}/modules/pl2303.ko >/dev/null
        insmod ${INSTALL_DIR}/modules/ch341.ko >/dev/null
        insmod ${INSTALL_DIR}/modules/ti_usb_3410_5052.ko >/dev/null

        # Create udev rules to set permissions to 666 
        # Doing this at package start so it gets done even after DSM upgrade.  
        ln -s ${INSTALL_DIR}/rules.d/60-jadahl.usbserial.rules /lib/udev/rules.d/60-jadahl.usbserial.rules
        udevadm control --reload-rules

        exit 0
        ;;
    stop)
        # remove udev rules for USB serial permissions
        rm -f /lib/udev/rules.d/60-jadahl.usbserial.rules	
        udevadm control --reload-rules
        exit 0
        ;;
    status)
        exit 0
        ;;
    log)
        exit 1
        ;;
    *)
        exit 1
        ;;
esac
