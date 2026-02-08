#!/bin/sh

# Package
PACKAGE="squidguard"
DNAME="SquidGuard"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
SQUID="${INSTALL_DIR}/sbin/squid"
CFG_FILE="${INSTALL_DIR}/etc/squid.conf"
ETC_DIR="${INSTALL_DIR}/etc/"
WWW_DIR="/var/packages/${PACKAGE}/target/share/www/squidguardmgr"
WEBMAN_DIR="/usr/syno/synoman/webman/3rdparty"
SQUID_WRAPPER="${WWW_DIR}/squid_wrapper"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
SERVICETOOL="/usr/syno/bin/servicetool"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

DSM6_UPGRADE="${INSTALL_DIR}/var/.dsm6_upgrade"
SC_USER="sc-squid"
LEGACY_USER="squid"
LEGACY_GROUP="users"
USER="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n ${SC_USER} || echo -n ${LEGACY_USER})"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Create legacy user
    if [ "${BUILDNUMBER}" -lt "7321" ]; then
        adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${LEGACY_GROUP} -s /bin/sh -S -D ${LEGACY_USER}
    fi

    # Patch template files
    hostname=`hostname`
    sed "s/==HOSTNAME==/$hostname/g" ${ETC_DIR}/squidguard.conf.tpl > ${ETC_DIR}/squidguard.conf
    
    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}
    chown 0:0 ${SQUID_WRAPPER}
	chmod +s ${SQUID_WRAPPER}
	
    # Init squid cache directory
    su ${USER} -s /bin/sh -c "${SQUID} -z -f ${CFG_FILE}"

    # Install webman
    ln -s ${WWW_DIR} ${WEBMAN_DIR}/${PACKAGE}
    ln -sf ${INSTALL_DIR}/etc/squidguardmgr.conf ${WEBMAN_DIR}/${PACKAGE}/
      
    # Init crontab : update squidguard DB each day at 1 a.m
    grep ${PACKAGE} /etc/crontab
    if [ $? -eq 1 ]; then
        echo "0 1       *       *       *       root    ${INSTALL_DIR}/bin/update_db.sh > ${INSTALL_DIR}/var/logs/update_db.log" >> /etc/crontab
        /usr/syno/etc/rc.d/S04crond.sh stop
        sleep 1
        /usr/syno/etc/rc.d/S04crond.sh start
    fi

    # Add firewall config
    ${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        # Remove the user (if not upgrading)
        delgroup ${LEGACY_USER} ${LEGACY_GROUP}
        deluser ${USER}

        # Remove firewall configuration
        ${SERVICETOOL} --remove-configure-file --package ${PACKAGE}.sc >> /dev/null
    fi

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}
    rm -Rf ${WEBMAN_DIR}/${PACKAGE}
    sed "/${PACKAGE}/d" /etc/crontab
    
    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # DSM6 Upgrade handling
    if [ "${BUILDNUMBER}" -ge "7321" ] && [ ! -f ${DSM6_UPGRADE} ]; then
        echo "Deleting legacy user" > ${DSM6_UPGRADE}
        delgroup ${LEGACY_USER} ${LEGACY_GROUP}
        deluser ${LEGACY_USER}
    fi

    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${INSTALL_DIR}/etc ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/etc
    mv ${TMP_DIR}/${PACKAGE}/etc ${INSTALL_DIR}/
    rm -fr ${TMP_DIR}/${PACKAGE}

    # Ensure file ownership is correct after upgrade
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    exit 0
}

