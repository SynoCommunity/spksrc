PYTHON_DIR="/var/packages/python310/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"
HOME="${SYNOPKG_PKGVAR}"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python3"
SC_INSTALL_DIR="${SYNOPKG_PKGDEST}/share/SickChill"
SC_BINARY="${SC_INSTALL_DIR}/SickChill.py"
SC_DATA_DIR="${SYNOPKG_PKGVAR}/data"
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
        # update git commit to sickchill updater
        sed -i "/^\s*branch\s*=/s/\s*=\s*.*/ = ${SC_GIT_BRANCH}/" ${SC_CFG_FILE}
        sed -i "/^\s*cur_commit_hash\s*=/s/\s*=\s*.*/ = ${SC_GIT_COMMIT_HASH}/" ${SC_CFG_FILE}
        sed -i "/^\s*cur_commit_branch\s*=/s/\s*=\s*.*/ = ${SC_GIT_COMMIT_BRANCH}/" ${SC_CFG_FILE}
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
    install_python_virtualenv
    
    # Install the wheels
    install_python_wheels --extra-index-url https://wheel-index.linuxserver.io/ubuntu/
    
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        set_config
    fi

    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
        set_unix_permissions "${SYNOPKG_PKGDEST}"
    fi
}

service_postupgrade() {
    set_config
    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
        set_unix_permissions "${SYNOPKG_PKGDEST}"
    fi
}

service_preupgrade ()
{
    # We have to reset /env folder to 3.8 so remove entire folder as it gets rebuilt in postinst and this avoids any conflicts.
    # Revision 1 was python 3.7. For cleaner update remove share and lib folders for clean install, leave user data /var.
    if [ "${SYNOPKG_PKG_STATUS}" != "INSTALL" ] && [ "$(echo ${SYNOPKG_OLD_PKGVER} | sed -r 's/^.*-([0-9]+)$/\1/')" -le 1 ]; then
        echo "Removing old ${SYNOPKG_PKGDEST}/env and /share for new Python 3.8 and old install"
        rm -rf ${SYNOPKG_PKGDEST}/env
        rm -rf ${SYNOPKG_PKGDEST}/share
        rm -rf ${SYNOPKG_PKGDEST}/lib
    fi
}
