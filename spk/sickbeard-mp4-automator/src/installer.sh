#!/bin/sh

# Package
PACKAGE="sickbeard-mp4-automator"
DNAME="SickBeard MP4 Automator"

# Others
SICKBEARD_INSTALL_DIR="/usr/local/sickbeard-custom/var"
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PYTHON_DIR="/usr/local/python"
GIT_DIR="/usr/local/git"
PATH="${SICKBEARD_INSTALL_DIR}/bin:${SICKBEARD_INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${GIT_DIR}/bin:${PATH}"
USER="sickbeard-custom"
GROUP="users"
GIT="${GIT_DIR}/bin/git"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
CONFIG_FILE_EDITOR="${SYNOPKG_PKGDEST}/../Config File Editor/CFE/configfiles.txt"

SERVICETOOL="/usr/syno/bin/servicetool"

SYNO_GROUP="sc-media"
SYNO_GROUP_DESC="SynoCommunity's media related group"

preinst ()
{
    # Check fork
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ] && ! ${GIT} ls-remote --heads --exit-code git://github.com/phtagn/sickbeard_mp4_automator.git upstream > /dev/null 2>&1; then
        echo "Incorrect fork"
        exit 1
    fi

    exit 0
}

postinst ()
{
    # Link to make it easier to access from sickbeard
    ln -s ${SYNOPKG_PKGDEST}/var ${SICKBEARD_INSTALL_DIR}/${PACKAGE}
	chown ${USER}:root ${SICKBEARD_INSTALL_DIR}/${PACKAGE}

	#ln -s ${SYNOPKG_PKGDEST}/var/postConversion.py ${SICKBEARD_INSTALL_DIR}/postConversion.py
	#chown ${USER}:root ${SICKBEARD_INSTALL_DIR}/postConversion.py
	
	# Link in /usr/local/
	ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}
    chown ${USER}:root ${INSTALL_DIR}
    
   
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Clone the repository
        ${GIT} clone --depth 10 --recursive -q -b phtagn-syno https://github.com/phtagn/sickbeard_mp4_automator.git ${INSTALL_DIR}/var/ > /dev/null 2>&1
        ${PYTHON_DIR}/bin/pip install -r ${INSTALL_DIR}/var/requirements.txt > ${INSTALL_DIR}/var/package_install.log 2>&1
        cp ${INSTALL_DIR}/var/autoProcess.ini.sample.syno ${INSTALL_DIR}/var/autoProcess.ini
        chown ${USER}:users ${INSTALL_DIR}/var/autoProcess.ini
    fi
      
    # Correct the files ownership. Package files will be owned by sickbeard-custom user
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

	

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}
    rm -f ${SICKBEARD_INSTALL_DIR}/${PACKAGE}
	#rm -f ${SICKBEARD_INSTALL_DIR}/postConversion.py
    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Save settings
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    cp ${INSTALL_DIR}/var/autoProcess.ini ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore settings
    cp ${TMP_DIR}/${PACKAGE}/var/autoProcess.ini ${INSTALL_DIR}/var/autoProcess.ini
    chmod ${USER}:root ${INSTALL_DIR}/var/autoProcess.ini
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
