#!/bin/sh

# Package
PACKAGE="ffmpeg"

FFMPEG_TARGET="/usr/bin/${PACKAGE}"
FFPROBE_TARGET="/usr/bin/ffprobe"
FFSERVER_TARGET="/usr/bin/ffserver"
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
    if [ ! -e "$FFMPEG_TARGET" ]; then
            ln -s ${INSTALL_DIR}/bin/ffmpeg ${FFMPEG_TARGET}
            ln -s ${INSTALL_DIR}/bin/ffprobe ${FFPROBE_TARGET}
            ln -s ${INSTALL_DIR}/bin/ffserver ${FFSERVER_TARGET}
    fi
    exit 0
}

preuninst ()
{
    rm -f ${FFMPEG_TARGET}
    rm -f ${FFPROBE_TARGET}
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

