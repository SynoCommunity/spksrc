# Package
PACKAGE="bazarr"

# Others
PYTHON_DIR="/var/packages/python38/target"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${PATH}"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python3"
VIRTUALENV="${PYTHON_DIR}/bin/python3 -m venv"
PIP=${SYNOPKG_PKGDEST}/env/bin/pip

GROUP="sc-download"
SVC_BACKGROUND=y
SVC_WRITE_PID=y
SVC_CWD="${SYNOPKG_PKGDEST}/share/${PACKAGE}"

service_postinst ()
{

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env

    wheelhouse=${SYNOPKG_PKGDEST}/share/wheelhouse

    # Install the wheels (using virtual env through PATH)
    ${PIP} install --no-deps --no-index --upgrade --force-reinstall --find-links ${wheelhouse} ${wheelhouse}/*.whl

    mkdir -p "${SYNOPKG_PKGVAR}/data"

    if [ -n "${SYNOPKG_DSM_VERSION_MAJOR}" ] && [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
      set_unix_permissions "${SYNOPKG_PKGVAR}/data"
    fi
}
