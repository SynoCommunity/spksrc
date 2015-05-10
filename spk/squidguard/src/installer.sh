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
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"

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

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Init squid cache directory
        su ${RUNAS} -c "${SQUID} -z -f ${CFG_FILE}"
    fi

    # Init SSLBump cache directory
    su ${RUNAS} -c "${INSTALL_DIR}/libexec/ssl_crtd -c -s ${INSTALL_DIR}/var/ssl_db" >> /dev/null

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
        echo "0	1	*	*	*	root	${INSTALL_DIR}/bin/update_db.sh > ${INSTALL_DIR}/var/logs/update_db.log" >> /etc/crontab
        echo "15	0	*	*	0	root	${INSTALL_DIR}/bin/logrotate.sh > ${INSTALL_DIR}/bin/logrotate.log" >> /etc/crontab
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
    sed "/${PACKAGE}/d" /etc/crontab >> /dev/null
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
    mv ${INSTALL_DIR}/var ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    mv ${INSTALL_DIR}/etc/c-icap.conf ${TMP_DIR}/${PACKAGE}/etc/c-icap.conf.default
    mv ${INSTALL_DIR}/etc/c-icap.magic ${TMP_DIR}/${PACKAGE}/etc/c-icap.magic.default
    mv ${INSTALL_DIR}/etc/cachemgr.conf ${TMP_DIR}/${PACKAGE}/etc/cachemgr.conf.default
    mv ${INSTALL_DIR}/etc/clamd.conf ${TMP_DIR}/${PACKAGE}/etc/clamd.conf.default
    mv ${INSTALL_DIR}/etc/errorpage.css ${TMP_DIR}/${PACKAGE}/etc/errorpage.css.default
    mv ${INSTALL_DIR}/etc/mime.conf ${TMP_DIR}/${PACKAGE}/etc/mime.conf.default
    mv ${INSTALL_DIR}/etc/msnauth.conf ${TMP_DIR}/${PACKAGE}/etc/msnauth.conf.default
    mv ${INSTALL_DIR}/etc/squid.conf ${TMP_DIR}/${PACKAGE}/etc/squid.conf.default
    mv ${INSTALL_DIR}/etc/squid.conf.documented ${TMP_DIR}/${PACKAGE}/etc/
    mv ${INSTALL_DIR}/etc/squidclamav.conf ${TMP_DIR}/${PACKAGE}/etc/squidclamav.conf.default
    mv ${INSTALL_DIR}/etc/squidguard.conf ${TMP_DIR}/${PACKAGE}/etc/squidguard.conf.default
    mv ${INSTALL_DIR}/etc/squidguard.conf.tpl ${TMP_DIR}/${PACKAGE}/etc/squidguard.conf.tpl.default
    mv ${INSTALL_DIR}/etc/squidguardmgr.conf ${TMP_DIR}/${PACKAGE}/etc/squidguardmgr.conf.default

    rm -fr ${INSTALL_DIR}/etc
    mv ${TMP_DIR}/${PACKAGE}/etc ${INSTALL_DIR}/
    rm -fr ${INSTALL_DIR}/var
    mv ${TMP_DIR}/${PACKAGE}/var ${INSTALL_DIR}/
    rm -fr ${TMP_DIR}/${PACKAGE}

    # check squid.conf and restore default file if parse error
    su ${RUNAS} -c "${SQUID} -f ${CFG_FILE} -k parse &> /dev/null"
    if [ $? -ne 0 ]; then
        mv ${CFG_FILE} ${CFG_FILE}.bad
        cp ${CFG_FILE}.default ${CFG_FILE}
    fi

    exit 0
}

