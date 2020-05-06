
# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts
VMTOOLS_DIR="/usr/local/${SYNOPKG_PKGNAME}"
VMTOOLS_DAEMON="${VMTOOLS_DIR}/bin/vmtoolsd"
CONF_FILE=/etc/vmware-tools/tools.conf

PATH="${VMTOOLS_DIR}/bin:${PATH}"

SERVICE_COMMAND="${VMTOOLS_DAEMON} -b ${PID_FILE} -c ${CONF_FILE}"

service_postinst ()
{
    # Symlink
    ln -s ${SYNOPKG_PKGDEST} ${VMTOOLS_DIR}

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
    # Remove link
    rm -f ${VMTOOLS_DIR}

    # Remove link for etc and lib
    [ -L /etc/vmware-tools ] && rm -f /etc/vmware-tools
    [ -L /lib/open-vm-tools ] && rm -f /lib/open-vm-tools
    if [ -L /lib/udev/rules.d/99-vmware-scsi-udev.rules ]; then
        rm -f /lib/udev/rules.d/99-vmware-scsi-udev.rules
        udevadm control --reload
    fi
}
