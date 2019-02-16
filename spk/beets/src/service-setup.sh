PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env > /dev/null

    # Install the wheels
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG} 2>&1

    # Add symlink
    mkdir -p /usr/local/bin
    ln -s ${SYNOPKG_PKGDEST}/env/bin/beet /usr/local/bin/beet

    # Extended diagnostic information
    ${SYNOPKG_PKGDEST}/env/bin/beet version >> ${INST_LOG}
    ${SYNOPKG_PKGDEST}/env/bin/beet --version --help >> ${INST_LOG}
    echo -e "\nModules:" >> ${INST_LOG}
    ${SYNOPKG_PKGDEST}/env/bin/pip freeze >> ${INST_LOG}
}

service_postuninst ()
{
    rm /usr/local/bin/beet
}
