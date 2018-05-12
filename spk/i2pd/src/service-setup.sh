SVC_CWD="${SYNOPKG_PKGDEST}"
I2PD="${SYNOPKG_PKGDEST}/bin/i2pd"
CFG_FILE="${SYNOPKG_PKGDEST}/var/i2pd.conf"
SERVICE_COMMAND="${I2PD} --daemon --pidfile ${PID_FILE} --conf ${CFG_FILE} --log=file --logfile ${LOG_FILE} --datadir ${SYNOPKG_PKGDEST}/var"

service_postinst () {
    echo "Running post-install script" >> "${INST_LOG}"
    mkdir -p "${SYNOPKG_PKGDEST}"/var >> "${INST_LOG}" 2>&1

    if [ ! -e "${CFG_FILE}" ]; then

cat > "${CFG_FILE}" << EOF
[http]
address = 0.0.0.0
[httpproxy]
address = 0.0.0.0
[socksproxy]
address = 0.0.0.0
[sam]
address = 0.0.0.0
EOF

    fi
}
