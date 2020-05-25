
PACKAGE="itools"
INSTALL_DIR="/usr/local/${PACKAGE}"
VOLUME_DIR="${INSTALL_DIR}/volume"

SVC_CWD="${SYNOPKG_PKGDEST}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
    easy_install lockfile  >> ${INST_LOG} 2>&1
    ln -s ${SYNOPKG_PKGDEST_VOL} ${VOLUME_DIR}  >> ${INST_LOG} 2>&1
}

service_postuninst ()
{
    rm -f ${VOLUME_DIR}  >> ${INST_LOG} 2>&1
}

service_prestart ()
{
    cp ${SYNOPKG_PKGDEST}/39-libimobiledevice.rules /usr/lib/udev/rules.d/  >> ${LOG_FILE} 2>&1 
    udevadm control --reload-rules  >> ${LOG_FILE} 2>&1
}

service_poststop ()
{
    ${INSTALL_DIR}/umounting.py  >> ${LOG_FILE} 2>&1
    rm -f /usr/lib/udev/rules.d/39-libimobiledevice.rules  >> ${LOG_FILE} 2>&1
    udevadm control --reload-rules  >> ${LOG_FILE} 2>&1
}
