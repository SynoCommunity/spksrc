#!/bin/sh

# Package
PACKAGE="nzbget"
DNAME="NZBGet"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="nzbget"
CFG_FILE="${INSTALL_DIR}/var/nzbget.conf"
PHP_CFG_FILE="/usr/syno/etc/php/user-setting.ini"
WEB_CFG_FILE="${INSTALL_DIR}/var/settings.php"
WEB_DIR="/var/services/web"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"


preinst ()
{
    # Installation wizard requirements
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ] && [ ! -d "${wizard_download_dir}" ]; then
        exit 1
    fi

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

    # Install the web interface
    cp -R ${INSTALL_DIR}/share/nzbgetweb ${WEB_DIR}
    ln -s ${INSTALL_DIR}/var/settings.php ${WEB_DIR}/nzbgetweb/settings.php
    sed -i -e "s|^\(open_basedir = .*\)$|\1:${INSTALL_DIR}/var|g" ${PHP_CFG_FILE}

    # Edit the configuration according to the wizzard
    sed -i -e "s|@download_dir@|${wizard_download_dir}|g" ${CFG_FILE}
    sed -i -e "s|@download_dir@|${wizard_download_dir}|g" ${WEB_CFG_FILE}

    # Correct the files ownership
    chown -R ${RUNAS}:root ${SYNOPKG_PKGDEST}

    exit 0
}

preuninst ()
{
    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        deluser ${RUNAS}
    fi

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

    # Remove the web interface
    rm -fr ${WEB_DIR}/nzbgetweb
    sed -i -e "s|^\(open_basedir = .*\):${INSTALL_DIR}/var\(.*\)$|\1\2|g" ${PHP_CFG_FILE}

    exit 0
}

preupgrade ()
{
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

