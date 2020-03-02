PYTHON_DIR="/usr/local/python3"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
VIRTUALENV="${PYTHON_DIR}/bin/python3 -m venv"

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env &>> ${INST_LOG}

    # Install the wheels
    ${SYNOPKG_PKGDEST}/env/bin/pip3 install --no-deps --no-index --upgrade --force-reinstall --find-links ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl &>> ${INST_LOG}

    # Log installation information
    echo -e "\nInstalled version:" >> ${INST_LOG}
    ${SYNOPKG_PKGDEST}/env/bin/beet version &>> ${INST_LOG}
    echo -e "\nInstalled python modules:" >> ${INST_LOG}
    ${SYNOPKG_PKGDEST}/env/bin/pip3 freeze >> ${INST_LOG}
    echo "" >> ${INST_LOG}
}
