PYTHON_DIR="/usr/local/python"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${PATH}"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
GATEONE="${SYNOPKG_PKGDEST}/env/bin/gateone"
SETTINGS_DIR="${SYNOPKG_PKGDEST}/var/conf.d"
CONF_FILE="${SYNOPKG_PKGDEST}/var/conf.d/90custom.conf"
if [ $SYNOPKG_DSM_VERSION_MAJOR -ge 6 ]; then
    CERTPATH="/usr/syno/etc/certificate/system/default/"
    CERTIFICATE="cert.pem"
    KEYPATH="/usr/syno/etc/certificate/system/default/"
    KEYFILE="privkey.pem"
else
    CERTPATH="/usr/syno/etc/ssl/ssl.crt/"
    CERTIFICATE="server.crt"
    KEYPATH="/usr/syno/etc/ssl/ssl.key/"
    KEYFILE="server.key"
fi
SSL_DIR="${SYNOPKG_PKGDEST}/ssl/"

SERVICE_COMMAND="${PYTHON} ${GATEONE} --settings_dir=${SETTINGS_DIR}"
SVC_BACKGROUND=yes

service_postinst ()
{
    # Create a Python virtualenv
    echo "Creaing Python virtualenv..." >> ${INST_LOG}
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG} 2>&1

    # Install the wheels
    echo "Installing wheels..." >> ${INST_LOG}
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG} 2>&1

    # Install GateOne
    echo "Installing Gateone" >> ${INST_LOG}
    ${PYTHON} ${SYNOPKG_PKGDEST}/share/gateone/setup.py install --prefix=${SYNOPKG_PKGDEST}/env --skip_init_scripts >> ${INST_LOG}

    # Install initial certificates
    echo "Installing initial certificates..." >> ${INST_LOG}
    $CP "${CERTPATH}${CERTIFICATE}" "${KEYPATH}${KEYFILE}" ${SSL_DIR}
    sed -i -e "s,@certificate@,${SSL_DIR}${CERTIFICATE},g" ${CONF_FILE}
    sed -i -e "s,@keyfile@,${SSL_DIR}${KEYFILE},g" ${CONF_FILE}

    # Fix permissions
    set_unix_permissions "${SYNOPKG_PKGDEST}/ssl"
    set_unix_permissions "${SYNOPKG_PKGDEST}/env"

    # Discard legacy obsolete busybox user account
    BIN=${SYNOPKG_PKGDEST}/bin
    $BIN/busybox --install $BIN
    $BIN/delgroup "${USER}" "users" >> ${INST_LOG}
    $BIN/deluser "${USER}" >> ${INST_LOG}
}

service_preupgrade ()
{
    # Revision 5 introduces backward incompatible changes
    if [ `echo ${SYNOPKG_OLD_PKGVER} | sed -r "s/^.*-([0-9]+)$/\1/"` -le 4 ]; then
        echo "Please uninstall previous version, no update possible.<br>Remember to save your ${INSTALL_DIR}/var/server.conf file before uninstalling.<br>You will need to manually port old configuration settings to the new configuration files."
        exit 1
    fi
}
