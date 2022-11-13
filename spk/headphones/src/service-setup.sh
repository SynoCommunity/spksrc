PYTHON_DIR="/var/packages/python310/target/bin"
GIT_DIR="/var/packages/git/target/bin"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}:${GIT_DIR}:${PATH}"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python3"
HEADPHONES="${SYNOPKG_PKGDEST}/share/Headphones/Headphones.py"
CFG_FILE="${SYNOPKG_PKGVAR}/config.ini"

SERVICE_COMMAND="${PYTHON} ${HEADPHONES} --daemon --pidfile ${PID_FILE} --config ${CFG_FILE} --datadir ${SYNOPKG_PKGVAR}/"

GROUP="sc-download"

service_postinst ()
{
    # Create a Python virtualenv
    install_python_virtualenv
}
