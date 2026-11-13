PYTHON_DIR="/var/packages/python312/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}:${PATH}"
export PYTHONPATH="${SYNOPKG_PKGDEST}/app"
export PYTHONDONTWRITEBYTECODE=1

service_postinst ()
{
    install_python_virtualenv
    install_python_wheels --only-binary=:all:
    # Report missing dependencies explicitly before the first service start.
    "${SYNOPKG_PKGDEST}/env/bin/python3" -c 'import sqlite3, ssl, waitress, archive_station' || exit 1
    chmod 700 "${SYNOPKG_PKGVAR}"
}

service_postupgrade ()
{
    service_postinst
}

validate_preupgrade ()
{
    "/var/packages/${SYNOPKG_PKGNAME}/scripts/start-stop-status" stop || exit 1
}

validate_preuninst ()
{
    validate_preupgrade
}
