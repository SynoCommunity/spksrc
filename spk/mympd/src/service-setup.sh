
CONFIG_DIR=${SYNOPKG_PKGVAR}/config
CONFIG_DEFAULT_DIR=${SYNOPKG_PKGVAR}/config.default
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/mympd"
SVC_BACKGROUND=y
SVC_WRITE_PID=y


service_postinst ()
{
    if [ ! -d ${CONFIG_DIR} ]; then
        echo "Initialize configuration in ${CONFIG_DIR} from default config."
        mkdir -p ${CONFIG_DIR}
        $RSYNC --ignore-existing ${CONFIG_DEFAULT_DIR}/ ${CONFIG_DIR}
    fi
}
