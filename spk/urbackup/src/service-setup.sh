# Setup environment
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"

service_postinst ()
{
    mkdir -p "${SHARE_PATH}"
    chown ${PRIV_PREFIX}${USER}: "${SHARE_PATH}"
    chmod 770 "${SHARE_PATH}"
}

service_prestart ()
{
    CONFIG_DIR="${SYNOPKG_PKGDEST}/var"
#    URBACKUP_OPTIONS="run -d -v error -u sc-urbackup"

#    SERVICE_OPTIONS=$URBACKUP_OPTIONS

    # Required: start-stop-daemon do not set environment variables
    HOME=${SYNOPKG_PKGDEST}/var
    export HOME
}
