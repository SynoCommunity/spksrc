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
SQUID_WRAPPER="${WWW_DIR}/squid_wrapper"

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

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G users -s /bin/sh -S -D ${RUNAS}

    # Patch template files
    hostname=`hostname`
    sed "s/==HOSTNAME==/$hostname/g" ${ETC_DIR}/squidguard.conf.tpl > ${ETC_DIR}/squidguard.conf
    sed "s/==HOSTNAME==/$hostname/g" ${ETC_DIR}/squidclamav.conf.tpl > ${ETC_DIR}/squidclamav.conf
    
    # Correct the files ownership
    chown -R ${RUNAS}:users ${SYNOPKG_PKGDEST}
    # use "su - squid -c $SQUID_WRAPPER" in cgi file squidguardmgr.cgi instead
    ##chown 0:0 ${SQUID_WRAPPER}
    ##chmod +s ${SQUID_WRAPPER}
    # need when new DB files are created via web interface (avoid permission error because squidGuard is launch with squid user)
    chmod u+s ${INSTALL_DIR}/bin/squidGuard
    
    # Init squid cache directory
    su - ${RUNAS} -c "${SQUID} -z -f ${CFG_FILE}"

    # Install webman
    ln -s ${WWW_DIR} ${WEBMAN_DIR}/${PACKAGE}
    ln -sf ${INSTALL_DIR}/etc/squidguardmgr.conf ${WEBMAN_DIR}/${PACKAGE}/
    # For squidclamav redirect
    ln -sf ${INSTALL_DIR}/libexec/squidclamav/clwarn.cgi ${WEBMAN_DIR}/${PACKAGE}/clwarn.cgi
      
    # Init crontab : 
    #    update squidguard DB each day at 1 a.m
    #    logs rotate every sunday at 0:15 a.a
    grep ${PACKAGE} /etc/crontab
    if [ $? -eq 1 ]; then
        echo "0	1	*	*	*	root	${INSTALL_DIR}/bin/update_db.sh > ${INSTALL_DIR}/var/logs/update_db.log 2>&1" >> /etc/crontab
        echo "15	0	*	*	0	root	${INSTALL_DIR}/bin/logrotate.sh > ${INSTALL_DIR}/bin/logrotate.log 2>&1" >> /etc/crontab
        /usr/syno/etc/rc.d/S04crond.sh stop >> /dev/null
        sleep 1
        /usr/syno/etc/rc.d/S04crond.sh start >> /dev/null
    fi

    # launch first the update
    ${INSTALL_DIR}/bin/update_db.sh > ${INSTALL_DIR}/var/logs/update_db.log 2>&1

    # Add firewall config
    ${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null
    exit 0
}

preuninst ()
{

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
    rm -Rf ${WEBMAN_DIR}/${PACKAGE}
    cp /etc/crontab /etc/crontab.old
    cat /etc/crontab | sed "/${PACKAGE}/d" >/etc/crontab.new
    cat /etc/crontab.new >/etc/crontab
    rm /etc/crontab.new
    /usr/syno/etc/rc.d/S04crond.sh stop >> /dev/null
    sleep 1
    /usr/syno/etc/rc.d/S04crond.sh start >> /dev/null
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

