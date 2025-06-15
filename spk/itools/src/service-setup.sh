

# service requires root access, not supported on DSM >= 7
if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then

VOLUME_DIR="${SYNOPKG_PKGDEST}/volume"

SERVICE_COMMAND = ${SYNOPKG_PKGDEST}/sbin/usbmuxd
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
    ${SYNOPKG_PKGDEST}/umounting.py
    rm -f /usr/lib/udev/rules.d/39-libimobiledevice.rules
    udevadm control --reload-rules
}

fi
