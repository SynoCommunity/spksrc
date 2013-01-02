#!/bin/sh

# Package
PACKAGE="squidguard"
DNAME="SquidGuard"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
SQUID="${INSTALL_DIR}/sbin/squid"
RUNAS="squid"
CFG_FILE="${INSTALL_DIR}/etc/squid.conf"
ETC_DIR="${INSTALL_DIR}/etc/"
WWW_DIR="/var/packages/${PACKAGE}/target/share/www/squidguardmgr"
WEBMAN_DIR="/usr/syno/synoman/webman/3rdparty"

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

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G users -s /bin/sh -S -D ${RUNAS}

    # Patch template files
    hostname=`hostname`
    sed "s/==HOSTNAME==/$hostname/g" ${ETC_DIR}/squidguard.conf.tpl > ${ETC_DIR}/squidguard.conf
    
    # Correct the files ownership
    chown -R ${RUNAS}:users ${SYNOPKG_PKGDEST}

    # Init squid cache directory
    su - ${RUNAS} -c "${SQUID} -z -f ${CFG_FILE}"

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
    
    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}
    rm -Rf ${WEBMAN_DIR}/${PACKAGE}
    sed "/${PACKAGE}/d" /etc/crontab
    deluser ${RUNAS}
    
    exit 0
}

preupgrade ()
{
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

    exit 0
}

