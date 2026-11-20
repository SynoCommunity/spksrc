# Advanced ACME: renewal service, data folders and the uninstall option
# "delete data" (replaces the package's own start-stop-status, postinst and
# preuninst).

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/advanced-acme service-loop"
SVC_BACKGROUND=y
SVC_WRITE_PID=y
# The service writes its own log (var/logs/service.log).
SVC_NO_REDIRECT=y

service_postinst ()
{
    # Persistent data: survives package and DSM updates.
    mkdir -p "${SYNOPKG_PKGVAR}/acme" "${SYNOPKG_PKGVAR}/secrets" "${SYNOPKG_PKGVAR}/meta" \
        "${SYNOPKG_PKGVAR}/jobs" "${SYNOPKG_PKGVAR}/logs"
    chmod 700 "${SYNOPKG_PKGVAR}" "${SYNOPKG_PKGVAR}/secrets"
}

service_preuninst ()
{
    # "Delete data": also delete the DSM account "advanced-acme" if Advanced
    # ACME created it (the data itself is removed by the generic postuninst).
    # A DSM task removes itself once the package folder is gone.
    if [ "${wizard_delete_data}" = "true" ] && [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        timeout 120 "${SYNOPKG_PKGDEST}/bin/advanced-acme" dsm-forget || true
    fi
}
