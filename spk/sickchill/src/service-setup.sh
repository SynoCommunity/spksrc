PACKAGE="sickchill"
TMP_DIR="/tmp/${PACKAGE}"
PYTHON_DIR="/var/packages/python310/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"
HOME="${SYNOPKG_PKGVAR}"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python3"
SC_BINARY="${SYNOPKG_PKGDEST}/env/bin/SickChill"
SC_DATA_DIR="${SYNOPKG_PKGVAR}/data"
SC_CFG_FILE="${SC_DATA_DIR}/config.ini"

GROUP="sc-download"

SERVICE_COMMAND="${SC_BINARY} --daemon --nolaunch --pidfile ${PID_FILE} --config ${SC_CFG_FILE} --datadir ${SC_DATA_DIR}"

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
    separator="===================================================="

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
      if [ "${SYNOPKG_PKG_STATUS}" != "INSTALL" ]; then
        mv ${TMP_DIR}/var ${SYNOPKG_PKGDEST}/
        rm -rf ${TMP_DIR}
      fi
      set_unix_permissions "${SYNOPKG_PKGDEST}"
    fi
}

service_preupgrade ()
{
    # We have to reset /env for Python and package changes, it gets rebuilt in postinst and this avoids any conflicts.
    # For cleaner update remove bin, env, share and lib folders for fresh install, leave user data /var & /@appdata

    if [ "${SYNOPKG_PKG_STATUS}" != "INSTALL" ] && [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        echo "Moving data ${SYNOPKG_PKGDEST}/var to ${TMP_DIR} whilst upgrading"
        rm -rf ${TMP_DIR}
        mkdir -p ${TMP_DIR}
        mv ${SYNOPKG_PKGDEST}/var ${TMP_DIR}/
    fi
}
