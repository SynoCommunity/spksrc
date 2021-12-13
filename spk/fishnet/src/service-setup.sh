# Define python310 binary path
PYTHON_DIR="/var/packages/python310/target/bin"
# Add local bin, virtualenv along with python310 to the default PATH
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"

service_postinst ()
{
    # Create a Python virtualenv
    install_python_virtualenv

    # Install the wheels
    install_python_wheels

    # get target file independent of python3 version
    target=$(${SYNOPKG_PKGDEST}/env/bin/python3 -m site | grep -o "[^']*${SYNOPKG_PKGNAME}/env[^']*")/fishnet.py
    
    # Fix shebang
    sed -i -e "s|^#!.*$|#!${SYNOPKG_PKGDEST}/env/bin/python3|g" ${target}
    
    # make script executable and create a link to ${SYNOPKG_PKGDEST}/bin/fishnet
    chmod +x ${target}
    ln -s ${target} ${SYNOPKG_PKGDEST}/bin/fishnet
}

