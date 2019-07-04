CFG_FILE="${SYNOPKG_PKGDEST}/var/hassio.json"

service_preinst ()
{
    exit 0
}

service_postinst ()
{
    mkdir -p "${data_dir}"

    URL_VERSION="https://s3.amazonaws.com/hassio-version/stable.json"

    HOMEASSISTANT_DOCKER="homeassistant/qemux86-64-homeassistant"
    HASSIO_DOCKER="homeassistant/amd64-hassio-supervisor"

    # Read infos from web
    HASSIO_VERSION=$(curl -s $URL_VERSION | jq -e -r '.supervisor')

    # Pull supervisor image
    /usr/local/bin/docker pull "$HASSIO_DOCKER:$HASSIO_VERSION" > /dev/null
    /usr/local/bin/docker tag "$HASSIO_DOCKER:$HASSIO_VERSION" "$HASSIO_DOCKER:latest" > /dev/null

    # Write config
    sed -i -e "s|@supervisor@|${HASSIO_DOCKER}|g" ${CFG_FILE}
    sed -i -e "s|@homeassistant@|${HOMEASSISTANT_DOCKER}|g" ${CFG_FILE}
    sed -i -e "s|@data_dir@|${data_dir}|g" ${CFG_FILE}

    # Install busybox stuff
    ln -s busybox ${SYNOPKG_PKGDEST}/bin/start-stop-daemon
}

service_preuninst ()
{
    HOMEASSISTANT="$(jq --raw-output '.homeassistant' ${CONFIG_FILE})"
    SUPERVISOR="$(jq --raw-output '.supervisor' ${CONFIG_FILE})"

    docker rm --force homeassistant hassio_supervisor
    docker image rm ${HOMEASSISTANT} ${SUPERVISOR}
}
