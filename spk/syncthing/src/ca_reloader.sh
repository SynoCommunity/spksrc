#!/bin/sh

CERT_DIR=/usr/local/etc/certificate/syncthing/syncthing-webui
CONF_DIR=/usr/local/syncthing/var
SYNCTHING=/usr/local/syncthing/bin/syncthing

case $1 in
    syncthing-webui)
        # Forcefully overwrite certificate files by symlinks
        ln -sf $CERT_DIR/cert.pem $CONF_DIR/https-cert.pem
        ln -sf $CERT_DIR/privkey.pem $CONF_DIR/https-key.pem

        # Required: set $HOME environment variable
        HOME=$CONF_DIR
        export HOME

        $SYNCTHING cli --home=$CONF_DIR operations restart
        RESTART_STATUS=$?
        exit $RESTART_STATUS
        ;;
    *)
        echo "Usage: $0 syncthing-webui" >&2
        exit 1
        ;;
esac
