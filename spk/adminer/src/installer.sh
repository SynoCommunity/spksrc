#!/bin/sh

# Package
PACKAGE="adminer"
DNAME="Adminer"

# Others
INSTALL_DIR=${SYNOPKG_PKGDEST}/web
WEB_DIR="/var/services/web"

HTACCESS_FILE=${INSTALL_DIR}/.htaccess

preinst ()
{
    exit 0
}

postinst ()
{
    # Edit .htaccess according to the wizard
    sed -i -e "s|@@_wizard_htaccess_allowed_from_@@|${wizard_htaccess_allowed_from}|g" ${HTACCESS_FILE}

    # Install the web interface
    cp -pR ${INSTALL_DIR} ${WEB_DIR}/adminer

    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    # Remove the web interface
    rm -rf ${WEB_DIR}/adminer

    exit 0
}

preupgrade ()
{
    exit 0
}

postupgrade ()
{
    # Edit .htaccess according to the wizard
    sed -i -e "s|@@_wizard_htaccess_allowed_from_@@|${wizard_htaccess_allowed_from}|g" ${HTACCESS_FILE}
    
    exit 0
}
