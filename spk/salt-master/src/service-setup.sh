# Define python312 binary path
PYTHON_DIR="/var/packages/python312/target/bin"
# Add local bin, virtualenv along with python312 to the default PATH
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"
LANGUAGE="env LANG=en_US.UTF-8"
SYNOPKG_PKGETC=/var/packages/${SYNOPKG_PKGNAME}/etc

service_prestart ()
{
    # Define variables and commands
    LOG_FILE_MASTER="${SYNOPKG_PKGVAR}/salt-master.log"
    LOG_FILE_API="${SYNOPKG_PKGVAR}/salt-api.log"
    PID_FILE_MASTER="${SYNOPKG_PKGVAR}/salt-master-runtime.pid"
    PID_FILE_API="${SYNOPKG_PKGVAR}/salt-api-runtime.pid"
    COMMAND_MASTER="salt-master --pid-file ${PID_FILE_MASTER} -c ${SYNOPKG_PKGETC} --log-file=${LOG_FILE_MASTER} -d"
    COMMAND_API="salt-api --pid-file ${PID_FILE_API} -c ${SYNOPKG_PKGETC} --log-file=${LOG_FILE_API} -d"
    # Execute salt-master command
    $COMMAND_MASTER
    # Wait until salt-master is populated
    i=0
    while [ $i -lt 10 ]; do
        [ -s "${PID_FILE_MASTER}" ] && break
        sleep 1
        i=$((i + 1))
    done
    # Execute salt-api command
    $COMMAND_API
    # Wait until salt-api is populated
    i=0
    while [ $i -lt 10 ]; do
        [ -s "${PID_FILE_API}" ] && break
        sleep 1
        i=$((i + 1))
    done
    # Combine PID files
    : > "${PID_FILE}"
    [ -s "${PID_FILE_API}" ] && echo "$(cat "${PID_FILE_API}")" >> "${PID_FILE}"
    [ -s "${PID_FILE_MASTER}" ] && echo "$(cat "${PID_FILE_MASTER}")" >> "${PID_FILE}"
}

service_poststop ()
{
    # Define variables
    PID_FILE_MASTER="${SYNOPKG_PKGVAR}/salt-master-runtime.pid"
    PID_FILE_API="${SYNOPKG_PKGVAR}/salt-api-runtime.pid"
    # Remove any runtime PID files
    [ -f "${PID_FILE_API}" ] && rm -f "${PID_FILE_API}"
    [ -f "${PID_FILE_MASTER}" ] && rm -f "${PID_FILE_MASTER}"
}

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
