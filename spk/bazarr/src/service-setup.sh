# Package
PACKAGE="bazarr"

# Others
PYTHON_DIR="/var/packages/python38/target"

VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"

GROUP="sc-download"
SVC_BACKGROUND=y
SVC_WRITE_PID=y
SVC_CWD="${SYNOPKG_PKGDEST}/share/${PACKAGE}"

export SYNOPKG_PKGDEST
export SYNOPKG_PKGVAR

service_postinst ()
{

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env

    # Install the wheels (using virtual env through PATH)
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall \
        -f ${SYNOPKG_PKGDEST}/share/wheelhouse \
        ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl

    mkdir -p "${SYNOPKG_PKGVAR}/data"
    
    if [ -n "${SYNOPKG_DSM_VERSION_MAJOR}" ] && [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
      set_unix_permissions "${SYNOPKG_PKGVAR}/data"
    fi
}
