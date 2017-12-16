#!/bin/sh

# Package
PACKAGE="bicbucstriim"
DNAME="BicBucStriim"
SHORTNAME="bbs"
PACKAGE_NAME="com.synocommunity.packages.${SHORTNAME}"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"

USER="$([ "${BUILDNUMBER}" -ge "4418" ] && echo -n http || echo -n nobody)"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Install the web interface
    cp -pR ${INSTALL_DIR}/share/${SHORTNAME} ${WEB_DIR}

    # Configure open_basedir
    if [ "${USER}" == "nobody" ]; then
        echo -e "<Directory \"${WEB_DIR}/${SHORTNAME}\">\nphp_admin_value open_basedir none\n</Directory>" > /usr/syno/etc/sites-enabled-user/${SHORTNAME}.conf
    else
        echo -e "extension = pdo_sqlite.so\nextension = sqlite3.so\n[PATH=${WEB_DIR}/${SHORTNAME}]\nopen_basedir = Null" > /etc/php/conf.d/${PACKAGE_NAME}.ini
    fi

    # Fix permissions
    chown -R ${USER} ${WEB_DIR}/${SHORTNAME}
    chmod -R u+rw ${WEB_DIR}/${SHORTNAME}/data

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
    rm -f /usr/syno/etc/sites-enabled-user/${SHORTNAME}.conf
    rm -f /etc/php/conf.d/${PACKAGE_NAME}.ini

    # Remove the web interface
    rm -fr ${WEB_DIR}/${SHORTNAME}

    exit 0
}

preupgrade ()
{
    # Save data
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${WEB_DIR}/${SHORTNAME}/data/authors ${TMP_DIR}/${PACKAGE}/data/
    mv ${WEB_DIR}/${SHORTNAME}/data/titles ${TMP_DIR}/${PACKAGE}/data/

    exit 0
}

postupgrade ()
{
    # Restore data
    mv ${TMP_DIR}/${PACKAGE}/data/authors ${WEB_DIR}/${SHORTNAME}/data/
    mv ${TMP_DIR}/${PACKAGE}/data/titles ${WEB_DIR}/${SHORTNAME}/data/
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
