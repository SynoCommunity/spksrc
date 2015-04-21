#!/bin/sh

# Package
PACKAGE="shairport"
DNAME="ShairPort"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
VAR_DIR="${INSTALL_DIR}/var"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:${PATH}"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"

preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

	# TODO maybe add an spk/shairport/src/alsa.conf with the correct configuration, and place that file during installation.
    # persuade alsa to let use use that playback device
    mv ${INSTALL_DIR}/share/alsa/alsa.conf ${INSTALL_DIR}/share/alsa/alsa.original.bak
    cat ${INSTALL_DIR}/share/alsa/alsa.original.bak | grep -v "defaults.pcm.dmix.rate" > ${INSTALL_DIR}/share/alsa/alsa.conf
    rm ${INSTALL_DIR}/share/alsa/alsa.original.bak 
    echo "defaults.pcm.dmix.rate 44100" >> ${INSTALL_DIR}/share/alsa/alsa.conf
    echo "defaults.pcm.ipc_gid    \"root\"" >> ${INSTALL_DIR}/share/alsa/alsa.conf

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

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
