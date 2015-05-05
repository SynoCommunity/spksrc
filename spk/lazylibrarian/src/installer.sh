#!/bin/sh

# Package
PACKAGE="lazylibrarian"
DNAME="LazyLibrarian"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
PATH="${INSTALL_DIR}/sbin:${PYTHON_DIR}/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="lazylibrarian"

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
	adduser -h ${INSTALL_DIR} -g "${DNAME} User" -G users -s /bin/sh -S -D ${RUNAS}

	# Correct the files ownership
	chown -R ${PACKAGE}:root ${SYNOPKG_PKGDEST}

    # Correct the files ownership
    chown -R ${RUNAS}:root ${SYNOPKG_PKGDEST}

	# Add firewall config
	${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null

	exit 0
}

preuninst ()
{
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
    mv ${INSTALL_DIR}/config.ini ${TMP_DIR}/${PACKAGE}
    mv ${INSTALL_DIR}/lazylibrarian.db ${TMP_DIR}/${PACKAGE}

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    mv ${TMP_DIR}/${PACKAGE}/config.ini ${INSTALL_DIR}
    mv ${TMP_DIR}/${PACKAGE}/lazylibrarian.db ${INSTALL_DIR}
    rm -fr ${TMP_DIR}/${PACKAGE}

	exit 0
}
