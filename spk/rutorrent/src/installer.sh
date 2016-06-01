#!/bin/sh

# Package
PACKAGE="rutorrent"
DNAME="ruTorrent"
PACKAGE_NAME="com.synocommunity.packages.${PACKAGE}"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/usr/bin:${PATH}"
USER="rutorrent"
GROUP="users"
APACHE_USER="$([ $(grep buildnumber /etc.defaults/VERSION | cut -d"\"" -f2) -ge 4418 ] && echo -n http || echo -n nobody)"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"

SERVICETOOL="/usr/syno/bin/servicetool"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

SYNO_GROUP="sc-download"
SYNO_GROUP_DESC="SynoCommunity's download related group"

syno_group_create ()
{
    # Create syno group (Does nothing when group already exists)
    synogroup --add ${SYNO_GROUP} ${USER} > /dev/null
    # Set description of the syno group
    synogroup --descset ${SYNO_GROUP} "${SYNO_GROUP_DESC}"

    # Add user to syno group (Does nothing when user already in the group)
    addgroup ${USER} ${SYNO_GROUP}
}

syno_group_remove ()
{
    # Remove user from syno group
    delgroup ${USER} ${SYNO_GROUP}

    # Check if syno group is empty
    if ! synogroup --get ${SYNO_GROUP} | grep -q "0:"; then
        # Remove syno group
        synogroup --del ${SYNO_GROUP} > /dev/null
    fi
}

preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        if [ ! -d "${wizard_download_dir}" ]; then
            echo "Download directory ${wizard_download_dir} does not exist."
            exit 1
        fi
        if [ -n "${wizard_watch_dir}" -a ! -d "${wizard_watch_dir}" ]; then
            echo "Watch directory ${wizard_watch_dir} does not exist."
            exit 1
        fi
    fi

    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Install the web interface
    cp -pR ${INSTALL_DIR}/share/${PACKAGE} ${WEB_DIR}

    # Configure open_basedir
    if [ "${APACHE_USER}" == "nobody" ]; then
        echo -e "<Directory \"${WEB_DIR}/${PACKAGE}\">\nphp_admin_value open_basedir none\n</Directory>" > /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf
    else
        echo -e "[PATH=${WEB_DIR}/${PACKAGE}]\nopen_basedir = Null" > /etc/php/conf.d/${PACKAGE_NAME}.ini
    fi

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${APACHE_USER} -s /bin/sh -S -D ${USER}

    # Configure files
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        TOP_DIR=`echo "${wizard_download_dir:=/volume1/downloads}" | cut -d "/" -f 2`
        MAX_MEMORY=`awk '/MemTotal/{memory=$2*1024*0.25; if (memory > 512*1024*1024) memory=512*1024*1024; printf "%0.f", memory}' /proc/meminfo`

        sed -i -e "s|scgi_port = 5000;|scgi_port = 8050;|g" \
               -e "s|topDirectory = '/';|topDirectory = '/${TOP_DIR}/';|g" \
               -e "s|tempDirectory = null;|tempDirectory = '${INSTALL_DIR}/tmp';|g" \
               ${WEB_DIR}/${PACKAGE}/conf/config.php

        sed -i -e "s|@download_dir@|${wizard_download_dir:=/volume1/downloads}|g" \
               -e "s|@max_memory@|$MAX_MEMORY|g" \
               -e "s|@port_range@|${wizard_port_range:=6881-6999}|g" \
               ${INSTALL_DIR}/var/.rtorrent.rc

        if [ -d "${wizard_watch_dir}" ]; then
            sed -i -e "s|@watch_dir@|${wizard_watch_dir}|g" ${INSTALL_DIR}/var/.rtorrent.rc
        else
            sed -i -e "/@watch_dir@/d" ${INSTALL_DIR}/var/.rtorrent.rc
        fi

        if [ "${wizard_disable_openbasedir}" == "true" ] && [ "${APACHE_USER}" == "http" ]; then
            sed -i -e "s|^open_basedir.*|open_basedir = none|g" /etc/php/conf.d/user-settings.ini
            initctl restart php-fpm > /dev/null 2>&1
        fi

        # Set directories permissions for DSM5
        if [ `/bin/get_key_value /etc.defaults/VERSION buildnumber` -ge "4418" ]; then

            # Allow root traversal
            SHARE_DIR=`echo ${wizard_download_dir:=/volume1/downloads} | awk -F/ '{print "/"$2"/"$3}'`
            if [ ! "`synoacltool -get $SHARE_DIR | grep \"group:http:allow:..x\"`" ]; then
                synoacltool -add $SHARE_DIR group:http:allow:--x----------:---n &> /dev/null
            fi

            if [ "`synoacltool -get ${wizard_download_dir:=/volume1/downloads} | grep \"group:http\"`" ]; then
                synoacltool -replace ${wizard_download_dir:=/volume1/downloads} `synoacltool -get ${wizard_download_dir:=/volume1/downloads} | grep "group:http" | awk 'BEGIN { OFS=" "; } { gsub(/[^[:alnum:]]/, "", $1); print $1;}' | head -1` group:http:allow:rwxpdDaARWc--:fd-- &> /dev/null
            else
                synoacltool -add ${wizard_download_dir:=/volume1/downloads} group:http:allow:rwxpdDaARWc--:fd-- &> /dev/null
            fi

            if [ -d "${wizard_watch_dir}" ]; then
                if [ "`synoacltool -get ${wizard_watch_dir} | grep \"group:http\"`" ]; then
                    synoacltool -replace ${wizard_watch_dir} `synoacltool -get ${wizard_watch_dir} | grep "group:http" | awk 'BEGIN { OFS=" "; } { gsub(/[^[:alnum:]]/, "", $1); print $1;}' | head -1` group:http:allow:rwxpdDaARWc--:fd-- &> /dev/null
                else
                    synoacltool -add ${wizard_watch_dir} group:http:allow:rwxpdDaARWc--:fd-- &> /dev/null
                fi
            fi
        fi
    fi

    syno_group_create

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}
    chown -R ${USER}:${APACHE_USER} ${INSTALL_DIR}/tmp
    chown -R ${APACHE_USER}:${APACHE_USER} ${WEB_DIR}/${PACKAGE}

    # Add firewall config
    ${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        syno_group_remove

        delgroup ${USER} ${APACHE_USER}
        deluser ${USER}
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

    # Remove open_basedir configuration
    rm -f /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf
    rm -f /etc/php/conf.d/${PACKAGE_NAME}.ini

    # Remove the web interface
    rm -fr ${WEB_DIR}/${PACKAGE}

    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Revision 8 introduces backward incompatible changes
    if [ `echo ${SYNOPKG_OLD_PKGVER} | sed -r "s/^.*-([0-9]+)$/\1/"` -le 8 ]; then
        sed -i -e "s|http_cacert = .*|http_cacert = ${INSTALL_DIR}/cert.pem|g" ${INSTALL_DIR}/var/.rtorrent.rc
    fi

    # Save the configuration file
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${WEB_DIR}/${PACKAGE}/conf/config.php ${TMP_DIR}/${PACKAGE}/
    cp -pr ${WEB_DIR}/${PACKAGE}/share/ ${TMP_DIR}/${PACKAGE}/
    mv ${INSTALL_DIR}/var/.rtorrent.rc ${TMP_DIR}/${PACKAGE}/
    mv ${INSTALL_DIR}/var/.session ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore the configuration file
    mv ${TMP_DIR}/${PACKAGE}/config.php ${WEB_DIR}/${PACKAGE}/conf/
    cp -pr ${TMP_DIR}/${PACKAGE}/share/*/ ${WEB_DIR}/${PACKAGE}/share/
    mv ${TMP_DIR}/${PACKAGE}/.rtorrent.rc ${INSTALL_DIR}/var/
    mv ${TMP_DIR}/${PACKAGE}/.session ${INSTALL_DIR}/var/
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
