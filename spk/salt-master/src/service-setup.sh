# Define python312 binary path
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:/var/packages/python312/target/bin:${PATH}"
export LANG=en_US.UTF-8

SALT_CONFIG="/var/packages/${SYNOPKG_PKGNAME}/etc"
SALT_RUN_DIR="${SYNOPKG_PKGVAR}/run"
PID_FILE_MASTER="${SALT_RUN_DIR}/salt-master.pid"
PID_FILE_API="${SALT_RUN_DIR}/salt-api.pid"
MASTER_SOCKET="${SALT_RUN_DIR}/master/master_event_pub.ipc"

# Wait for a file to exist (with timeout)
wait_for_file()
{
    timeout=${2:-10}
    while [ $timeout -gt 0 ] && [ ! -e "$1" ]; do
        sleep 1
        timeout=$((timeout - 1))
    done
    [ -e "$1" ]
}

service_prestart()
{
    # Clean up stale PID files from previous run
    rm -f "${PID_FILE_MASTER}" "${PID_FILE_API}" "${PID_FILE}"

    # Start salt-master and wait for IPC socket (indicates readiness)
    salt-master --pid-file "${PID_FILE_MASTER}" -c "${SALT_CONFIG}" -d
    wait_for_file "${MASTER_SOCKET}" 15

    # Start salt-api (requires salt-master to be ready)
    salt-api --pid-file "${PID_FILE_API}" -c "${SALT_CONFIG}" -d
    wait_for_file "${PID_FILE_API}" 10

    # Combine PIDs for framework's stop handling (one PID per line)
    { cat "${PID_FILE_MASTER}"; echo; cat "${PID_FILE_API}"; } > "${PID_FILE}" 2>/dev/null
}

service_poststop()
{
    rm -f "${PID_FILE_MASTER}" "${PID_FILE_API}"
}

service_preupgrade()
{
    # Remove saltgui folder to allow clean upgrade (static web assets, not user config)
    rm -rf "${SYNOPKG_PKGVAR}/saltgui"
}

service_postinst()
{
    install_python_virtualenv
    install_python_wheels

    # Patch rsax931.py to find libcrypto from python312
    python ${SYNOPKG_PKGDEST}/env/lib/python3.12/site-packages/patch_ng.py \
           --directory=${SYNOPKG_PKGDEST}/env/lib/python3.12/site-packages/salt/utils \
           ${SYNOPKG_PKGDEST}/share/rsax931.py.patch

    # Initialize configuration directory
    install -m 755 -d "${SALT_CONFIG}/master.d"
    [ -f "${SALT_CONFIG}/master" ] || install -m 644 "${SYNOPKG_PKGDEST}/share/master" "${SALT_CONFIG}/master"

    # Create default configuration (only if not already present)
    for conf in \
        "01_pidfile.conf:pidfile: run" \
        "02_sockdir.conf:sock_dir: run/master" \
        "03_cachedir.conf:cachedir: cache" \
        "04_logging.conf:log_file: ${SYNOPKG_PKGNAME}.log" \
        "05_loglevel.conf:log_level_logfile: info" \
        "06_pkidir.conf:pki_dir: pki/master" \
        "07_rootdir.conf:root_dir: ${SYNOPKG_PKGVAR}" \
        "08_extmodsdir.conf:extension_modules: extensions"
    do
        file="${SALT_CONFIG}/master.d/${conf%%:*}"
        [ -f "$file" ] || echo "${conf#*:}" > "$file"
    done
}
