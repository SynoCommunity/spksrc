PYTHON_DIR="/usr/local/python3"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
VIRTUALENV="${PYTHON_DIR}/bin/python3 -m venv"
PIP=${SYNOPKG_PKGDEST}/env/bin/pip3

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG} 2>&1

    # Install the wheels
    ${PIP} install --no-deps --no-index --upgrade --force-reinstall --find-links ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG} 2>&1

    # Log installation information
    echo -e "\nInstalled version:" >> ${INST_LOG}
    ${SYNOPKG_PKGDEST}/env/bin/beet version >> ${INST_LOG} 2>&1
    echo -e "\nInstalled python modules:" >> ${INST_LOG}
    ${PIP} freeze >> ${INST_LOG} 2>&1
    echo "" >> ${INST_LOG}
}
