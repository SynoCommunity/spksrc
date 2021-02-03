UDEV_RULE=60-synokernel-usbserial.rules

service_postuninst ()
{
    # ensure to remove rules for USB serial permissions, created at service start
    rm -f /lib/udev/rules.d/${UDEV_RULE}   >> "${INST_LOG}"
    exit 0
}
