# Define python311 binary path
PYTHON_DIR="/var/packages/python311/target/bin"
# Add local bin, virtualenv along with python311 to the default PATH
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"
LANGUAGE="env LANG=en_US.UTF-8"
SYNOPKG_PKGETC=/var/packages/${SYNOPKG_PKGNAME}/etc

SERVICE_COMMAND="salt-master --pid-file ${PID_FILE} -c ${SYNOPKG_PKGETC} -d"

service_postinst ()
{
    # Create a Python virtualenv
    install_python_virtualenv

    # Install wheels
    install_python_wheels

    # patch rsax931.py file to find libcrypto lib provided by python311
    # (rely on patch==1.16 included in requirements-pure.txt)
    python ${SYNOPKG_PKGDEST}/env/lib/python3.11/site-packages/patch.py \
           --directory=${SYNOPKG_PKGDEST}/env/lib/python3.11/site-packages/salt/utils \
           ${SYNOPKG_PKGDEST}/share/rsax931.py.patch

    # Prepare salt-master config in /var/packages/salt-master/target/etc
    test -d ${SYNOPKG_PKGETC}/master.d || install -m 755 -d ${SYNOPKG_PKGETC}/master.d
    test -f ${SYNOPKG_PKGETC}/master || install -m 644 ${SYNOPKG_PKGDEST}/share/master ${SYNOPKG_PKGETC}/master
    test -f ${SYNOPKG_PKGETC}/master.d/01_pidfile.conf || echo "pidfile: run" > ${SYNOPKG_PKGETC}/master.d/01_pidfile.conf
    test -f ${SYNOPKG_PKGETC}/master.d/02_sockdir.conf || echo "sock_dir: run/master" > ${SYNOPKG_PKGETC}/master.d/02_sockdir.conf
    test -f ${SYNOPKG_PKGETC}/master.d/03_cachedir.conf || echo "cachedir: cache" > ${SYNOPKG_PKGETC}/master.d/03_cachedir.conf
    test -f ${SYNOPKG_PKGETC}/master.d/04_logging.conf || echo "log_file: ${SYNOPKG_PKGNAME}.log" > ${SYNOPKG_PKGETC}/master.d/04_logging.conf
    test -f ${SYNOPKG_PKGETC}/master.d/05_loglevel.conf || echo "log_level_logfile: info" >> ${SYNOPKG_PKGETC}/master.d/05_loglevel.conf
    test -f ${SYNOPKG_PKGETC}/master.d/06_pkidir.conf || echo "pki_dir: pki/master" > ${SYNOPKG_PKGETC}/master.d/06_pkidir.conf
    test -f ${SYNOPKG_PKGETC}/master.d/07_rootdir.conf || echo "root_dir: ${SYNOPKG_PKGVAR}" > ${SYNOPKG_PKGETC}/master.d/07_rootdir.conf
}
