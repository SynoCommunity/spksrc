PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"

FAN2GO="${SYNOPKG_PKGDEST}/bin/fan2go"
FAN2GO_CONF_FILE="${SYNOPKG_PKGVAR}/fan2go.yaml"
FAN2GO_DB_FILE="${SYNOPKG_PKGVAR}/fan2go.db"

HWMON_UDEV_RULES="/usr/lib/udev/rules.d/60-sc-fan2go-hwmon.rules"

SERVICE_COMMAND="${FAN2GO} -c ${FAN2GO_CONF_FILE} --no-style"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
    cp ${SYNOPKG_PKGDEST}/60-sc-fan2go-hwmon.rules /usr/lib/udev/rules.d/
    udevadm control --reload-rules
}

service_postuninst ()
{
    rm -f /usr/lib/udev/rules.d/60-sc-fan2go-hwmon.rules
    udevadm control --reload-rules
}
