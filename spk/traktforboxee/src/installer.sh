#!/bin/sh

# Package
PACKAGE="traktforboxee"
DNAME="TraktForBoxee"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
CFG_FILE="config.ini"
PATH="${INSTALL_DIR}/sbin:${PYTHON_DIR}/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="${PACKAGE}"
PYTHON="${PYTHON_DIR}/bin/python"
PROG_PY="${INSTALL_DIR}/TraktForBoxee.py"

preinst ()
{
	# Installation wizard requirements
#   if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ] && [ ! -d "${wizard_boxee_ip}" ]; then
#       exit 1
#   fi

    exit 0
}

postinst ()
{
	# Link
	ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

	# Create user
	adduser -h ${INSTALL_DIR} -g "${DNAME} User" -G users -s /bin/sh -S -D ${PACKAGE}

    # Edit the configuration according to the wizard
    sed -i -e "s|@IP@|${wizard_boxee_ip}|g" ${INSTALL_DIR}/${CFG_FILE}
    sed -i -e "s|@Port@|${wizard_boxee_port}|g" ${INSTALL_DIR}/${CFG_FILE}
    sed -i -e "s|@Username@|${wizard_trakt_username}|g" ${INSTALL_DIR}/${CFG_FILE}
    sed -i -e "s|@Password@|${wizard_trakt_password}|g" ${INSTALL_DIR}/${CFG_FILE}
    if [ "${wizard_traktforboxee_scrobblemovieyes}" ] ; then
        sed -i -e "s|@ScrobbleMovie@|Yes|g" ${INSTALL_DIR}/${CFG_FILE}
	else
		sed -i -e "s|@ScrobbleMovie@|No|g" ${INSTALL_DIR}/${CFG_FILE}
	fi
    if [ "${wizard_traktforboxee_scrobbletvyes}" ] ; then
        sed -i -e "s|@ScrobbleTV@|Yes|g" ${INSTALL_DIR}/${CFG_FILE}
	else
		sed -i -e "s|@ScrobbleTV@|No|g" ${INSTALL_DIR}/${CFG_FILE}
	fi
    if [ "${wizard_traktforboxee_notifyboxeeyes}" ] ; then
        sed -i -e "s|@NotifyBoxee@|Yes|g" ${INSTALL_DIR}/${CFG_FILE}
	else
        sed -i -e "s|@NotifyBoxee@|No|g" ${INSTALL_DIR}/${CFG_FILE}
	fi
    if [ -d "${wizard_data_dir}" ] ; then
        sed -i -e "s|@DataDir@|${wizard_data_dir}|g" /var/packages/${PACKAGE}/scripts/start-stop-status
		cp ${INSTALL_DIR}/${CFG_FILE} ${wizard_data_dir}/${CFG_FILE}
	else
        sed -i -e "s|@DataDir@|\${INSTALL_DIR}|g" /var/packages/${PACKAGE}/scripts/start-stop-status
	fi
	
	# Correct the files ownership
	chown -R ${PACKAGE}:root ${SYNOPKG_PKGDEST}

    # Pairing with Boxee Box
    su - ${RUNAS} -c "PATH=${PATH} ${PYTHON} ${PROG_PY} --pair"
	
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
