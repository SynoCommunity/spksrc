PYTHON_DIR="/usr/local/python3"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}/bin:${PATH}"

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG}

    # Install the wheels
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG} 2>&1

    # Add symlink
    mkdir -p /usr/local/bin
    ln -s ${SYNOPKG_PKGDEST}/env/bin/borg /usr/local/bin/borg
    ln -s ${SYNOPKG_PKGDEST}/env/bin/borgmatic /usr/local/bin/borgmatic
}

service_postuninst ()
{
    rm -f /usr/local/bin/borg
    rm -f /usr/local/bin/borgmatic
}

