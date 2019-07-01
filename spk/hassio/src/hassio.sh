#!/bin/sh

CONFIG_FILE="/var/packages/hassio/target/var/hassio.json"

runSupervisor() {
    HOMEASSISTANT="$(jq --raw-output '.homeassistant' ${CONFIG_FILE})"
    HASSIO_DATA="$(jq --raw-output '.data // "/usr/share/hassio"' ${CONFIG_FILE})"

    APPARMOR="--security-opt apparmor=unconfined"

    /usr/local/bin/docker rm --force hassio_supervisor > /dev/null || true
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

start_hassio () {
    SUPERVISOR="$(jq --raw-output '.supervisor' ${CONFIG_FILE})"

    HASSIO_IMAGE_ID=$(/usr/local/bin/docker inspect --format='{{.Id}}' ${SUPERVISOR})
    HASSIO_CONTAINER_ID=$(/usr/local/bin/docker inspect --format='{{.Image}}' hassio_supervisor || echo "--")

    # Fix routing
    route -vn |grep 172.30.32.0 >/dev/null || \
        route add -net 172.30.32.0/23 gw 172.30.32.1

    # Run supervisor
    ([ "${HASSIO_IMAGE_ID}" = "${HASSIO_CONTAINER_ID}" ] && /usr/local/bin/docker start --attach hassio_supervisor) || runSupervisor 
}

while true; do
    start_hassio
    sleep 1
done
