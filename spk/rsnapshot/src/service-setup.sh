service_postinst ()
{
    # Add symbolic links
    mkdir -p /usr/local/bin
    ln -s ${SYNOPKG_PKGDEST}/bin/rsnapshot /usr/local/bin/rsnapshot
    ln -s ${SYNOPKG_PKGDEST}/bin/rsnapshot-diff /usr/local/bin/rsnapshot-diff

    # Copy default config file
    if [ ! -e ${SYNOPKG_PKGDEST}/etc/rsnapshot.conf ]; then
        cp ${SYNOPKG_PKGDEST}/etc/rsnapshot.conf.default ${SYNOPKG_PKGDEST}/etc/rsnapshot.conf
    fi
}

service_postuninst ()
{
    # Remove links
    rm /usr/local/bin/rsnapshot
    rm /usr/local/bin/rsnapshot-diff
}

service_save ()
{
    # Save configuration
    $CP ${SYNOPKG_PKGDEST}/etc/rsnapshot.conf "${TMP_DIR}"/rsnapshot.conf >> ${INST_LOG}
}

service_restore ()
{
    # Restore configuration
    $MV "${TMP_DIR}"/rsnapshot.conf ${SYNOPKG_PKGDEST}/etc/rsnapshot.conf >> ${INST_LOG}
}

service_postupgrade ()
{
    # Upgrade configuration file if needed
    ${SYNOPKG_PKGDEST}/bin/rsnapshot upgrade-config-file >> ${INST_LOG}
}
