
service_postinst ()
{
    if [ ! -e ${SYNOPKG_PKGVAR}/rsnapshot.conf ]; then
        echo "Create rsnapshot.conf from rsnapshot.conf.default"
        $CP ${SYNOPKG_PKGVAR}/rsnapshot.conf.default ${SYNOPKG_PKGVAR}/rsnapshot.conf
    fi
}

if [ "${SYNOPKG_PKG_STATUS}" != "INSTALL" ] && [ "$(echo ${SYNOPKG_OLD_PKGVER} | sed -r 's/^.*-([0-9]+)$/\1/')" -le 3 ]; then

    # custom save/restore for former packages with config in etc folder
    service_save ()
    {
        if [ -e ${SYNOPKG_PKGDEST}/etc/rsnapshot.conf ]; then
            echo "Save rsnapshot.conf to ${TMP_DIR}"
            $CP ${SYNOPKG_PKGDEST}/etc/rsnapshot.conf "${TMP_DIR}/rsnapshot.conf"
        fi
    }

    service_restore ()
    {
        if [ -e "${TMP_DIR}/rsnapshot.conf" ]; then
            echo "Restore rsnapshot.conf from ${TMP_DIR}"
            $MV "${TMP_DIR}/rsnapshot.conf" ${SYNOPKG_PKGVAR}/rsnapshot.conf
        fi
    }
fi

service_postupgrade ()
{
    echo "Provide configuration file upgrade"
    ${SYNOPKG_PKGDEST}/bin/rsnapshot upgrade-config-file
}

