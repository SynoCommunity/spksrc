
service_postinst ()
{
    if [ ! -e ${SYNOPKG_PKGDEST}/etc/rsnapshot.conf ]; then
        echo "Create rsnapshot.conf from rsnapshot.conf.default"
        $CP ${SYNOPKG_PKGDEST}/etc/rsnapshot.conf.default ${SYNOPKG_PKGDEST}/etc/rsnapshot.conf
    fi
}

service_save ()
{
    echo "Save rsnapshot.conf to ${TMP_DIR}"
    $CP ${SYNOPKG_PKGDEST}/etc/rsnapshot.conf "${TMP_DIR}/rsnapshot.conf"
}

service_restore ()
{
    echo "Restore rsnapshot.conf from ${TMP_DIR}"
    $MV "${TMP_DIR}/rsnapshot.conf" ${SYNOPKG_PKGDEST}/etc/rsnapshot.conf
}

service_postupgrade ()
{
    echo "Provide configuration file upgrade"
    ${SYNOPKG_PKGDEST}/bin/rsnapshot upgrade-config-file
}

