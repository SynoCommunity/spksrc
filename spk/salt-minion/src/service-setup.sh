# Define python312 binary path
PYTHON_DIR="/var/packages/python312/target/bin"
# Add local bin, virtualenv along with python312 to the default PATH
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"
LANGUAGE="env LANG=en_US.UTF-8"
SYNOPKG_PKGETC=/var/packages/${SYNOPKG_PKGNAME}/etc

SERVICE_COMMAND="salt-minion --pid-file ${PID_FILE} -c ${SYNOPKG_PKGETC} -d"

service_postinst ()
{
    # Create a Python virtualenv
    install_python_virtualenv

    # Install wheels
    install_python_wheels

    # patch rsax931.py file to find libcrypto lib provided by python312
    # (rely on patch-ng==1.18.1 included in requirements-pure.txt)
    python ${SYNOPKG_PKGDEST}/env/lib/python3.12/site-packages/patch_ng.py \
           --directory=${SYNOPKG_PKGDEST}/env/lib/python3.12/site-packages/salt/utils \
           ${SYNOPKG_PKGDEST}/share/rsax931.py.patch

    # Prepare salt-minion config in /var/packages/salt-minion/etc
    test -d ${SYNOPKG_PKGETC}/minion.d || install -m 755 -d ${SYNOPKG_PKGETC}/minion.d
    test -f ${SYNOPKG_PKGETC}/minion || install -m 644 ${SYNOPKG_PKGDEST}/share/minion ${SYNOPKG_PKGETC}/minion
    test -f ${SYNOPKG_PKGETC}/proxy || install -m 644 ${SYNOPKG_PKGDEST}/share/proxy ${SYNOPKG_PKGETC}/proxy
    test -f ${SYNOPKG_PKGETC}/minion.d/01_pidfile.conf || echo "pidfile: run" > ${SYNOPKG_PKGETC}/minion.d/01_pidfile.conf
    test -f ${SYNOPKG_PKGETC}/minion.d/02_sockdir.conf || echo "sock_dir: run/minion" > ${SYNOPKG_PKGETC}/minion.d/02_sockdir.conf
    test -f ${SYNOPKG_PKGETC}/minion.d/03_cachedir.conf || echo "cachedir: cache" > ${SYNOPKG_PKGETC}/minion.d/03_cachedir.conf
    test -f ${SYNOPKG_PKGETC}/minion.d/04_logging.conf || echo "log_file: ${SYNOPKG_PKGNAME}.log" > ${SYNOPKG_PKGETC}/minion.d/04_logging.conf
    test -f ${SYNOPKG_PKGETC}/minion.d/05_loglevel.conf || echo "log_level_logfile: info" > ${SYNOPKG_PKGETC}/minion.d/05_loglevel.conf
    test -f ${SYNOPKG_PKGETC}/minion.d/06_pkidir.conf || echo "pki_dir: pki/minion" > ${SYNOPKG_PKGETC}/minion.d/06_pkidir.conf
    test -f ${SYNOPKG_PKGETC}/minion.d/07_rootdir.conf || echo "root_dir: ${SYNOPKG_PKGVAR}" > ${SYNOPKG_PKGETC}/minion.d/07_rootdir.conf

    # Populate salt master address and minion_id only if file don't already exist
    test -f ${SYNOPKG_PKGETC}/minion.d/99-master-address.conf || echo "master: localhost" > ${SYNOPKG_PKGETC}/minion.d/99-master-address.conf
    test -f ${SYNOPKG_PKGETC}/minion.d/98-minion-id.conf || echo -n "id: $(hostname -s)" > ${SYNOPKG_PKGETC}/minion.d/98-minion-id.conf
}
