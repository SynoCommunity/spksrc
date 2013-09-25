#!/bin/sh

# Package
PACKAGE="synodlnatrakt"
DNAME="SynoDLNAtrakt"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PYTHON_DIR="/usr/local/python"
GIT_DIR="/usr/local/git"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${GIT_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin:${PATH}"
USER="synodlnatrakt"
GROUP="users"
GIT="${GIT_DIR}/bin/git"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    #make log writeable
    chmod 777 /var/log/lighttpd/access.log

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env > /dev/null

    #clone the repository
    ${GIT} clone -q git://github.com/cytec/SynoDLNAtrakt.git ${INSTALL_DIR}/share/SynoDLNAtrakt

    # Install configobj
    ${INSTALL_DIR}/env/bin/pip install -U -b ${INSTALL_DIR}/var/build configobj > /dev/null
    rm -fr ${INSTALL_DIR}/var/build

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}


    #check for debugmode and anable it...
    # sed -i.backup 's/loglevel_mediaservice.*/loglevel_mediaservice="3"/g' /var/packages/MediaServer/etc/dmsinfo.conf
    # /var/packages/MediaServer/scripts/start-stop-status stop
    # /var/packages/MediaServer/scripts/start-stop-status start

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        delgroup ${USER} ${GROUP}
        deluser ${USER}
    fi

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

    #remove debugmode stuff from mediaserver
    # rm -rf /var/packages/MediaServer/etc/dmsinfo.conf
    # cp /var/packages/MediaServer/etc/dmsinfo.conf.backup /var/packages/MediaServer/etc/dmsinfo.conf

    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

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
