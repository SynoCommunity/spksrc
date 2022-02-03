#!/bin/sh

CERT_DIR=/usr/local/etc/certificate/syncthing/syncthing_webui
CONF_DIR=/var/packages/syncthing/var
if [ ! -d "$CONF_DIR" ]; then
   CONF_DIR=/var/packages/syncthing/target/var
fi
SYNCTHING=/var/packages/syncthing/target/bin/syncthing

case $1 in
    syncthing_webui)
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
