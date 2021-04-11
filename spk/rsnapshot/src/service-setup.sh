
service_postinst ()
{
    # Copy default config file
    if [ ! -e ${SYNOPKG_PKGDEST}/etc/rsnapshot.conf ]; then
        cp ${SYNOPKG_PKGDEST}/etc/rsnapshot.conf.default ${SYNOPKG_PKGDEST}/etc/rsnapshot.conf
    fi
}

service_save ()
{
    # Save configuration
    $CP ${SYNOPKG_PKGDEST}/etc/rsnapshot.conf "${TMP_DIR}"/rsnapshot.conf
}

service_restore ()
{
    # Restore configuration
    $MV "${TMP_DIR}"/rsnapshot.conf ${SYNOPKG_PKGDEST}/etc/rsnapshot.conf
}

service_postupgrade ()
{
    # Upgrade configuration file if needed
    ${SYNOPKG_PKGDEST}/bin/rsnapshot upgrade-config-file
}

