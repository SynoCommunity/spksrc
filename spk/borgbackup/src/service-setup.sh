
PYTHON_DIR="/var/packages/python38/target/bin"
VIRTUALENV="${PYTHON_DIR}/python3 -m venv"
PIP=${SYNOPKG_PKGDEST}/env/bin/pip3
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env

    # Install the wheels
    wheelhouse=${SYNOPKG_PKGDEST}/share/wheelhouse
    ${PIP} install --no-deps --no-index --upgrade --force-reinstall --find-links ${wheelhouse} ${wheelhouse}/*.whl
}

