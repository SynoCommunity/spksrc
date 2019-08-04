#!/bin/sh

CONFIG_FILE="/usr/local/hassio/etc/hassio.json"

fix_usb_devices() {
    RULES_FILE="/lib/udev/rules.d/59-usb-hassio.rules"
    HASSIO_DATA="$(jq --raw-output '.data // "/usr/share/hassio"' ${CONFIG_FILE})"
    USB_FILE="${HASSIO_DATA}/usb_devices.txt"

    # Clear entris from file
    echo >${USB_FILE}

    for tty_path in $(find /sys/bus/usb/devices/usb*/ -name tty); do
        tty_iface_path=$(dirname $tty_path)
        serial_device_path=$(dirname $tty_iface_path)
        prefix=usb
        if [ -f "$serial_device_path/idVendor" ]; then
            bInterfaceNumber=$(cat $tty_iface_path/bInterfaceNumber)
        else
            bInterfaceNumber=$(cat $serial_device_path/bInterfaceNumber)
            # We need to go up 1 level to get information
            serial_device_path=$(dirname $serial_device_path)
            manufacturer=$(cat $serial_device_path/manufacturer)
        fi
        idVendor=$(cat $serial_device_path/idVendor)
        product=$(cat $serial_device_path/product)
        idProduct=$(cat $serial_device_path/idProduct)
        serial=$(cat $serial_device_path/serial)

        if [ ! -z "$manufacturer" ]; then
            symLink="serial/by-id/${prefix}-${manufacturer}_${product}_${serial}-if${bInterfaceNumber}-port0"
            unset manufacturer
        else
            symLink="serial/by-id/${prefix}-${idVendor}_${product}_${serial}-if${bInterfaceNumber}"
        fi

        line="SUBSYSTEM==\"tty\", ATTRS{idVendor}==\"${idVendor}\", ATTRS{idProduct}==\"${idProduct}\", SYMLINK+=\"${symLink}\""
        echo $line
        grep -s "ATTRS{idVendor}==\"${idVendor}\", ATTRS{idProduct}==\"${idProduct}\"" $RULES_FILE >/dev/null ||
            echo ${line} >>$RULES_FILE

        echo "/dev/${symLink}" >>$USB_FILE
    done

    udevadm control --reload && udevadm trigger
}

runSupervisor() {
    HOMEASSISTANT="$(jq --raw-output '.homeassistant' ${CONFIG_FILE})"
    HASSIO_DATA="$(jq --raw-output '.data // "/usr/share/hassio"' ${CONFIG_FILE})"

    APPARMOR="--security-opt apparmor=unconfined"

    /usr/local/bin/docker rm --force hassio_supervisor >/dev/null || true
    /usr/local/bin/docker run --name hassio_supervisor \
        --privileged \
        $APPARMOR \
        --security-opt seccomp=unconfined \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v /var/run/dbus:/var/run/dbus \
        -v ${HASSIO_DATA}:/data \
        -e SUPERVISOR_SHARE=${HASSIO_DATA} \
        -e SUPERVISOR_NAME=hassio_supervisor \
        -e HOMEASSISTANT_REPOSITORY=${HOMEASSISTANT} \
        ${SUPERVISOR}
}

start_hassio() {
    fix_usb_devices
    SUPERVISOR="$(jq --raw-output '.supervisor' ${CONFIG_FILE})"

    HASSIO_IMAGE_ID=$(/usr/local/bin/docker inspect --format='{{.Id}}' ${SUPERVISOR})
    HASSIO_CONTAINER_ID=$(/usr/local/bin/docker inspect --format='{{.Image}}' hassio_supervisor || echo "--")

    # Fix routing
    route -vn | grep 172.30.32.0 >/dev/null ||
        route add -net 172.30.32.0/23 gw 172.30.32.1

    # Run supervisor
    ([ "${HASSIO_IMAGE_ID}" = "${HASSIO_CONTAINER_ID}" ] && /usr/local/bin/docker start --attach hassio_supervisor) || runSupervisor
}

while true; do
    start_hassio
    sleep 1
done
