CFG_FILE="/usr/local/${SYNOPKG_PKGNAME}/etc/${SYNOPKG_PKGNAME}.ini"
UDEV_RULE=60-${SYNOPKG_PKGNAME}.rules

write_config() {
    # Drop variables into a configuration file
    echo "default=true"                                       > ${CFG_FILE}
    echo "HAUPPAUGE_WINTV_DUALHD=${HAUPPAUGE_WINTV_DUALHD}"  >> ${CFG_FILE}
    echo "MYGICA_T230A=${MYGICA_T230A}"                      >> ${CFG_FILE}
}

service_postinst() {
    [ ! -f ${CFG_FILE} ] && mkdir -p /usr/local/${SYNOPKG_PKGNAME}/etc
    write_config
}

service_preupgrade() {
    [ -f ${CFG_FILE} ] && mv ${CFG_FILE} /tmp/${SYNOPKG_PKGNAME}.ini
}

service_postupgrade() {
    if [ ! -f ${CFG_FILE} ]; then
        mkdir -p /usr/local/${SYNOPKG_PKGNAME}/etc
        mv /tmp/${SYNOPKG_PKGNAME}.ini /usr/local/${SYNOPKG_PKGNAME}/etc
    fi
    write_config
}

service_postuninst ()
{
    # ensure to remove rules for USB serial permissions, created at service start
    rm -f /lib/udev/rules.d/${UDEV_RULE}   >> "${INST_LOG}"
    exit 0
}
