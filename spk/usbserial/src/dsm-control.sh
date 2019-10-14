#!/bin/sh

# Package
PACKAGE="UsbSerialDrivers"
DNAME="UsbSerialDrivers"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
RUNAS="root"
    

case $1 in
    start)

    insmod /lib/modules/usbserial.ko > /dev/null
    insmod /lib/modules/ftdi_sio.ko >/dev/null	
   #insmod ${INSTALL_DIR}/modules/usbserial.ko >/dev/null
   #insmod ${INSTALL_DIR}/modules/ftdi_sio.ko >/dev/null	
    insmod ${INSTALL_DIR}/modules/cp210x.ko >/dev/null
    insmod ${INSTALL_DIR}/modules/pl2303.ko >/dev/null
    insmod ${INSTALL_DIR}/modules/ch341.ko >/dev/null
    insmod ${INSTALL_DIR}/modules/ti_usb_3410_5052.ko >/dev/null

if [ `/bin/get_key_value /etc.defaults/VERSION buildnumber` -ge "5004" ]; then
        # Create udev rules to set permissions to 666 
        # Doing this at package start so it gets done even after DSM upgrade.  
        ln -s ${INSTALL_DIR}/rules.d/60-jadahl.usbserial.rules /lib/udev/rules.d/60-jadahl.usbserial.rules
	udevadm control --reload-rules
    else
        # DSM 5.0 and earlier versions don't dynamically create devices, so create device for everything before build 5004.
        for NR in 0 1 2 3 4 5 6 7
        do
            test -e /dev/ttyUSB${NR} || mknod -m 666 /dev/ttyUSB${NR} c 188 ${NR}
        done

	for NR in 0 1 2 
        do
            test -e /dev/ttyACM${NR} || mknod -m 666 /dev/ttyACM${NR} c 166 ${NR}
        done
    
    fi

        exit 0
        ;;
    stop)
    
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
