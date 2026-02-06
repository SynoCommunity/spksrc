# HAProxy service setup
PYTHON_DIR="/var/packages/python312/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"
export LD_LIBRARY_PATH="${SYNOPKG_PKGDEST}/lib"

HAPROXY="${SYNOPKG_PKGDEST}/sbin/haproxy"
CFG_FILE="${SYNOPKG_PKGVAR}/haproxy.cfg"
TPL_FILE="${SYNOPKG_PKGDEST}/share/haproxy.cfg.tpl"
CERT_DIR="${SYNOPKG_PKGVAR}/crt"
SERVICE_COMMAND="${HAPROXY} -f ${CFG_FILE} -p ${PID_FILE}"
SVC_CWD="${SYNOPKG_PKGVAR}"

# Dashboard configuration
DASHBOARD_DIR="${SYNOPKG_PKGDEST}/share/haproxy-dashboard"
DASHBOARD_PORT="${SERVICE_PORT}"
DASHBOARD_PID="${SYNOPKG_PKGVAR}/dashboard.pid"

service_postinst ()
{
    # Create a Python virtualenv
    install_python_virtualenv

    # Install the wheels
    install_python_wheels

    # Create certificate directory
    mkdir -p "${CERT_DIR}"

    # Create a self-signed certificate for HTTPS termination
    # Use python312's openssl since we depend on it at runtime
    OPENSSL="${PYTHON_DIR}/openssl"
    if [ -x "${OPENSSL}" ]; then
        LD_LIBRARY_PATH="/var/packages/python312/target/lib" ${OPENSSL} req -x509 -newkey rsa:4096 -nodes \
            -keyout "${CERT_DIR}/default.key" \
            -out "${CERT_DIR}/default.crt" \
            -days 7320 -subj "/CN=haproxy-default" 2>/dev/null
        cat "${CERT_DIR}/default.key" "${CERT_DIR}/default.crt" > "${CERT_DIR}/default.pem"
        rm -f "${CERT_DIR}/default.key" "${CERT_DIR}/default.crt"
    fi

    # Copy template to config location if not upgrading
    if [ ! -f "${CFG_FILE}" ]; then
        cp "${TPL_FILE}" "${CFG_FILE}"
        # Edit the configuration according to the wizard
        sed -e "s/@user@/${wizard_user:=admin}/g" \
            -e "s/@passwd@/${wizard_passwd:=admin}/g" \
            -i "${CFG_FILE}"
    fi
}

service_prestart ()
{
    # Start the dashboard web UI
    if [ -f "${DASHBOARD_DIR}/app.py" ]; then
        # Export environment variables for dashboard
        export HAPROXY_DASHBOARD_DIR="${SYNOPKG_PKGVAR}"
        export HAPROXY_CFG="${CFG_FILE}"
        export HAPROXY_LOG="${SYNOPKG_PKGVAR}/http-access.log"
        export HAPROXY_CERT="${CERT_DIR}/default.pem"
        export DASHBOARD_PORT="${DASHBOARD_PORT}"
        export HAPROXY_STATS_PORT="8280"
        export HAPROXY_BIN="${HAPROXY}"
        export SYNOPKG_PKGNAME="${SYNOPKG_PKGNAME}"
        export HAPROXY_PID="${PID_FILE}"

        cd "${DASHBOARD_DIR}"
        "${SYNOPKG_PKGDEST}/env/bin/python3" app.py >> "${LOG_FILE}" 2>&1 &
        echo $! > "${DASHBOARD_PID}"
    fi
}

service_poststop ()
{
    # Stop the dashboard web UI
    if [ -f "${DASHBOARD_PID}" ]; then
        kill "$(cat ${DASHBOARD_PID})" 2>/dev/null
        rm -f "${DASHBOARD_PID}"
    fi
}
