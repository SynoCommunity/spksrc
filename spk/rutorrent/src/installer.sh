#!/bin/sh

# Package
PACKAGE="rutorrent"
DNAME="ruTorrent"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/usr/bin:${PATH}"
USER="rutorrent"
GROUP="users"
USER="$([ $(grep buildnumber /etc.defaults/VERSION | cut -d"\"" -f2) -ge 4418 ] && echo -n http || echo -n nobody)"
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

    # Install the web interface
    cp -R ${INSTALL_DIR}/share/${PACKAGE} ${WEB_DIR}

    # Configure open_basedir
    echo -e "<Directory \"${WEB_DIR}/${PACKAGE}\">\nphp_admin_value open_basedir none\n</Directory>" > /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}

    # Configure files
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        TOP_DIR=`echo "${wizard_download_dir:=/volume1/downloads}" | cut -d "/" -f 2`
        MAX_MEMORY=`awk '/MemTotal/{memory=$2*1024*0.25; if (memory > 512*1024*1024) memory=512*1024*1024; printf "%0.f", memory}' /proc/meminfo`

        sed -i -e "s|scgi_port = 5000;|scgi_port = 8050;|g" \
               -e "s|topDirectory = '/';|topDirectory = '/${TOP_DIR}/';|g" \
               ${WEB_DIR}/${PACKAGE}/conf/config.php

        sed -i -e "s|@download_dir@|${wizard_download_dir:=/volume1/downloads}|g" \
               -e "s|@max_memory@|$MAX_MEMORY|g" \
               ${INSTALL_DIR}/var/.rtorrent.rc

        if [ -d "${wizard_watch_dir}" ]; then
            sed -i -e "s|@watch_dir@|${wizard_watch_dir}|g" ${INSTALL_DIR}/var/.rtorrent.rc
        else
            sed -i -e "/@watch_dir@/d" ${INSTALL_DIR}/var/.rtorrent.rc
        fi
    fi

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}
    chown -R ${APACHE_USER} ${WEB_DIR}/${PACKAGE}

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

    # Remove open_basedir configuration
    rm /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf

    # Remove the web interface
    rm -fr ${WEB_DIR}/${PACKAGE}

    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Save the configuration file
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${WEB_DIR}/${PACKAGE}/conf/config.php ${TMP_DIR}/${PACKAGE}/
    mv ${INSTALL_DIR}/var/.rtorrent.rc ${TMP_DIR}/${PACKAGE}/
    mv ${INSTALL_DIR}/var/.session ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore the configuration file
    mv ${TMP_DIR}/${PACKAGE}/config.php ${WEB_DIR}/${PACKAGE}/conf/
    mv ${TMP_DIR}/${PACKAGE}/.rtorrent.rc ${INSTALL_DIR}/var/
    mv ${TMP_DIR}/${PACKAGE}/.session ${INSTALL_DIR}/var/
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
