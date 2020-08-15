PYTHON_DIR="/usr/local/python3"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${PATH}"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
LANGUAGE="env LANG=en_US.UTF-8"
SALT_MINION="${SYNOPKG_PKGDEST}/env/bin/salt-minion"
PID_FILE="${SYNOPKG_PKGDEST}/var/run/salt-minion.pid"

SERVICE_COMMAND="${SALT_MINION} -c ${SYNOPKG_PKGDEST}/etc/salt -d"

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG}

    # Install wheels
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG}

    # Install busybox stuff
    ${SYNOPKG_PKGDEST}/bin/busybox --install ${SYNOPKG_PKGDEST}/bin

    # Patch rsax931.py file to find libcrypto lib
    ${SYNOPKG_PKGDEST}/bin/patch ${SYNOPKG_PKGDEST}/env/lib/python3.7/site-packages/salt/utils/rsax931.py < ${SYNOPKG_PKGDEST}/share/rsax931.py.patch >> ${INST_LOG} 2>&1

}

