PYTHON_DIR="/usr/local/python3"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
VIRTUALENV="${PYTHON_DIR}/bin/python3 -m venv"
PIP=${SYNOPKG_PKGDEST}/env/bin/pip3

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env 2>&1 >> ${INST_LOG}

    # Install the wheels
    ${PIP} install --no-deps --no-index --upgrade --force-reinstall --find-links ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl 2>&1 >> ${INST_LOG}

    # Log installation information
    echo -e "\nInstalled version:" >> ${INST_LOG}
    ${SYNOPKG_PKGDEST}/env/bin/beet version 2>&1 >> ${INST_LOG}
    echo -e "\nInstalled python modules:" >> ${INST_LOG}
    ${PIP} freeze 2>&1 >> ${INST_LOG}
    echo "" >> ${INST_LOG}
}
