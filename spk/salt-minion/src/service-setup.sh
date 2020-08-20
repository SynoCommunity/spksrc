PYTHON_DIR="/usr/local/python3"
SALT_PKG_DIR="/usr/local/salt-minion"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${PATH}"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
PYTHON="${SALT_PKG_DIR=}/env/bin/python"
LANGUAGE="env LANG=en_US.UTF-8"
SALT_MINION="${SALT_PKG_DIR}/env/bin/salt-minion"
SALT_CONF_DIR="/var/salt/etc"
PID_FILE="${SALT_PKG_DIR}/var/salt-minion.pid"

SERVICE_COMMAND="${SALT_MINION} -c /var/salt/etc -d"

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG}

    # Install wheels
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG}

    # Patch rsax931.py file to find libcrypto lib
    # (Rely on patch util bundled with python3's busybox)
    ${PYTHON_DIR}/bin/patch ${SYNOPKG_PKGDEST}/env/lib/python3.7/site-packages/salt/utils/rsax931.py < ${SYNOPKG_PKGDEST}/share/rsax931.py.patch >> ${INST_LOG} 2>&1

    # Prepare salt-minion config in /var/salt
    install -m 755 -d ${SALT_CONF_DIR}
    install -m 755 -d ${SALT_CONF_DIR}/minion.d
    install -m 644 ${SYNOPKG_PKGDEST}/share/minion.conf ${SALT_CONF_DIR}/
    echo "pki_dir: ${SALT_CONF_DIR}/pki/minion" > ${SALT_CONF_DIR}/minion.d/01-pki-dir.conf
    echo "pidfile: ${SYNOPKG_PKGDEST}/var/salt-minion.pid" > ${SALT_CONF_DIR}/minion.d/02_pidfile.conf
    # Populate salt master address and minion_id only if file don't already exist
    test -f ${SALT_CONF_DIR}/minion.d/99-master-address.conf || echo "master: salt" > ${SALT_CONF_DIR}/minion.d/99-master-address.conf
    test -f ${SALT_CONF_DIR}/minion.d/98-minion-id.conf || echo "id: myname" > ${SALT_CONF_DIR}/minion.d/98-minion-id.conf
}

