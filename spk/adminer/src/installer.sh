#!/bin/sh

# Package
PACKAGE="adminer"
DNAME="Adminer"
SHORTNAME="adminer"
PACKAGE_NAME="com.synocommunity.packages.${SHORTNAME}"

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
    cp -pR ${INSTALL_DIR}/share/${SHORTNAME} ${WEB_DIR}

    # Fix permissions
    chown -R ${USER} ${WEB_DIR}/${SHORTNAME}

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

    # Remove the web interface
    rm -fr ${WEB_DIR}/${SHORTNAME}

    exit 0
}

preupgrade ()
{
    exit 0
}

postupgrade ()
{
    exit 0
}
