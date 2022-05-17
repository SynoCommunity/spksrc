
VMTOOLS_DAEMON="${SYNOPKG_PKGDEST}/bin/vmtoolsd"
CONF_FILE=${SYNOPKG_PKGVAR}/tools.conf

PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"

SERVICE_COMMAND="${VMTOOLS_DAEMON} -b ${PID_FILE} -c ${CONF_FILE}"

service_postinst ()
{
    # create link for etc and lib
    [ -e /etc/vmware-tools ] || ln -s ${SYNOPKG_PKGDEST}/etc/vmware-tools /etc/vmware-tools
    [ -e /lib/open-vm-tools ] || ln -s ${SYNOPKG_PKGDEST}/lib/open-vm-tools /lib/open-vm-tools
    if [ ! -e /lib/udev/rules.d/99-vmware-scsi-udev.rules ]; then
        ln -s ${SYNOPKG_PKGDEST}/lib/udev/rules.d/99-vmware-scsi-udev.rules /lib/udev/rules.d/99-vmware-scsi-udev.rules
        udevadm control --reload
    fi

    cat > ${CONF_FILE} << EOF
bindir = "${SYNOPKG_PKGDEST}/bin"	
libdir = "${SYNOPKG_PKGDEST}/lib"
EOF
}

service_postuninst ()
{
    # Remove link for etc and lib
    [ -L /etc/vmware-tools ] && rm -f /etc/vmware-tools
    [ -L /lib/open-vm-tools ] && rm -f /lib/open-vm-tools
    if [ -L /lib/udev/rules.d/99-vmware-scsi-udev.rules ]; then
        rm -f /lib/udev/rules.d/99-vmware-scsi-udev.rules
        udevadm control --reload
    fi
}
