PYTHON_DIR="/var/packages/python312/target/bin"
GIT_DIR="/var/packages/git/target/bin"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}:${GIT_DIR}:${PATH}"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python3"
HEADPHONES="${SYNOPKG_PKGDEST}/share/Headphones/Headphones.py"
CFG_FILE="${SYNOPKG_PKGVAR}/config.ini"

SERVICE_COMMAND="${PYTHON} ${HEADPHONES} --daemon --pidfile ${PID_FILE} --config ${CFG_FILE} --datadir ${SYNOPKG_PKGVAR}/"

if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
    GROUP="sc-download"
fi

service_postinst ()
{
    # Create a Python virtualenv
    install_python_virtualenv
}
