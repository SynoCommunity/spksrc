#!/bin/sh

source /etc.defaults/VERSION
if [ ${majorversion} -ge 7 ]; then
    echo "ERROR: ${0} does not work on DSM 7+" >&2
    exit -1
fi

CERT_DIR=/usr/local/etc/certificate/syncthing/syncthing_webui
CONF_DIR=/var/packages/syncthing/var
SYNCTHING=/var/packages/syncthing/target/bin/syncthing

case $1 in
    syncthing_webui)
        # Forcefully overwrite certificate files by symlinks
        ln -sf ${CERT_DIR}/cert.pem ${CONF_DIR}/https-cert.pem
        ln -sf ${CERT_DIR}/privkey.pem ${CONF_DIR}/https-key.pem

        # Required: set $HOME environment variable
        HOME=${CONF_DIR}
        export HOME

        ${SYNCTHING} cli --config=${CONF_DIR} --data=${CONF_DIR} operations restart
        RESTART_STATUS=$?
        exit ${RESTART_STATUS}
        ;;
    *)
        echo "Usage: $0 syncthing_webui" >&2
        exit 1
        ;;
esac
