CFG_FILE="/usr/local/${SYNOPKG_PKGNAME}/etc/synokernel-usbserial.ini"
UDEV_RULE=60-synokernel-usbserial.rules

write_config() {
    # Drop variables into a configuration file
    echo "default=true"                          > ${CFG_FILE}
    echo "ch341=${ch341}"                       >> ${CFG_FILE}
    echo "cdc_acm=${cdc_acm}"                   >> ${CFG_FILE}
    echo "cp210x=${cp210x}"                     >> ${CFG_FILE}
    echo "ftdi_sio=${ftdi_sio}"                 >> ${CFG_FILE}
    echo "pl2303=${pl2303}"                     >> ${CFG_FILE}
    echo "ti_usb_3410_5052=${ti_usb_3410_5052}" >> ${CFG_FILE}
}

service_postinst() {
    [ ! -f ${CFG_FILE} ] && mkdir -p /usr/local/${SYNOPKG_PKGNAME}/etc
    write_config
}

service_preupgrade() {
    [ -f ${CFG_FILE} ] && mv ${CFG_FILE} /tmp/synokernel-usbserial.ini
}

service_postupgrade() {
    if [ ! -f ${CFG_FILE} ]; then
        mkdir -p /usr/local/${SYNOPKG_PKGNAME}/etc
        mv /tmp/synokernel-usbserial.ini /usr/local/${SYNOPKG_PKGNAME}/etc
    fi
    write_config
}

service_postuninst ()
{
    # ensure to remove rules for USB serial permissions, created at service start
    rm -f /lib/udev/rules.d/${UDEV_RULE}   >> "${INST_LOG}"
    exit 0
}
