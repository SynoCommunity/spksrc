
PYTHON_DIR="/var/packages/python3/target/bin"
VIRTUALENV="${PYTHON_DIR}/python3 -m venv"

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env

    # Install the wheels
    wheelhouse=${SYNOPKG_PKGDEST}/share/wheelhouse
    ${SYNOPKG_PKGDEST}/env/bin/pip3 install --no-deps --no-index --upgrade --force-reinstall --find-links ${wheelhouse} ${wheelhouse}/*.whl
    

    # get target file independent of python3 version
    target=$(${SYNOPKG_PKGDEST}/env/bin/python3 -m site | grep -o "[^']*${SYNOPKG_PKGNAME}/env[^']*")/fishnet.py
    
    # Fix shebang
    sed -i -e "s|^#!.*$|#!${SYNOPKG_PKGDEST}/env/bin/python3|g" ${target}
    
    # make script executable and create a link to ${SYNOPKG_PKGDEST}/bin/fishnet
    chmod +x ${target}
    ln -s ${target} ${SYNOPKG_PKGDEST}/bin/fishnet
}

