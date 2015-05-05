#!/bin/sh

# Package
PACKAGE="xdm"
DNAME="XDM"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
PATH="${INSTALL_DIR}/sbin:${PYTHON_DIR}/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="${PACKAGE}"
PYTHON="${PYTHON_DIR}/bin/python"
PROG_PY="${INSTALL_DIR}/XDM.py"
CFG_FILE="config.ini"
CONFIG_DB_FILE="config.db"
DATA_DB_FILE="data.db"
HISTORY_DB_FILE="history.db"

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
	adduser -h ${INSTALL_DIR} -g "${DNAME} User" -G users -s /bin/sh -S -D ${PACKAGE}

	# Correct the files ownership
	chown -R ${PACKAGE}:root ${SYNOPKG_PKGDEST}

    # Edit the configuration according to the wizard
    sed -i -e "s|@PORT@|${wizard_xdm_port}|g" ${INSTALL_DIR}/${CFG_FILE}
	sed -i -e "s|@PORT@|${wizard_xdm_port}|g" /var/packages/${PACKAGE}/INFO
	sed -i -e "s|@PORT@|${wizard_xdm_port}|g" /var/packages/${PACKAGE}/scripts/start-stop-status
	sed -i -e "s|@PORT@|${wizard_xdm_port}|g" ${FWPORTS}

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
	if [ -f ${INSTALL_DIR}/${CFG_FILE} ]
	then
		mv ${INSTALL_DIR}/${CFG_FILE} ${TMP_DIR}/${PACKAGE}/
	fi
	if [ -f ${INSTALL_DIR}/${CONFIG_DB_FILE} ]
	then
		mv ${INSTALL_DIR}/${CONFIG_DB_FILE} ${TMP_DIR}/${PACKAGE}/
	fi
	if [ -f ${INSTALL_DIR}/${DATA_DB_FILE} ]
	then
		mv ${INSTALL_DIR}/${DATA_DB_FILE} ${TMP_DIR}/${PACKAGE}/
	fi
	if [ -f ${INSTALL_DIR}/${HISTORY_DB_FILE} ]
	then
		mv ${INSTALL_DIR}/${HISTORY_DB_FILE} ${TMP_DIR}/${PACKAGE}/
	fi
	if [ -f ${FWPORTS} ]
	then
		mv ${FWPORTS} ${TMP_DIR}/${PACKAGE}/
	fi
	if [ -f /var/packages/${PACKAGE}/scripts/start-stop-status ]
	then
		mv /var/packages/${PACKAGE}/scripts/start-stop-status ${TMP_DIR}/${PACKAGE}/
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
	if [ -f ${TMP_DIR}/${PACKAGE}/${CONFIG_DB_FILE} ]
	then
		rm -fr ${INSTALL_DIR}/${CONFIG_DB_FILE}
		mv ${TMP_DIR}/${PACKAGE}/${CONFIG_DB_FILE} ${INSTALL_DIR}/
	fi
	if [ -f ${TMP_DIR}/${PACKAGE}/${DATA_DB_FILE} ]
	then
		rm -fr ${INSTALL_DIR}/${DATA_DB_FILE}
		mv ${TMP_DIR}/${PACKAGE}/${DATA_DB_FILE} ${INSTALL_DIR}/
	fi
	if [ -f ${TMP_DIR}/${PACKAGE}/${HISTORY_DB_FILE} ]
	then
		rm -fr ${INSTALL_DIR}/${HISTORY_DB_FILE}
		mv ${TMP_DIR}/${PACKAGE}/${HISTORY_DB_FILE} ${INSTALL_DIR}/
	fi
	if [ -f ${TMP_DIR}/${PACKAGE}/xdm.sc ]
	then
		rm -fr ${FWPORTS}
		mv ${TMP_DIR}/${PACKAGE}/xdm.sc ${FWPORTS}
	fi
	if [ -f ${TMP_DIR}/${PACKAGE}/start-stop-status ]
	then
		rm -fr /var/packages/${PACKAGE}/scripts/start-stop-status
		mv ${TMP_DIR}/${PACKAGE}/start-stop-status /var/packages/${PACKAGE}/scripts/start-stop-status
	fi
	rm -fr ${TMP_DIR}/${PACKAGE}

	# Correct the files ownership
	chown -R ${PACKAGE}:root ${SYNOPKG_PKGDEST}

	# Add firewall config
	${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null

	exit 0
}
