# Define python312 binary path
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:/var/packages/python312/target/bin:${PATH}"
export LANG=en_US.UTF-8

SALT_CONFIG="/var/packages/${SYNOPKG_PKGNAME}/etc"

SERVICE_COMMAND="salt-minion --pid-file ${PID_FILE} -c ${SALT_CONFIG} -d"

service_postinst()
{
    install_python_virtualenv
    install_python_wheels

    # Patch rsax931.py to find libcrypto from python312
    python ${SYNOPKG_PKGDEST}/env/lib/python3.12/site-packages/patch_ng.py \
           --directory=${SYNOPKG_PKGDEST}/env/lib/python3.12/site-packages/salt/utils \
           ${SYNOPKG_PKGDEST}/share/rsax931.py.patch

    # Initialize configuration directory
    install -m 755 -d "${SALT_CONFIG}/minion.d"
    [ -f "${SALT_CONFIG}/minion" ] || install -m 644 "${SYNOPKG_PKGDEST}/share/minion" "${SALT_CONFIG}/minion"
    [ -f "${SALT_CONFIG}/proxy" ] || install -m 644 "${SYNOPKG_PKGDEST}/share/proxy" "${SALT_CONFIG}/proxy"

    # Create default configuration (only if not already present)
    for conf in \
        "01_pidfile.conf:pidfile: run" \
        "02_sockdir.conf:sock_dir: run/minion" \
        "03_cachedir.conf:cachedir: cache" \
        "04_logging.conf:log_file: ${SYNOPKG_PKGNAME}.log" \
        "05_loglevel.conf:log_level_logfile: info" \
        "06_pkidir.conf:pki_dir: pki/minion" \
        "07_rootdir.conf:root_dir: ${SYNOPKG_PKGVAR}" \
        "98-minion-id.conf:id: $(hostname -s)" \
        "99-master-address.conf:master: localhost"
    do
        file="${SALT_CONFIG}/minion.d/${conf%%:*}"
        [ -f "$file" ] || echo "${conf#*:}" > "$file"
    done
}
