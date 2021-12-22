# Define python310 binary path
PYTHON_DIR="/var/packages/python310/target/bin"
# Add local bin, virtualenv along with python310 to the default PATH
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
LANGUAGE="env LANG=en_US.UTF-8"
PID_FILE="${SYNOPKG_PKGVAR}/run/salt-minion.pid"

SERVICE_COMMAND="salt-minion -c ${SYNOPKG_PKGDEST}/etc -d"

service_postinst ()
{
    # Create a Python virtualenv
    install_python_virtualenv

    # Install wheels
    install_python_wheels

    # Patch rsax931.py file to find libcrypto lib
    # (Rely on patch util bundled with python3's busybox)
    #${PYTHON_DIR}/bin/patch ${SYNOPKG_PKGDEST}/env/lib/python3.10/site-packages/salt/utils/rsax931.py < ${SYNOPKG_PKGDEST}/share/rsax931.py.patch

    # Prepare salt-minion config in /var/packages/salt-minion/target/etc
    test -d ${SYNOPKG_PKGDEST}/etc/minion.d || install -m 755 -d ${SYNOPKG_PKGDEST}/etc/minion.d
    test -f ${SYNOPKG_PKGDEST}/etc/minion || install -m 644 ${SYNOPKG_PKGDEST}/share/minion ${SYNOPKG_PKGDEST}/etc/minion
    test -f ${SYNOPKG_PKGDEST}/etc/proxy || install -m 644 ${SYNOPKG_PKGDEST}/share/proxy ${SYNOPKG_PKGDEST}/etc/proxy
    test -f ${SYNOPKG_PKGDEST}/etc/minion.d/01_pidfile.conf || echo "pidfile: ${PID_FILE}" > ${SYNOPKG_PKGDEST}/etc/minion.d/01_pidfile.conf
    test -f ${SYNOPKG_PKGDEST}/etc/minion.d/02_cachedir.conf || echo "cachedir: ${SYNOPKG_PKGVAR}/cache" > ${SYNOPKG_PKGDEST}/etc/minion.d/02_cachedir.conf
    test -f ${SYNOPKG_PKGDEST}/etc/minion.d/03_logging.conf || echo "log_file: ${SYNOPKG_PKGVAR}/${SYNOPKG_PKGNAME}.log" > ${SYNOPKG_PKGDEST}/etc/minion.d/03_logging.conf
    test -f ${SYNOPKG_PKGDEST}/etc/minion.d/04_loglevel.conf || echo "log_level_logfile: debug" > ${SYNOPKG_PKGDEST}/etc/minion.d/04_loglevel.conf
    test -f ${SYNOPKG_PKGDEST}/etc/minion.d/05_pkidir.conf || echo "pki_dir: ${SYNOPKG_PKGVAR}/pki/minion" > ${SYNOPKG_PKGDEST}/etc/minion.d/05_pkidir.conf

    # Populate salt master address and minion_id only if file don't already exist
    test -f ${SYNOPKG_PKGDEST}/etc/minion.d/99-master-address.conf || echo "master: localhost" > ${SYNOPKG_PKGDEST}/etc/minion.d/99-master-address.conf
    test -f ${SYNOPKG_PKGDEST}/etc/minion.d/98-minion-id.conf || echo -n "id: $(hostname -s)" > ${SYNOPKG_PKGDEST}/etc/minion.d/98-minion-id.conf
}
