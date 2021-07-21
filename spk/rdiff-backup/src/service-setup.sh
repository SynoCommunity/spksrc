

service_postinst ()
{
    # Create a Python virtualenv
    /var/packages/python3/target/bin/python3 -m venv ${SYNOPKG_PKGDEST}/env

    # Install the wheels
    wheelhouse=${SYNOPKG_PKGDEST}/share/wheelhouse
    ${SYNOPKG_PKGDEST}/env/bin/pip3 install --no-deps --force-reinstall --no-index --find-links ${wheelhouse} ${wheelhouse}/*.whl

    exit 0
}
