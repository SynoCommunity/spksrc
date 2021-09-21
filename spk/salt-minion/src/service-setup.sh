PYTHON_DIR="/var/packages/python38/target/bin"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}:${PATH}"
VIRTUALENV="${PYTHON_DIR}/python3 -m venv"
PYTHON="${PYTHON_DIR}/python3"
LANGUAGE="env LANG=en_US.UTF-8"
SALT_MINION="${SYNOPKG_PKGDEST}/env/bin/salt-minion"
PID_FILE="${SYNOPKG_PKGDEST}/env/var/run/salt-minion.pid"

SERVICE_COMMAND="${SALT_MINION} -c ${SYNOPKG_PKGDEST}/env/etc/salt -d"

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env

    # Install the wheels
    wheelhouse=${SYNOPKG_PKGDEST}/share/wheelhouse
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index --upgrade --force-reinstall -f ${wheelhouse} ${wheelhouse}/*.whl

    # Prepare salt-minion config in /var/packages/salt-minion/
    test -L ${SYNOPKG_PKGDEST}/env/etc || ln -s /var/packages/${SYNOPKG_PKGNAME}/etc ${SYNOPKG_PKGDEST}/env/etc
    test -d ${SYNOPKG_PKGDEST}/env/etc/salt/minion.d || install -m 755 -d ${SYNOPKG_PKGDEST}/env/etc/salt/minion.d
    test -f ${SYNOPKG_PKGDEST}/env/etc/salt/minion || install -m 644 ${SYNOPKG_PKGDEST}/share/minion ${SYNOPKG_PKGDEST}/env/etc/salt/minion
    test -f ${SYNOPKG_PKGDEST}/env/etc/salt/proxy || install -m 644 ${SYNOPKG_PKGDEST}/share/proxy ${SYNOPKG_PKGDEST}/env/etc/salt/proxy
    test -f ${SYNOPKG_PKGDEST}/env/etc/salt/minion.d/02_pidfile.conf || echo "pidfile: ${PID_FILE}" > ${SYNOPKG_PKGDEST}/env/etc/salt/minion.d/02_pidfile.conf
    test -f ${SYNOPKG_PKGDEST}/env/etc/salt/minion.d/01_rootdir.conf || echo "root_dir: ${SYNOPKG_PKGDEST}/env" > ${SYNOPKG_PKGDEST}/env/etc/salt/minion.d/01_rootdir.conf
    test -f ${SYNOPKG_PKGDEST}/env/etc/salt/minion.d/03_logging.conf || echo "log_file: udp://localhost:10514" > ${SYNOPKG_PKGDEST}/env/etc/salt/minion.d/03_logging.conf
    test -f ${SYNOPKG_PKGDEST}/env/etc/salt/minion.d/03_logging.conf || echo "log_level_logfile: info" >> ${SYNOPKG_PKGDEST}/env/etc/salt/minion.d/03_logging.conf

    # Populate salt master address and minion_id only if file don't already exist
    test -f ${SYNOPKG_PKGDEST}/env/etc/salt/minion.d/99-master-address.conf || echo "master: salt" > ${SYNOPKG_PKGDEST}/env/etc/salt/minion.d/99-master-address.conf
    test -f ${SYNOPKG_PKGDEST}/env/etc/salt/minion.d/98-minion-id.conf || echo -n "id: " > ${SYNOPKG_PKGDEST}/env/etc/salt/minion.d/98-minion-id.conf && hostname -s >> ${SYNOPKG_PKGDEST}/env/etc/salt/minion.d/98-minion-id.conf

    # DSM 6
    set_unix_permissions "${SYNOPKG_PKGDEST}"
    set_unix_permissions "${SYNOPKG_PKGDEST}/env/etc/"
}
