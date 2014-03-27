#!/bin/sh

#Package
PACKAGE="zabbixagent"
DNAME="Zabbix Agent"

#Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:${PATH}"

#Zabbix Others
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
USER="${PACKAGE}agent"
GROUP="nobody"


preinst ()
{
    exit 0
}

postinst ()
{
    #Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    #Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    #Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}

    #Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}
    
    #Correct /var write
    chmod -R 757 ${INSTALL_DIR}/var

    exit 0
}

preuninst ()
{
    #Stop the package
    ${SSS} stop > /dev/null

    #Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        delgroup ${USER} ${GROUP}
        deluser ${USER}
    fi

    exit 0
}

postuninst ()
{
    #Remove link
    rm -f ${INSTALL_DIR}

    exit 0
}

preupgrade ()
{
    #Stop the package
    ${SSS} stop > /dev/null

    #Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${INSTALL_DIR}/etc ${TMP_DIR}/${PACKAGE}/
    mv ${INSTALL_DIR}/var ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    #Restore some stuff
    rm -fr ${INSTALL_DIR}/etc
    rm -fr ${WEB_DIR}/zabbix/conf
    mv ${TMP_DIR}/${PACKAGE}/etc ${INSTALL_DIR}/
    mv ${TMP_DIR}/${PACKAGE}/var ${INSTALL_DIR}/
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
