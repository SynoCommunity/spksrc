
service_preupgrade ()
{
    # Save configuration
    rm -fr ${TMP_DIR}/${SYNOPKG_PKGNAME}
    mkdir -p ${TMP_DIR}/${SYNOPKG_PKGNAME}
    mv ${SYNOPKG_PKGDEST}/etc/irssi.conf ${TMP_DIR}/${SYNOPKG_PKGNAME}/irssi.conf

    exit 0
}

service_postupgrade ()
{
    # Restore configuration
    mv ${TMP_DIR}/${SYNOPKG_PKGNAME}/irssi.conf ${SYNOPKG_PKGDEST}/etc/irssi.conf
    rm -fr ${TMP_DIR}/${SYNOPKG_PKGNAME}

    exit 0
}
