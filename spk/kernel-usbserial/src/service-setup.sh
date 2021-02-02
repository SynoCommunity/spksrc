
service_postinst ()
{
    # install lsusb only when not available
    if [ "$(which lsusb)" == "" -a -e "${SYNOPKG_PKGDEST}/bin/lsusb" ]; then
        mkdir -p /usr/local/bin  >> "${INST_LOG}"
        echo "create link: /usr/local/bin/lsusb -> ${SYNOPKG_PKGDEST}/bin/lsusb"  >> "${INST_LOG}"
        ln -s "${SYNOPKG_PKGDEST}/bin/lsusb" "/usr/local/bin/lsusb"  >> "${INST_LOG}"
    fi
}

service_postuninst ()
{
    # remove optionally created link
    if [ -L "/usr/local/bin/lsusb" ]; then
        if [ "$(readlink /usr/local/bin/lsusb})" == "${SYNOPKG_PKGDEST}/bin/lsusb" ]; then
            echo "remove link: /usr/local/bin/lsusb -> ${SYNOPKG_PKGDEST}/bin/lsusb"  >> "${INST_LOG}"
            rm -f "/usr/local/bin/lsusb"   >> "${INST_LOG}" 
        fi
    fi

    # ensure to remove rules for USB serial permissions, created at service start
    rm -f /lib/udev/rules.d/60-jadahl.usbserial.rules   >> "${INST_LOG}"
    exit 0
}
