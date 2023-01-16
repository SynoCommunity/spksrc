export GOTIFY_SERVER_PORT=7152
export GOTIFY_DATABASE_CONNECTION=${SYNOPKG_PKGVAR}/gotify.db
export GOTIFY_SERVER_SSL_LETSENCRYPT_CACHE=${SYNOPKG_PKGVAR}/certs
export GOTIFY_UPLOADEDIMAGESDIR=${SYNOPKG_PKGVAR}/images
export GOTIFY_PLUGINSDIR=${SYNOPKG_PKGVAR}/plugins

# Load custom variables. Those may overwrite variables above
ENV_VARIABLES="${SYNOPKG_PKGVAR}/environment-variables"
if [ -r "${ENV_VARIABLES}" ]; then
    . "${ENV_VARIABLES}"
fi

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/gotify-server"
SVC_BACKGROUND=yes
SVC_WRITE_PID=yes
