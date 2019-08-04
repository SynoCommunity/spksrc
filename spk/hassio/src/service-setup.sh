CFG_FILE="/usr/local/${SYNOPKG_PKGNAME}/etc/hassio.json"

service_preinst() {
    exit 0
}

service_postinst() {
    DATA_DIR="${share_path}/${folder_name}"
    # Fix install directory
    mkdir -p "${DATA_DIR}"

    URL_VERSION="https://s3.amazonaws.com/hassio-version/stable.json"

    HOMEASSISTANT_DOCKER="homeassistant/qemux86-64-homeassistant"
    HASSIO_DOCKER="homeassistant/amd64-hassio-supervisor"

    # Read infos from web
    HASSIO_VERSION=$(curl -s $URL_VERSION | jq -e -r '.supervisor')

    # Pull supervisor image
    /usr/local/bin/docker pull "$HASSIO_DOCKER:$HASSIO_VERSION" >/dev/null &&
        /usr/local/bin/docker tag "$HASSIO_DOCKER:$HASSIO_VERSION" "$HASSIO_DOCKER:latest" >/dev/null

   if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        cp ${SYNOPKG_PKGDEST}/var/hassio.dist ${CFG_FILE}
        # Write config
        sed -i -e "s|@supervisor@|${HASSIO_DOCKER}|g" ${CFG_FILE}
        sed -i -e "s|@homeassistant@|${HOMEASSISTANT_DOCKER}|g" ${CFG_FILE}
        sed -i -e "s|@data_dir@|${DATA_DIR}|g" ${CFG_FILE}
    fi

    # Install busybox stuff
    ln -s busybox ${SYNOPKG_PKGDEST}/bin/start-stop-daemon

}

service_preuninst() {
    HOMEASSISTANT="$(jq --raw-output '.homeassistant' ${CFG_FILE})"
    SUPERVISOR="$(jq --raw-output '.supervisor' ${CFG_FILE})"
    HASSIO_DATA="$(jq --raw-output '.data // "/usr/share/hassio"' ${CFG_FILE})"

    docker rm --force homeassistant hassio_supervisor
    docker image rm ${HOMEASSISTANT} ${SUPERVISOR}
    docker network rm hassio

    # Move config.json so hassio_supervisor will create a new homeassistant container.
    mv "$HASSIO_DATA/config.json" "$HASSIO_DATA/config-$(date '+%s').bak"
}

service_postupgrade() {
    # Move old config file in var into etc.
    if [ -f "${SYNOPKG_PKGDEST}/var/hassio.json" ]; then
        mv "${SYNOPKG_PKGDEST}/var/hassio.json" $CFG_FILE
    fi

    # Move config.json from data dir if there is no homeassistant container.
    HASSIO_DATA="$(jq --raw-output '.data // "/usr/share/hassio"' ${CFG_FILE})"
    docker ps -a|grep qemux86-64-homeassistant || \
        mv "$HASSIO_DATA/config.json" "$HASSIO_DATA/config-$(date '+%s').bak"
}

    # Fix install directory