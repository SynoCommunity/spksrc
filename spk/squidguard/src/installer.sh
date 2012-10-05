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

    # Correct the files ownership
    chown -R ${RUNAS}:root ${SYNOPKG_PKGDEST}

    # Init squid cache directory
    su - ${RUNAS} -c "${SQUID} -z -f ${CFG_FILE}"

    # Init squidGuard DB
    su - ${RUNAS} -c "${INSTALL_DIR}/bin/update_db.sh > ${INSTALL_DIR}/var/logs/update_db.log"

    # Install webman
    su - ${RUNAS} -c "ln -s $WWW_DIR ${WEBMAN_DIR}/${PACKAGE}"
    su - ${RUNAS} -c "ln -s ${INSTALL_DIR}/etc/squiguardmgr.conf ${WEBMAN_DIR}/${PACKAGE}/"
      
    # Init crontab : update squidguard DB each day at 1 a.m
    nb=`grep ${PACKAGE} /etc/crontab`
    if [ "x$nb" eq "x" ]; then
        echo "0 1       *       *       *       root    su - ${RUNAS} -c \"${INSTALL_DIR}/bin/update_db.sh > ${INSTALL_DIR}/var/logs/update_db.log\"" >> /etc/crontab
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

