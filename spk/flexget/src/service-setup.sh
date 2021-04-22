PYTHON_DIR="/var/packages/python3/target/bin"
VIRTUALENV="${PYTHON_DIR}/python3 -m venv"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"

CONFIG_FILE="${SYNOPKG_PKGVAR}/config.yml"

# flexget always writes the logfile flexget.log in the folder of the config file.
# this is the same file as defined by the variable LOG_FILE.
# if the parameter --logfile is not used or specifies the same logfile, then
# all log file entries are doubled (seems to be an old bug in flexget daemon mode).
# with "--logfile ${SYNOPKG_PKGVAR}/daemon.log", logs are written once to both files (flexget.log and daemon.log).
# we could use "--logfile /dev/null" to avoid double log entries, but with this we might loose 
# logs that are only written to the file specified with --logfile.
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/env/bin/flexget -c ${CONFIG_FILE} --logfile ${SYNOPKG_PKGVAR}/daemon.log daemon start"
SVC_BACKGROUND=y
SVC_WRITE_PID=y
SVC_CWD="${SYNOPKG_PKGVAR}/"
HOME="${SYNOPKG_PKGVAR}/"

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env

    # Install the wheels
    wheelhouse=${SYNOPKG_PKGDEST}/share/wheelhouse
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index --force-reinstall --find-links ${wheelhouse} ${wheelhouse}/*.whl

    # Copy "config.yml" file to the "var/" folder
    mkdir -p ${SYNOPKG_PKGVAR}
    cp -f ${SYNOPKG_PKGDEST}/share/config.yml ${SYNOPKG_PKGVAR}/
}

