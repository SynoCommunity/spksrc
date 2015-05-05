#!/bin/sh

# Package
PACKAGE="gamez"
DNAME="Gamez"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="gamez"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
CFG_FILE="${INSTALL_DIR}/var/Gamez.ini"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"

SERVICETOOL="/usr/syno/bin/servicetool"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

preinst ()
{
	# Install the request module for python
	${PYTHON_DIR}/bin/pip install requests >> /dev/null

    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env > /dev/null

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G users -s /bin/sh -S -D ${RUNAS}

    # Correct the files ownership
    chown -R ${RUNAS}:root ${SYNOPKG_PKGDEST}
	
	# Add firewall config
	${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null

    exit 0
}

preuninst ()
{
	# Uninstall the request module for python
	${PYTHON_DIR}/bin/pip uninstall -y requests >> /dev/null

    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        deluser ${RUNAS}
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
    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${CFG_FILE} ${TMP_DIR}/${PACKAGE}/
    mv ${AUTOPROCESSTV_CFG_FILE} ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/var
    mv ${TMP_DIR}/${PACKAGE}/Gamez.ini ${CFG_FILE}
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
