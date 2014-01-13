#!/bin/sh

# Package
PACKAGE="zabbixproxy"
DNAME="Zabbix Proxy"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
USER="root"
CFG_FILE="${INSTALL_DIR}/etc/zabbix_proxy.conf"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}

    # Edit the configuration according to the wizard

    sed -i -e "s|@Server@|${zabbix_server_ip:=127.0.0.1}|g" ${CFG_FILE}

    sed -i -e "s|@sr_port@|${zabbix_server_port:=10051}|g" ${CFG_FILE}

    sed -i -e "s|@Zabbix_proxy@|${zabbix_proxy_hostname:=Zabbix proxy}|g" ${CFG_FILE}

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        delgroup ${USER} ${GROUP}
        deluser ${USER}
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

    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${INSTALL_DIR}/var ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/var
    mv ${TMP_DIR}/${PACKAGE}/var ${INSTALL_DIR}/
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
