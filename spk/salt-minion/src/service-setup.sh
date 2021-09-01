PYTHON_DIR="/bin"
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
VIRTUALENV="${PYTHON_DIR}/python3 -m venv"
PYTHON="/bin/python3"
LANGUAGE="env LANG=en_US.UTF-8"
SALT_MINION="${SYNOPKG_PKGDEST}/bin/salt-minion"
PID_FILE="${SYNOPKG_PKGDEST}/var/run/salt-minion.pid"

SERVICE_COMMAND="${SALT_MINION} -c ${SYNOPKG_PKGDEST}/etc/salt -d"

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}

    # Install the wheels
    wheelhouse=${SYNOPKG_PKGDEST}/share/wheelhouse
    ${SYNOPKG_PKGDEST}/bin/pip install --no-deps --no-index -U --force-reinstall -f ${wheelhouse} ${wheelhouse}/*.whl

    # Patch rsax931.py file to find libcrypto lib
    # (Rely on patch util bundled with python3's busybox)
    ${SYNOPKG_PKGDEST}/bin/patch ${SYNOPKG_PKGDEST}/lib/python*/site-packages/salt/utils/rsax931.py -i ${SYNOPKG_PKGDEST}/share/rsax931.py.patch

    # Prepare salt-minion config in /var/packages/salt-minion/
    install -m 755 -d ${SYNOPKG_PKGDEST}/etc/salt/minion.d
    install -m 644 ${SYNOPKG_PKGDEST}/share/minion.conf ${SYNOPKG_PKGDEST}/etc/salt/minion
    echo "pidfile: ${PID_FILE}" > ${SYNOPKG_PKGDEST}/etc/salt/minion.d/02_pidfile.conf
    echo "root_dir: ${SYNOPKG_PKGDEST}" > ${SYNOPKG_PKGDEST}/etc/salt/minion.d/01_rootdir.conf
    # Populate salt master address and minion_id only if file don't already exist
    test -f ${SYNOPKG_PKGDEST}/etc/salt/minion.d/99-master-address.conf || echo "master: salt" > ${SYNOPKG_PKGDEST}/etc/salt/minion.d/99-master-address.conf
    test -f ${SYNOPKG_PKGDEST}/etc/salt/minion.d/98-minion-id.conf || echo "id: myname" > ${SYNOPKG_PKGDEST}/etc/salt/minion.d/98-minion-id.conf
}

