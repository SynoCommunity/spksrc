#!/bin/sh

# Package
PACKAGE="adminer"
DNAME="Adminer"

HTACCESS_FILE=/var/services/web_packages/adminer/.htaccess

preinst ()
{
    exit 0
}

postinst ()
{
    # Edit .htaccess according to the wizard
    sed -i -e "s|@@_wizard_htaccess_allowed_from_@@|${wizard_htaccess_allowed_from}|g" ${HTACCESS_FILE}

    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
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
