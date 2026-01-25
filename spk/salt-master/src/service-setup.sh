# Define python312 binary path
PYTHON_DIR="/var/packages/python312/target/bin"
# Add local bin, virtualenv along with python312 to the default PATH
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"
export LANG=en_US.UTF-8
SYNOPKG_PKGETC=/var/packages/${SYNOPKG_PKGNAME}/etc

# Service configuration - let framework handle background execution and PID tracking
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# Multi-command service: salt-master first, then salt-api
# Framework iterates over newline-separated commands in SERVICE_COMMAND
SALT_MASTER_CMD="salt-master -c ${SYNOPKG_PKGETC} -d"
SALT_API_CMD="salt-api -c ${SYNOPKG_PKGETC} -d"
SERVICE_COMMAND=$(printf "%s\n%s" "${SALT_MASTER_CMD}" "${SALT_API_CMD}")

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

    # Prepare salt-master config in /var/packages/salt-master/etc
    test -d ${SYNOPKG_PKGETC}/master.d || install -m 755 -d ${SYNOPKG_PKGETC}/master.d
    test -f ${SYNOPKG_PKGETC}/master || install -m 644 ${SYNOPKG_PKGDEST}/share/master ${SYNOPKG_PKGETC}/master
    test -f ${SYNOPKG_PKGETC}/master.d/01_pidfile.conf || echo "pidfile: run" > ${SYNOPKG_PKGETC}/master.d/01_pidfile.conf
    test -f ${SYNOPKG_PKGETC}/master.d/02_sockdir.conf || echo "sock_dir: run/master" > ${SYNOPKG_PKGETC}/master.d/02_sockdir.conf
    test -f ${SYNOPKG_PKGETC}/master.d/03_cachedir.conf || echo "cachedir: cache" > ${SYNOPKG_PKGETC}/master.d/03_cachedir.conf
    test -f ${SYNOPKG_PKGETC}/master.d/04_logging.conf || echo "log_file: ${SYNOPKG_PKGNAME}.log" > ${SYNOPKG_PKGETC}/master.d/04_logging.conf
    test -f ${SYNOPKG_PKGETC}/master.d/05_loglevel.conf || echo "log_level_logfile: info" >> ${SYNOPKG_PKGETC}/master.d/05_loglevel.conf
    test -f ${SYNOPKG_PKGETC}/master.d/06_pkidir.conf || echo "pki_dir: pki/master" > ${SYNOPKG_PKGETC}/master.d/06_pkidir.conf
    test -f ${SYNOPKG_PKGETC}/master.d/07_rootdir.conf || echo "root_dir: ${SYNOPKG_PKGVAR}" > ${SYNOPKG_PKGETC}/master.d/07_rootdir.conf
    test -f ${SYNOPKG_PKGETC}/master.d/08_extmodsdir.conf || echo "extension_modules: extensions" > ${SYNOPKG_PKGETC}/master.d/08_extmodsdir.conf
}
