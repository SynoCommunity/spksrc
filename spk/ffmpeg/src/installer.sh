#!/bin/sh

# Package
PACKAGE="ffmpeg"
DNAME="ffmpeg"

FFMPEG_TARGET="/usr/local/bin/${PACKAGE}"
FFPROBE_TARGET="/usr/local/bin/ffprobe"
FFSERVER_TARGET="/usr/local/bin/ffserver"
# Others
INSTALL_DIR="/usr/local/${PACKAGE}"



preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}
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

