PYTHON_DIR="/usr/local/python3"
PIP=${SYNOPKG_PKGDEST}/env/bin/pip3
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${PATH}"
HOME="${SYNOPKG_PKGDEST}/var"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python3"
SC_INSTALL_DIR="${SYNOPKG_PKGDEST}/share/SickChill"
SC_BINARY="${SC_INSTALL_DIR}/SickChill.py"
SC_DATA_DIR="${SYNOPKG_PKGDEST}/var/data"
SC_CFG_FILE="${SC_DATA_DIR}/config.ini"


GROUP="sc-download"

SERVICE_COMMAND="${PYTHON} ${SC_BINARY} --daemon --nolaunch --pidfile ${PID_FILE} --config ${SC_CFG_FILE} --datadir ${SC_DATA_DIR}"

set_config() {
    . ${SYNOPKG_PKGDEST}/share/git_data

    if [ -f "${SC_CFG_FILE}" ]; then
        if [ -n "${wizard_username}" ] && [ -n "${wizard_password}" ]; then
            sed -i "/^\s*web_username\s*=/s/\s*=\s*.*/ = ${wizard_username}/" ${SC_CFG_FILE}
            sed -i "/^\s*web_password\s*=/s/\s*=\s*.*/ = ${wizard_password}/" ${SC_CFG_FILE}
        fi
        sed -i "/^\s*branch\s*=/s/\s*=\s*.*/ = ${SC_CONFIG_GIT_BRANCH}/" ${SC_CFG_FILE}
        sed -i "/^\s*cur_commit_hash\s*=/s/\s*=\s*.*/ = ${SC_CONFIG_GIT_COMMIT_HASH}/" ${SC_CFG_FILE}
        sed -i "/^\s*cur_commit_branch\s*=/s/\s*=\s*.*/ = ${SC_CONFIG_GIT_COMMIT_BRANCH}/" ${SC_CFG_FILE}
    else
        mkdir -p ${SC_DATA_DIR}
        cat << EOF > ${SC_CFG_FILE}
[General]
web_username = ${wizard_username}
web_password = ${wizard_password}
branch = ${SC_GIT_BRANCH}
cur_commit_hash = ${SC_GIT_COMMIT_HASH}
cur_commit_branch = ${SC_GIT_COMMIT_BRANCH}
EOF
    fi
}

service_postinst() {
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >>${INST_LOG}

    # Install the wheels
    ${PIP} install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG} 2>&1

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        set_config
    fi
}

service_postupgrade() {
    set_config
}
