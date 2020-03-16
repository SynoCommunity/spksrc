
PACKAGE="itools"
INSTALL_DIR="/usr/local/${PACKAGE}"
VOLUME_DIR="${INSTALL_DIR}/volume"

SVC_CWD="${SYNOPKG_PKGDEST}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
    easy_install lockfile  >> ${INST_LOG}
    ln -s ${SYNOPKG_PKGDEST_VOL} ${VOLUME_DIR}  >> ${INST_LOG}
}

service_postuninst ()
{
    rm -f ${VOLUME_DIR}  >> ${INST_LOG}
}

service_prestart ()
{
    cp ${SYNOPKG_PKGDEST}/39-libimobiledevice.rules /usr/lib/udev/rules.d/  >> ${INST_LOG}
    udevadm control --reload-rules  >> ${INST_LOG}
}

service_poststop ()
{
    ${INSTALL_DIR}/umounting.py  >> ${INST_LOG}
    rm -f /usr/lib/udev/rules.d/39-libimobiledevice.rules  >> ${INST_LOG}
    udevadm control --reload-rules  >> ${INST_LOG}
}
