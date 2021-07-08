GIT_DIR="/usr/local/git"
JAVA_DIR="/var/packages/Java8/target/j2sdk-image"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${JAVA_DIR}/bin:${GIT_DIR}/bin:${PATH}"
NZBHYDRA2="${SYNOPKG_PKGDEST}/share/NZBHydra2/nzbhydra2"
DB_FILE="${SYNOPKG_PKGDEST}/var/nzbhydra2.db"
DATA_FOLDER="${SYNOPKG_PKGDEST}/var/data"
CONF_FILE="${SYNOPKG_PKGDEST}/var/settings.cfg"
PID_FILE="${SYNOPKG_PKGDEST}/var/nzbhydra2.pid"

SERVICE_COMMAND="${NZBHYDRA2} --daemon --nobrowser --datafolder ${DATA_FOLDER} --pidfile ${PID_FILE}"

service_postinst ()
{
    # Fix exec permissions
    chmod u+x "${NZBHYDRA2}"
}

service_postupgrade ()
{
    # Fix exec permissions
    chmod u+x "${NZBHYDRA2}"
}
