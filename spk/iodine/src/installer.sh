#!/bin/sh

# Package
PACKAGE="iodine"

# Others
INSTALL_DIR="/var/packages/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
CONFIG=${INSTALL_DIR}/etc/config
preinst ()
{
    exit 0
}

postinst ()
{
    if [ ! -z ${password} ] ; then echo "PASSWORD=${password}" >> ${CONFIG} ; fi
    if [ ! -z ${ip} ] ; then echo "IP=${ip}" >> ${CONFIG} ; fi
    if [ ! -z ${topdomain} ] ; then echo "TOPDOMAIN=${topdomain}" >> ${CONFIG} ; fi
    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    exit 0
}

postuninst ()
{
    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    exit 0
}

postupgrade ()
{
    exit 0
}
