CFG_FILE="/usr/local/${SYNOPKG_PKGNAME}/etc/hassio.json"

service_postinst() {
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        DATA_DIR="${wizard_share_path}/${wizard_folder_name}"
        # Fix install directory
        mkdir -p "${DATA_DIR}"

        HOMEASSISTANT_DOCKER="homeassistant/qemux86-64-homeassistant"
        HASSIO_DOCKER="homeassistant/amd64-hassio-supervisor"

        # Read infos from web
        URL_VERSION="https://version.home-assistant.io/stable.json"
        HASSIO_VERSION=$(curl -s $URL_VERSION | jq -e -r '.supervisor')

        # Pull supervisor image
        /usr/local/bin/docker pull "${HASSIO_DOCKER}:${HASSIO_VERSION}" >/dev/null &&
        /usr/local/bin/docker tag "${HASSIO_DOCKER}:${HASSIO_VERSION}" "${HASSIO_DOCKER}:latest" >/dev/null

        if [ ! -f ${CFG_FILE} ]; then
            mkdir -p /usr/local/${SYNOPKG_PKGNAME}/etc 
            cp ${SYNOPKG_PKGDEST}/var/hassio.dist ${CFG_FILE}
            # Write config
            sed -i -e "s|@supervisor@|${HASSIO_DOCKER}|g" ${CFG_FILE}
            sed -i -e "s|@homeassistant@|${HOMEASSISTANT_DOCKER}|g" ${CFG_FILE}
            sed -i -e "s|@data_dir@|${DATA_DIR}|g" ${CFG_FILE}
        fi
    fi
}

service_preuninst() {
    if [ ${SYNOPKG_PKG_STATUS} == "UNINSTALL" ]; then
        HOMEASSISTANT="$(jq --raw-output '.homeassistant' ${CFG_FILE})"
        SUPERVISOR="$(jq --raw-output '.supervisor' ${CFG_FILE})"
        HASSIO_DATA="$(jq --raw-output '.data // "/usr/share/hassio"' ${CFG_FILE})"

        if [ `docker inspect --format='{{.Config.Image}}' homeassistant|grep -q homeassistant/qemux86-64` ]; then
            docker rm --force homeassistant && docker image rm ${HOMEASSISTANT}
        fi

        # Remove supervisor and extra containers.
        docker rm --force hassio_supervisor && docker image rm ${SUPERVISOR}
        for CONTAINER in "hassio_dns hassio_multicast hassio_cli hassio_audio hassio_observer"; do
            IMAGE = docker inspect --format='{{.Image}}' $CONTAINER
            docker rm --force $CONTAINER && docker image rm $IMAGE
        done

        docker network rm hassio

        if [ "${wizard_remove_addons}" == "true" ]; then
            # Remove addons
            ADDONS_FILE=$(jq -r '.data + "/addons.json"' ${CFG_FILE})

            docker rm --force $(jq -r '.user| keys| map("addon_"+.)| join(" ")' $ADDONS_FILE)
            docker rmi --force $(jq -r '[.user | keys[] as $k | .[$k].image] | join(" ")' $ADDONS_FILE)
        fi

        # Move config.json so hassio_supervisor will create a new homeassistant container.
        mv "${HASSIO_DATA}/config.json" "${HASSIO_DATA}/config-$(date '+%s').bak"
    fi
}

service_preupgrade() {
    # Move old config file in var into etc.
    if [ -f "${SYNOPKG_PKGDEST}/var/hassio.json" ]; then
        mv "${SYNOPKG_PKGDEST}/var/hassio.json" /tmp/hassio.json
    fi

    if [ -f ${CFG_FILE} ]; then
        cp ${CFG_FILE} /tmp/hassio.json
    fi
}

service_postupgrade() {
    if [ -f /tmp/hassio.json ]; then
        mkdir -p /usr/local/${SYNOPKG_PKGNAME}/etc 
        mv /tmp/hassio.json ${CFG_FILE}
    fi

    # Move config.json from data dir if there is no homeassistant container.
    HASSIO_DATA="$(jq --raw-output '.data // "/usr/share/hassio"' ${CFG_FILE})"
    docker ps -a | grep qemux86-64-homeassistant >/dev/null ||
        mv "${HASSIO_DATA}/config.json" "${HASSIO_DATA}/config-$(date '+%s').bak"
}

service_prestart ()
{
    # Replace generic service startup, fork process in background
    echo "Starting hass.io at ${SYNOPKG_PKGDEST}" >> ${LOG_FILE}
    COMMAND="bin/hassio.sh"

    cd ${SYNOPKG_PKGDEST};
    ${COMMAND} >> ${LOG_FILE} 2>&1 &
    echo "$!" > "${PID_FILE}"

    docker start homeassistant
}

service_poststop ()
{
    docker stop hassio_supervisor homeassistant
}
