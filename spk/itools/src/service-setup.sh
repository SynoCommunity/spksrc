
PACKAGE="itools"
INSTALL_DIR="/var/packages/${PACKAGE}/target"
VOLUME_DIR="${INSTALL_DIR}/volume"

SVC_CWD="${SYNOPKG_PKGDEST}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
    easy_install lockfile
    ln -s ${SYNOPKG_PKGDEST_VOL} ${VOLUME_DIR}
}

service_postuninst ()
{
    rm -f ${VOLUME_DIR}
}

service_prestart ()
{
    cp ${SYNOPKG_PKGDEST}/39-libimobiledevice.rules /usr/lib/udev/rules.d/
    udevadm control --reload-rules
}

service_poststop ()
{
    ${INSTALL_DIR}/umounting.py
    rm -f /usr/lib/udev/rules.d/39-libimobiledevice.rules
    udevadm control --reload-rules
}

