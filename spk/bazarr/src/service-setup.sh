# Package
PACKAGE="bazarr"

# Others
PYTHON_DIR="/var/packages/python38/target"

VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"

SC_USER="sc-${PACKAGE}"
GROUP="sc-download"
SVC_BACKGROUND=y
PID_FILE="${SYNOPKG_PKGVAR}/bazarr.pid"
SVC_WRITE_PID=y
SVC_CWD="${SYNOPKG_PKGDEST}/share/${PACKAGE}"

service_postinst ()
{

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG} 2>&1

    # Install the wheels (using virtual env through PATH)
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall \
        -f ${SYNOPKG_PKGDEST}/share/wheelhouse \
        ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG} 2>&1

    mkdir -p "${SYNOPKG_PKGVAR}/data"  >> "${INST_LOG}" 2>&1
    
    set_unix_permissions "${SYNOPKG_PKGVAR}/data" >> "${INST_LOG}" 2>&1

}
