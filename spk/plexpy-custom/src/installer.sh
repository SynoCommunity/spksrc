#!/bin/sh

# Package
PACKAGE="plexpy-custom"
DNAME="PlexPy Custom"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PYTHON_DIR="/usr/local/python"
GIT_DIR="/usr/local/git"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${GIT_DIR}/bin:${PATH}"
USER="plexpy-custom"
GROUP="nobody"
CFG_FILE="config.ini"
GIT="${GIT_DIR}/bin/git"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"

SERVICETOOL="/usr/syno/bin/servicetool"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

preinst ()
{
    # Check fork
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ] && ! ${GIT} ls-remote --heads --exit-code ${wizard_fork_url:=git://github.com/drzoidberg33/plexpy/plxpy.git} ${wizard_fork_branch:=master} > /dev/null 2>&1; then
        echo "Incorrect fork"
        exit 1
        # Create default config.ini
        echo "[General]" > ${INSTALL_DIR}/var/{CFG_FILE}
        echo "launch_browser = 0"
        echo "http_port = 8010" >> ${INSTALL_DIR}/var/{CFG_FILE}
    fi

    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env > /dev/null

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Clone the repository
        ${GIT} clone --depth 10 --recursive -q -b ${wizard_fork_branch:=master} ${wizard_fork_url:=git://github.com/drzoidberg33/plexpy.git} ${INSTALL_DIR}/var/plexpy > /dev/null 2>&1

        # get IP
        sIPNAS=`/usr/syno/sbin/synonet --show | grep -m 1 IP:  | awk -F: '{gsub(/[ \t]+/, "", $2); print $2}'`

        # Add Host IP to config.ini
        echo "http_host = ${sIPNAS}" >> ${INSTALL_DIR}/var/{CFG_FILE}
    fi

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}
    
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

    # Remove the user if uninstalling
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
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

    # Save config & database
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    cp ${INSTALL_DIR}/var/config.ini ${TMP_DIR}/${PACKAGE}/config.ini
    cp ${INSTALL_DIR}/var/plexpy.db ${TMP_DIR}/${PACKAGE}/plexpy.db

    exit 0
}

postupgrade ()
{
    # Restore config & database
    cp ${TMP_DIR}/${PACKAGE}/config.ini ${INSTALL_DIR}/var/config.ini
    cp ${TMP_DIR}/${PACKAGE}/plexpy.db ${INSTALL_DIR}/var/plexpy.db

    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
