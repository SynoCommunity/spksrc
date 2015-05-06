#!/bin/sh

# Package
PACKAGE="moviegrabber"
DNAME="MovieGrabber"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
PATH="${INSTALL_DIR}/sbin:${PYTHON_DIR}/bin:/bin:/usr/bin:/usr/syno/bin"
CFG_DIR="configs"

SERVICETOOL="/usr/syno/bin/servicetool"
FWPORTS="/var/packages/${DNAME}/scripts/${PACKAGE}.sc"

preinst ()
{
	exit 0
}

postinst ()
{
	# Link
	ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

	# Create user
	adduser -h ${INSTALL_DIR} -g "${DNAME} User" -G users -s /bin/sh -S -D ${PACKAGE}

	# Correct the files ownership
	chown -R ${PACKAGE}:root ${SYNOPKG_PKGDEST}

    # Add firewall config
    ${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null

	exit 0
}

preuninst ()
{
	# Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
		deluser ${PACKAGE}
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
	if [ -d ${INSTALL_DIR}/${CFG_DIR} ]
	then
		mv ${INSTALL_DIR}/${CFG_DIR}/config.ini ${INSTALL_DIR}/${CFG_DIR}/config.old
		mv ${INSTALL_DIR}/${CFG_DIR}/webconfig.ini ${INSTALL_DIR}/${CFG_DIR}/webconfig.old
		mv ${INSTALL_DIR}/${CFG_DIR} ${TMP_DIR}/${PACKAGE}/
	fi
	
    exit 0
	
}

postupgrade ()
{
    # Restore some stuff

	if [ -d ${TMP_DIR}/${PACKAGE}/${CFG_DIR} ]
	then
		rm -fr ${INSTALL_DIR}/${CFG_DIR}
		mv ${TMP_DIR}/${PACKAGE}/${CFG_DIR} ${INSTALL_DIR}/
	fi
    rm -fr ${TMP_DIR}/${PACKAGE}

	# Correct the files ownership
	chown -R ${PACKAGE}:root ${SYNOPKG_PKGDEST}

	exit 0
}
