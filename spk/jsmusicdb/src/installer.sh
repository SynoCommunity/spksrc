#!/bin/sh

# Get DSM Version for the web user
[ -f "/etc.defaults/VERSION" ] || exit 1
DSM_VERSION=`grep ^majorversion= /etc.defaults/VERSION | cut -d'"' -f2`
[ -z "$DSM_VERSION" ] && exit 1

if [ $DSM_VERSION -le 4 ]; then
	USER="nobody"
else
	USER="http"
fi

PACKAGE="jsmusicdb"
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web"
HERE="/bin/pwd"

preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Move the files to the web directory
    cp -R ${INSTALL_DIR}/www ${WEB_DIR}/${PACKAGE}

    # Move the proxy files
	mv ${WEB_DIR}/${PACKAGE}/proxy/synology/proxy.html /usr/syno/synoman/

    # Remove web interface from install directory
    rm -r ${INSTALL_DIR}/www

    # Fix persmission
    chown ${USER} -R ${WEB_DIR}/${PACKAGE}
    chown -R ${USER} ${WEB_DIR}/${PACKAGE}
    chmod -R 755 /usr/local/${PACKAGE}/ui
    chmod -R 644 /usr/local/${PACKAGE}/ui/images
    chmod -R 644 /usr/local/${PACKAGE}/ui/config
	
	# Create startmenu entry
    cd ${HERE}
    eval $(env | grep "^SYNOPKG_PKGDEST=")
    ret=`ln -s "${SYNOPKG_PKGDEST}/ui" /usr/syno/synoman/webman/3rdparty/jsmusicdb`
    ret=`chown -R admin:users $SYNOPKG_PKGDEST`

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

	# Remove web directory
    rm -fr ${WEB_DIR}/${PACKAGE}

	rm -rf /usr/syno/synoman/proxy.html
	
	# Remove startmenu entry
    rm -f /usr/syno/synoman/webman/3rdparty/jsmusicdb

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
