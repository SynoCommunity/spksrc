PYTHON_DIR="/var/packages/python310/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"
PYTHON=${SYNOPKG_PKGDEST}/env/bin/python3
OCTOPRINT=${SYNOPKG_PKGDEST}/env/bin/octoprint
SERVICE_COMMAND="${PYTHON} ${OCTOPRINT} daemon start -b ${SYNOPKG_PKGVAR}/.octoprint -c ${SYNOPKG_PKGVAR}/.octoprint/config.yaml --pid ${PID_FILE}"

service_postinst ()
{
    # Create a Python3 virtualenv
    install_python_virtualenv

    # Install the wheels
    install_python_wheels
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
