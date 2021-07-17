PYTHON_BIN="/var/packages/python38/target/bin"
VIRTUALENV="${PYTHON_BIN}/virtualenv"

VENV="${SYNOPKG_PKGHOME}/.venv"
PIP="${VENV}/bin/pip3"
PYTHON="${VENV}/bin/python3"

PATH="${VENV}/bin:${PATH}:${SYNOPKG_PKGDEST}/bin:${PYTHON_BIN}:${PATH}"

SICKCHILL="${VENV}/bin/SickChill.py"

GROUP="sc-download"

PIDFILE="${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}.pid"

SERVICE_COMMAND="LANG=en_US.UTF-8 ${PYTHON} ${SICKCHILL} --daemon --nolaunch --pidfile=${PIDFILE} --datadir=${SYNOPKG_PKGVAR} --port=${SYNOPKG_PKGPORT}"

SVC_CWD="${SYNOPKG_PKGDEST}/"
HOME="${SYNOPKG_PKGDEST}/"


set_config() {
    CFG_FILE="${SYNOPKG_PKGVAR}/config.ini"

    if [ -f "${CFG_FILE}" ]; then
        if [ -n "${wizard_username}" ] && [ -n "${wizard_password}" ]; then
            sed -i "/^\s*web_username\s*=/s/\s*=\s*.*/ = ${wizard_username}/" ${CFG_FILE}
            sed -i "/^\s*web_password\s*=/s/\s*=\s*.*/ = ${wizard_password}/" ${CFG_FILE}
        fi
    else
        mkdir -p ${SYNOPKG_PKGVAR}
        cat << EOF > ${CFG_FILE}
[General]
web_username = ${wizard_username}
web_password = ${wizard_password}
EOF
    fi
}

service_postinst() {
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${VENV}

    # If sickchill is not installed via a wheel, site-packages cannot be included due to shadowing.
    # ${VIRTUALENV}  ${VENV}

    # Install the wheels
    ${PIP} install --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl

    # If package inscludes all deps, need --no-deps here
     ${PIP} install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        set_config
    fi

    set_unix_permissions "${SYNOPKG_PKGHOME}"
    set_unix_permissions "${SYNOPKG_PKGVAR}"
}

service_postupgrade() {
    set_config
}
