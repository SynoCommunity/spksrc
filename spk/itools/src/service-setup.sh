
PACKAGE="itools"
INSTALL_DIR="/usr/local/${PACKAGE}"
VOLUME_DIR="${INSTALL_DIR}/volume"

SVC_CWD="${SYNOPKG_PKGDEST}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
    easy_install lockfile
    ln -s ${SYNOPKG_PKGDEST_VOL} ${VOLUME_DIR}
    ln -s ${SYNOPKG_PKGDEST}/bin/idevicebackup /usr/local/bin/idevicebackup
    ln -s ${SYNOPKG_PKGDEST}/bin/idevicebackup2 /usr/local/bin/idevicebackup2
    ln -s ${SYNOPKG_PKGDEST}/bin/idevicecrashreport /usr/local/bin/idevicecrashreport
    ln -s ${SYNOPKG_PKGDEST}/bin/idevicedate /usr/local/bin/idevicedate
    ln -s ${SYNOPKG_PKGDEST}/bin/idevicedebug /usr/local/bin/idevicedebug
    ln -s ${SYNOPKG_PKGDEST}/bin/idevicedebugserverproxy /usr/local/bin/idevicedebugserverproxy
    ln -s ${SYNOPKG_PKGDEST}/bin/idevicediagnostics /usr/local/bin/idevicediagnostics
    ln -s ${SYNOPKG_PKGDEST}/bin/ideviceenterrecovery /usr/local/bin/ideviceenterrecovery
    ln -s ${SYNOPKG_PKGDEST}/bin/idevice_id /usr/local/bin/idevice_id
    ln -s ${SYNOPKG_PKGDEST}/bin/ideviceimagemounter /usr/local/bin/ideviceimagemounter
    ln -s ${SYNOPKG_PKGDEST}/bin/ideviceinfo /usr/local/bin/ideviceinfo
    ln -s ${SYNOPKG_PKGDEST}/bin/idevicename /usr/local/bin/idevicename
    ln -s ${SYNOPKG_PKGDEST}/bin/idevicenotificationproxy /usr/local/bin/idevicenotificationproxy
    ln -s ${SYNOPKG_PKGDEST}/bin/idevicepair /usr/local/bin/idevicepair
    ln -s ${SYNOPKG_PKGDEST}/bin/ideviceprovision /usr/local/bin/ideviceprovision
    ln -s ${SYNOPKG_PKGDEST}/bin/idevicescreenshot /usr/local/bin/idevicescreenshot
    ln -s ${SYNOPKG_PKGDEST}/bin/idevicesyslog /usr/local/bin/idevicesyslog
    ln -s ${SYNOPKG_PKGDEST}/bin/ifuse /usr/local/bin/ifuse
    ln -s ${SYNOPKG_PKGDEST}/bin/iproxy /usr/local/bin/iproxy
    ln -s ${SYNOPKG_PKGDEST}/bin/plistutil /usr/local/bin/plistutil
}

service_postuninst ()
{
    rm -f ${VOLUME_DIR}
    rm -f /usr/local/bin/idevicebackup
    rm -f /usr/local/bin/idevicebackup2
    rm -f /usr/local/bin/idevicecrashreport
    rm -f /usr/local/bin/idevicedate
    rm -f /usr/local/bin/idevicedebug
    rm -f /usr/local/bin/idevicedebugserverproxy
    rm -f /usr/local/bin/idevicediagnostics
    rm -f /usr/local/bin/ideviceenterrecovery
    rm -f /usr/local/bin/idevice_id
    rm -f /usr/local/bin/ideviceimagemounter
    rm -f /usr/local/bin/ideviceinfo
    rm -f /usr/local/bin/idevicename
    rm -f /usr/local/bin/idevicenotificationproxy
    rm -f /usr/local/bin/idevicepair
    rm -f /usr/local/bin/ideviceprovision
    rm -f /usr/local/bin/idevicescreenshot
    rm -f /usr/local/bin/idevicesyslog
    rm -f /usr/local/bin/ifuse
    rm -f /usr/local/bin/iproxy
    rm -f /usr/local/bin/plistutil
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
