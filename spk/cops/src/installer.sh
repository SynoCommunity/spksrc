#!/bin/sh

# Package
PACKAGE="cops"
DNAME="COPS"
PACKAGE_NAME="com.synocommunity.packages.${PACKAGE}"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
DEFAULT_CFG_FILE="/usr/local/${PACKAGE}/config_local.php.synology"
WEB_DIR="/var/services/web"
CFG_FILE="${WEB_DIR}/${PACKAGE}/config_local.php"
USER="$([ $(grep buildnumber /etc.defaults/VERSION | cut -d"\"" -f2) -ge 4418 ] && echo -n http || echo -n nobody)"

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
        echo -e "<Directory \"${WEB_DIR}/${PACKAGE}\">\nphp_admin_value open_basedir ${WEB_DIR}/${PACKAGE}:${wizard_calibre_dir:=/volume1/calibre/} \n</Directory>" > /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf
    else
        echo -e "[PATH=${WEB_DIR}/${PACKAGE}]\nopen_basedir = ${WEB_DIR}/${PACKAGE}:${wizard_calibre_dir:=/volume1/calibre/}" > /etc/php/conf.d/${PACKAGE_NAME}.ini
    fi

    # Create a default configuration file
    if [ ! -f ${CFG_FILE} ]; then
      cp ${DEFAULT_CFG_FILE} ${CFG_FILE}
      url_rewriting=$([ "${wizard_use_url_rewriting}" == "true" ] && echo "1" || echo "0")
      sed -i -e "s|@calibre_dir@|${wizard_calibre_dir:=/volume1/calibre/}|g" ${CFG_FILE}
      sed -i -e "s|@cops_title@|${wizard_cops_title:=COPS}|g" ${CFG_FILE}
      sed -i -e "s|@use_url_rewriting@|${url_rewriting:=0}|g" ${CFG_FILE}
      chmod ga+w ${CFG_FILE}
    fi

    # Set permissions
    chown ${USER}:root ${wizard_calibre_dir:=/volume1/calibre/}
    chmod u+rw ${wizard_calibre_dir:=/volume1/calibre/}
    chown ${USER}:root ${wizard_calibre_dir:=/volume1/calibre/}/metadata.db
    chmod u+rw ${wizard_calibre_dir:=/volume1/calibre/}/metadata.db

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
    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${CFG_FILE} ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -f ${CFG_FILE}
    mv ${TMP_DIR}/${PACKAGE}/config_local.php ${CFG_FILE}
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
