
PYTHON_DIR="/var/packages/python312/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"

service_postinst ()
{
    separator="===================================================="

    echo ${separator}
    install_python_virtualenv

    echo ${separator}
    echo "Install packages from wheelhouse"
    pip install --disable-pip-version-check --no-deps --no-input --no-index ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl

    echo ${separator}
    echo "Install pure python packages from index"
    pip install --disable-pip-version-check --no-deps --no-input --cache-dir ${SYNOPKG_PKGVAR}/pip-cache --requirement ${SYNOPKG_PKGDEST}/share/wheelhouse/requirements-pure.txt

    echo ${separator}
    echo "Installed version:"
    ${SYNOPKG_PKGDEST}/env/bin/beet version
}
