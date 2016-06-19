#!/bin/sh

# Package
PACKAGE="wallabag"
DNAME="Wallabag"
PACKAGE_NAME="com.synocommunity.packages.${PACKAGE}"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web"
USER="$([ $(/bin/get_key_value /etc.defaults/VERSION buildnumber) -ge 4418 ] && echo -n http || echo -n nobody)"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Install the web interface
    cp -pR ${INSTALL_DIR}/share/${PACKAGE} ${WEB_DIR}

    # Configure open_basedir
    if [ "${USER}" == "nobody" ]; then
        echo -e "<Directory \"${WEB_DIR}/${PACKAGE}\">\nphp_admin_value open_basedir none\n</Directory>" > /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf
    else
        echo -e "extension = tidy.so\n[PATH=${WEB_DIR}/${PACKAGE}]\nopen_basedir = Null" > /etc/php/conf.d/${PACKAGE_NAME}.ini
    fi

    # permissions
    chown -R ${USER} ${WEB_DIR}/${PACKAGE}
    chmod -R u+rw ${WEB_DIR}/${PACKAGE}/cache
    chmod -R u+rw ${WEB_DIR}/${PACKAGE}/db

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

    # Remove open_basedir configuration
    rm -f /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf
    rm -f /etc/php/conf.d/${PACKAGE_NAME}.ini

    # Remove the web interface
    rm -fr ${WEB_DIR}/${PACKAGE}

    exit 0
}

preupgrade ()
{
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${WEB_DIR}/${PACKAGE}/inc/poche/config.inc.php ${TMP_DIR}/${PACKAGE}/
    mv ${WEB_DIR}/${PACKAGE}/db ${TMP_DIR}/${PACKAGE}/
    exit 0
}

postupgrade ()
{
    rm -fr ${WEB_DIR}/${PACKAGE}/cache/*
    rm -fr ${WEB_DIR}/${PACKAGE}/install/
    mv ${TMP_DIR}/${PACKAGE}/config.inc.php ${WEB_DIR}/${PACKAGE}/inc/poche/
    mv ${TMP_DIR}/${PACKAGE}/db ${WEB_DIR}/${PACKAGE}/
    rm -fr ${TMP_DIR}/${PACKAGE}
    exit 0
}
