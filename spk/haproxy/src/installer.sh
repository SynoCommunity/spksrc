#!/bin/sh

# Package
PACKAGE="haproxy"
DNAME="HAProxy"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
USER="haproxy"
GROUP="nobody"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
CFG_FILE="${INSTALL_DIR}/var/haproxy.cfg"
TPL_FILE="${CFG_FILE}.tpl"

SERVICETOOL="/usr/syno/bin/servicetool"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}

    # Edit the configuration according to the wizard
    sed -i -e "s/@user@/${wizard_user:=admin}/g" ${TPL_FILE}
    sed -i -e "s/@passwd@/${wizard_passwd:=admin}/g" ${TPL_FILE}

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env > /dev/null

    # Install the wheels/requirements
    ${INSTALL_DIR}/env/bin/pip install --use-wheel --no-deps --no-index -U --force-reinstall -f ${INSTALL_DIR}/share/wheelhouse -r ${INSTALL_DIR}/share/wheelhouse/requirements.txt > /dev/null 2>&1

    # Setup the database
    ${INSTALL_DIR}/env/bin/python ${INSTALL_DIR}/app/setup.py

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

    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        delgroup ${USER} ${GROUP}
        deluser ${USER}
    fi

    # Remove firewall config
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
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

    # Revision 12 introduces backward incompatible changes
    if [ `echo ${SYNOPKG_OLD_PKGVER} | sed -r "s/^.*-([0-9]+)$/\1/"` -le 12 ]; then
        ${INSTALL_DIR}/env/bin/python ${SYNOPKG_PKGINST_TEMP_DIR}/app/application/db_upgrade_12.py
    fi

    # Revision 16 adds security updates
    if [ `echo ${SYNOPKG_OLD_PKGVER} | sed -r "s/^.*-([0-9]+)$/\1/"` -le 16 ]; then
        ${INSTALL_DIR}/env/bin/python ${SYNOPKG_PKGINST_TEMP_DIR}/app/application/db_upgrade_16.py
    fi

    # Revision 18 runs as root, but requires 'haproxy' user entry in conf
    if [ `echo ${SYNOPKG_OLD_PKGVER} | sed -r "s/^.*-([0-9]+)$/\1/"` -le 18 ]; then
        sed -ie "/^global$/a\	user haproxy" ${CFG_FILE}
        sed -ie "/^global$/a\	user haproxy" ${TPL_FILE}
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
    chown -R ${USER}:root ${INSTALL_DIR}/var
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
