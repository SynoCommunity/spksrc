export SPEEDKETCHUP_ADDRESS=0.0.0.0
export SPEEDKETCHUP_PORT=8288
export SPEEDKETCHUP_FILE=${SYNOPKG_PKGVAR}/speedketchup-results.csv
export SPEEDKETCHUP_INTERVAL=10

# Load custom variables. Those may overwrite variables above
ENV_VARIABLES="${SYNOPKG_PKGVAR}/environment-variables"
if [ -r "${ENV_VARIABLES}" ]; then
    . "${ENV_VARIABLES}"
fi

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/speedketchup-service"
SVC_BACKGROUND=yes
SVC_WRITE_PID=yes
