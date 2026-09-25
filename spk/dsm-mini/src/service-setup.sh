# dsm-mini service setup for the spksrc generic installer.
#
# Nothing is asked at installation: the package starts with no settings and
# is set up in its window in the DSM main menu, which writes config.env in the
# package var. The service reads that file itself, on every start and again
# whenever the window saves it, so nothing here reads or writes it.

DSM_MINI="${SYNOPKG_PKGDEST}/bin/dsm-mini"

SERVICE_COMMAND="${DSM_MINI}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y
# The log is kept across restarts: a refusal logged just before an upgrade is
# often the only trace of why the upgrade was needed.
SVC_KEEP_LOG=y

service_prestart ()
{
    # Where config.env and the database live, and where the settings window
    # is: the service tells the window's CGI which port it listens on, because
    # the CGI runs as DSM's web server and cannot read config.env (0600).
    STATE_DIR="${SYNOPKG_PKGVAR}"
    UI_DIR="${SYNOPKG_PKGDEST}/app"
    export STATE_DIR UI_DIR
}

service_preuninst ()
{
    # Take the DSM notification webhook away with the package: nothing else
    # would, and DSM would keep calling a port nobody listens on. Only on a
    # real uninstall — the framework calls this during an upgrade as well, and
    # the next start would just create the webhook again under a new number.
    if [ "${SYNOPKG_PKG_STATUS}" != "UNINSTALL" ]; then
        return 0
    fi
    # The binary reads the settings itself; one that was never set up
    # registered nothing and says so. A NAS that cannot be reached is no
    # reason to keep a package somebody asked to remove, so a failure here is
    # logged and nothing more.
    STATE_DIR="${SYNOPKG_PKGVAR}" "${DSM_MINI}" unregister-webhook || true
}
