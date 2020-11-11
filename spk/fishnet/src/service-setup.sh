INSTALL_DIR="/usr/local/${SYNOPKG_PKGNAME}"
PYTHON_DIR="/usr/local/python3"
VIRTUALENV="${PYTHON_DIR}/bin/python3 -m venv"

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG}

    # Install the wheels
    ${SYNOPKG_PKGDEST}/env/bin/pip3 install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG}
    

    # get target file independent of python3 version
    target=$(${INSTALL_DIR}/env/bin/python -m site | grep -o "[^']*${SYNOPKG_PKGNAME}/env[^']*")/fishnet.py  >> ${INST_LOG}
    
    # Fix shebang
    sed -i -e "s|^#!.*$|#!${INSTALL_DIR}/env/bin/python3|g" ${target}  >> ${INST_LOG}
    
    # make script executable and create a link to ${INSTALL_DIR}/bin/fishnet
    chmod +x ${target}   >> ${INST_LOG}
    ln -s ${target} ${INSTALL_DIR}/bin/fishnet   >> ${INST_LOG}
}
