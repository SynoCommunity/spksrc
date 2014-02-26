#!/bin/sh

# Package
PACKAGE="shairport"
DNAME="ShairPort"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # persuade asla to let use use that playback device
    mv ${INSTALL_DIR}/share/alsa/alsa.conf ${INSTALL_DIR}/share/alsa/alsa.original.bak
    cat ${INSTALL_DIR}/share/alsa/alsa.original.bak | grep -v "defaults.pcm.dmix.rate" > ${INSTALL_DIR}/share/alsa/alsa.conf
    rm ${INSTALL_DIR}/share/alsa/alsa.original.bak 
    echo "defaults.pcm.dmix.rate 44100" >> ${INSTALL_DIR}/share/alsa/alsa.conf
    echo "defaults.pcm.ipc_gid    \"root\"" >> ${INSTALL_DIR}/share/alsa/alsa.conf

    # create some /var directory - just for us...
    mkdir ${INSTALL_DIR}/var
    
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
    # Remove link
    rm -f ${INSTALL_DIR}

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
