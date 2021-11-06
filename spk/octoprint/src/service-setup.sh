
PYTHON_DIR="/var/packages/python38/target/bin"
VIRTUALENV="${PYTHON_DIR}/python3 -m venv"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"

PYTHON=${SYNOPKG_PKGDEST}/env/bin/python3
OCTOPRINT=${SYNOPKG_PKGDEST}/share/OctoPrint/run
SERVICE_COMMAND="${PYTHON} ${OCTOPRINT} daemon start -b ${SYNOPKG_PKGVAR}/.octoprint -c ${SYNOPKG_PKGVAR}/.octoprint/config.yaml --pid ${PID_FILE}"

service_postinst ()
{
    # Create a Python3 virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env

    # Install the wheels
    wheelhouse=${SYNOPKG_PKGDEST}/share/wheelhouse
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-input --no-index ${wheelhouse}/*.whl

    # Install OctoPrint
    cd ${SYNOPKG_PKGDEST}/share/OctoPrint && ${SYNOPKG_PKGDEST}/env/bin/python3 setup.py install
}


service_prestart()
{
    insmod /lib/modules/usbserial.ko
    insmod /lib/modules/ftdi_sio.ko
    insmod /lib/modules/cdc-acm.ko
    
    # Create device
    test -e /dev/ttyACM0 || mknod /dev/ttyACM0 c 166 0
    chmod 777 /dev/ttyACM0
}

service_poststop ()
{
    rmmod /lib/modules/usbserial.ko
    rmmod /lib/modules/ftdi_sio.ko
    rmmod /lib/modules/cdc-acm.ko
}
