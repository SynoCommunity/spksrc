
### service-setup.sh

PYTHON_DIR="/var/packages/python310/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"
DUPLICITY_VERSION="0.8.21"
DUPLICITY_INIT="${SYNOPKG_PKGDEST}/env/lib/python3.10/site-packages/duplicity/__init__.py"

service_postinst ()
{
    # Create a Python virtualenv
    install_python_virtualenv

    # Install the wheels
    install_python_wheels

    sed -i -e "/^__version__ =/s/=.*/= u\x27${DUPLICITY_VERSION}\x27/" ${DUPLICITY_INIT}
}

