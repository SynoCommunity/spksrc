# The daemon writes its own PID after loading its accounts and configuration.
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/repo-sync --data ${SYNOPKG_PKGVAR}/private"
SVC_BACKGROUND=yes
PID_FILE="${SYNOPKG_PKGVAR}/private/service.pid"
LOG_FILE="${SYNOPKG_PKGVAR}/private/service.log"
umask 077

# Credentials come from the initial installation wizard, never arguments.
service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        "${SYNOPKG_PKGDEST}/bin/repo-sync" --init-admin
    fi
}
