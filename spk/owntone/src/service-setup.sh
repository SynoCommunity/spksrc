
CFG_FILE="${SYNOPKG_PKGVAR}/owntone.conf"
OWNTONE="${SYNOPKG_PKGDEST}/sbin/owntone"
SERVICE_COMMAND="${OWNTONE} -c ${CFG_FILE} -P ${PID_FILE}"

service_postinst ()
{
    echo "TODO: implement service post installation."
}
