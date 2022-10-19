PYTHON_DIR="/var/packages/python310/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"
HOME="${SYNOPKG_PKGVAR}"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python3"
SC_BINARY="${SYNOPKG_PKGDEST}/env/bin/SickChill"
SC_DATA_DIR="${SYNOPKG_PKGVAR}/data"
SC_CFG_FILE="${SC_DATA_DIR}/config.ini"

GROUP="sc-download"

SERVICE_COMMAND="${SC_BINARY} --daemon --nolaunch --pidfile ${PID_FILE} --config ${SC_CFG_FILE} --datadir ${SC_DATA_DIR}"
separator="-----------------------------------------------"

set_config() {
    if [ -f "${SC_CFG_FILE}" ]; then
        if [ -n "${wizard_username}" ] && [ -n "${wizard_password}" ]; then
            sed -i "/^\s*web_username\s*=/s/\s*=\s*.*/ = ${wizard_username}/" ${SC_CFG_FILE}
            sed -i "/^\s*web_password\s*=/s/\s*=\s*.*/ = ${wizard_password}/" ${SC_CFG_FILE}
        fi
    else
        mkdir -p ${SC_DATA_DIR}
        cat << EOF > ${SC_CFG_FILE}
[General]
web_username = ${wizard_username}
web_password = ${wizard_password}
EOF
    fi
}

service_postinst() {
    echo ${separator}
    install_python_virtualenv

    echo ${separator}
    install_python_wheels

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        set_config
    fi

    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        set_unix_permissions "${SYNOPKG_PKGDEST}"
    fi
}

service_postupgrade() {
    set_config
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
      set_unix_permissions "${SYNOPKG_PKGDEST}"
    fi
}

service_postuninst ()
{
    # Do this as ${SYNOPKG_PKGDEST}/tmp folder not removed and should be.
    rm -rf "${SYNOPKG_PKGDEST}"
}
