#!/bin/sh

# Package
PACKAGE="autosub-bootstrapbill"
DNAME="AutoSub-BootstrapBill"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
TEMP="/tmp"
PATH="${INSTALL_DIR}/sbin:${PYTHON_DIR}/bin:/bin:/usr/bin:/usr/syno/bin"
CFG_FILE="${INSTALL_DIR}/config.properties"
CFG_FILES="/var/packages/${DNAME}/target"

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

    # Edit the configuration according to the wizard
    sed -i -e "s|@PORT@|${wizard_autosub_port}|g" ${CFG_FILE}
	sed -i -e "s|@PORT@|${wizard_autosub_port}|g" /var/packages/${PACKAGE}/INFO
	sed -i -e "s|@PORT@|${wizard_autosub_port}|g" /var/packages/${PACKAGE}/scripts/start-stop-status
	sed -i -e "s|@PORT@|${wizard_autosub_port}|g" ${FWPORTS}
	sed -i -e "s|@PORT@|${wizard_autosub_port}|g" ${INSTALL_DIR}/app/${PACKAGE}.cgi
	
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
	# Backup the config file to a save location
	if [ -f ${CFG_FILES}/config.properties ]
	then
		mv ${CFG_FILES}/config.properties ${TEMP}
	fi

	# Backup the database to a save location
	if [ -f ${CFG_FILES}/database.db ]
	then
		mv ${CFG_FILES}/database.db ${TEMP}
	fi

	# Backup the firewall file to a save location
	if [ -f ${FWPORTS} ]
	then
		mv ${FWPORTS} ${TEMP}
	fi
	
	# Backup the ExamplePostProcess file to a save location
	if [ -f ${CFG_FILES}/ExamplePostProcess.py ]
	then
		mv ${CFG_FILES}/ExamplePostProcess.py ${TEMP}
	fi
	
	exit $?
}

postupgrade ()
{
	# Restore the config file
	if [ -f ${TEMP}/config.properties ]
	then
		mv ${TEMP}/config.properties ${INSTALL_DIR}/config.properties
	fi

	# Restore the database
	if [ -f ${TEMP}/database.db ]
	then
		mv ${TEMP}/database.db ${INSTALL_DIR}/database.db
	fi

	# Restore the firewall file
	if [ -f ${TEMP}/autosub-bootstrapbill.sc ]
	then
		mv ${TEMP}/autosub-bootstrapbill.sc ${FWPORTS}
	fi
	
	# Restore the ExamplePostProcess file
	if [ -f ${TEMP}/ExamplePostProcess.py ]
	then
		mv ${TEMP}/ExamplePostProcess.py ${INSTALL_DIR}/ExamplePostProcess.py
	fi

	# Correct the files ownership
	chown -R ${PACKAGE}:root ${SYNOPKG_PKGDEST}

	# Add firewall config
	${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null

	exit 0
}
