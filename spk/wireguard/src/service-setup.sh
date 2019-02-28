service_postinst () {
    # Put wg in the PATH
    ln -fs /var/packages/${SYNOPKG_PKGNAME}/target/bin/wg /usr/local/bin/wg >> "${INST_LOG}" 2>&1
}

service_postuninst () {
    # Remove link
    rm -f /usr/local/bin/wg
}
