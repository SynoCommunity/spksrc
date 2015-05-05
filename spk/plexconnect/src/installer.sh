#!/bin/sh

# Package
PACKAGE="plexconnect"
DNAME="PlexConnect"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
CFG_FILE="Settings.py"
PATH="${INSTALL_DIR}/sbin:${PYTHON_DIR}/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="${PACKAGE}"
PYTHON="${PYTHON_DIR}/bin/python"
PROG_PY="${INSTALL_DIR}/PlexConnect.py"

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

    # Edit the configuration according to the wizard
    sed -i -e "s|8.8.8.8|${wizard_dns_server}|g" ${INSTALL_DIR}/${CFG_FILE}
	
	# Correct the files ownership
	chown -R ${PACKAGE}:root ${SYNOPKG_PKGDEST}

	exit 0
}

preuninst ()
{
	# Remove the user (if not upgrading)
	if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
		deluser ${PACKAGE}
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
	if [ -f ${INSTALL_DIR}/${CFG_FILE} ]
	then
		mv ${INSTALL_DIR}/${CFG_FILE} ${TMP_DIR}/${PACKAGE}/
	fi
	
    exit 0
	
}
postupgrade ()
{
    # Restore some stuff

	if [ -f ${TMP_DIR}/${PACKAGE}/${CFG_FILE} ]
	then
		rm -fr ${INSTALL_DIR}/${CFG_FILE}
		mv ${TMP_DIR}/${PACKAGE}/${CFG_FILE} ${INSTALL_DIR}/
	fi
    rm -fr ${TMP_DIR}/${PACKAGE}

	# Correct the files ownership
	chown -R ${PACKAGE}:root ${SYNOPKG_PKGDEST}

	exit 0
}
