#!/bin/sh

# Package
PACKAGE="gateone"
DNAME="GateOne"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
PYTHON="${INSTALL_DIR}/env/bin/python"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
SERVICETOOL="/usr/syno/bin/servicetool"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

CONF_FILE="${INSTALL_DIR}/var/conf.d/90custom.conf"
LEGACY_CERTPATH="/usr/syno/etc/ssl/ssl.key"
LEGACY_CERTIFICATE="server.crt"
LEGACY_KEYFILE="server.key"
CERTPATH="/usr/syno/etc/certificate/system/default"
CERTIFICATE="cert.pem"
KEYFILE="privkey.pem"

DSM6_UPGRADE="${INSTALL_DIR}/var/.dsm6_upgrade"
SC_USER="sc-gateone"
LEGACY_USER="gateone"
LEGACY_GROUP="nobody"
USER="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n ${SC_USER} || echo -n ${LEGACY_USER})"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Create legacy user
    if [ "${BUILDNUMBER}" -lt "7321" ]; then
        adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${LEGACY_GROUP} -s /bin/sh -S -D ${LEGACY_USER}
    fi

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env > /dev/null

    # Install the wheels
    ${INSTALL_DIR}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${INSTALL_DIR}/share/wheelhouse ${INSTALL_DIR}/share/wheelhouse/*.whl > /dev/null 2>&1

    # Install GateOne
    ${PYTHON} ${INSTALL_DIR}/share/${PACKAGE}/setup.py install --prefix=${INSTALL_DIR}/env --skip_init_scripts > /dev/null

    # install initial certificates
    if [ "${BUILDNUMBER}" -ge "7321" ]; then
        cp ${CERTIFICATE} ${KEYFILE} ${INSTALL_DIR}/ssl/
        sed -i -e "s|\"certificate\":.*|\"certificate\": \"${INSTALL_DIR}/ssl/${CERTIFICATE}\"|g" \
               -e "s|\"keyfile\":.*|\"keyfile\": \"${INSTALL_DIR}/ssl/${KEYFILE}\"|g" \
               ${CONF_FILE}
    else
        cp ${LEGACY_CERTIFICATE} ${LEGACY_KEYFILE} ${INSTALL_DIR}/ssl/
        sed -i -e "s|\"certificate\":.*|\"certificate\": \"${INSTALL_DIR}/ssl/${LEGACY_CERTIFICATE}\"|g" \
               -e "s|\"keyfile\":.*|\"keyfile\": \"${INSTALL_DIR}/ssl/${LEGACY_KEYFILE}\"|g" \
               ${CONF_FILE}
    fi

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    # Add firewall config
    ${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        # Remove the user (if not upgrading)
        delgroup ${LEGACY_USER} ${LEGACY_GROUP}
        deluser ${USER}

        # Remove firewall configuration
        ${SERVICETOOL} --remove-configure-file --package ${PACKAGE}.sc >> /dev/null
    fi

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # DSM6 Upgrade handling
    if [ "${BUILDNUMBER}" -ge "7321" ] && [ ! -f ${DSM6_UPGRADE} ]; then
        echo "Deleting legacy user" > ${DSM6_UPGRADE}
        delgroup ${LEGACY_USER} ${LEGACY_GROUP}
        deluser ${LEGACY_USER}
    fi

    # Revision 5 introduces backward incompatible changes
    if [ `echo ${SYNOPKG_OLD_PKGVER} | sed -r "s/^.*-([0-9]+)$/\1/"` -le 4 ]; then
        echo "Please uninstall previous version, no update possible.<br>Remember to save your ${INSTALL_DIR}/var/server.conf file before uninstalling.<br>You will need to manually port old configuration settings to the new configuration files."
        exit 1
    fi

    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${INSTALL_DIR}/var ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/var
    mv ${TMP_DIR}/${PACKAGE}/var ${INSTALL_DIR}/
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
