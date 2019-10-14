#!/bin/sh

# Package
PACKAGE="UsbSerialDrivers"
DNAME="UsbSerialDrivers"
USBUTILS_TARGET="/usr/bin/${PACKAGE}"
USBUTILS_TARGET="/usr/bin/lsusb"
USBUTILS_TARGET1="/usr/bin/usb-devices"
# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
preinst ()
{
    exit 0
}

postinst ()
{
  
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}
    if [ ! -e "$USBUTILS" ]; then
            ln -s ${INSTALL_DIR}/bin/lsusb ${USBUTILS_TARGET}
	    ln -s ${INSTALL_DIR}/bin/usb-devices ${USBUTILS_TARGET1}
            
    fi
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}
    exit 0
}

preuninst ()
{
    rm -f ${INSTALL_DIR}
    rm -f ${USBUTILS_TARGET}
    rm -f ${USBUTILS_TARGET1}
    exit 0
}

postuninst ()
{ 
    # Remove link
    rm -f ${INSTALL_DIR}
    # remove rules for USB serial permission setting
    rm -f /lib/udev/rules.d/60-jadahl.usbserial.rules	
    exit 0
}

preupgrade ()
{
    exit 0
}

postupgrade ()
{
    exit 0
}

