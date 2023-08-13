export KOPIA_LOG_DIR=${SYNOPKG_PKGVAR}
export KOPIA_CACHE_DIR=${SYNOPKG_PKGVAR}

#PASSWORD=${wizard_password}
PASSWORD=kopia
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/kopia server start --ui --insecure --address=http://0.0.0.0:${SERVICE_PORT} --server-password=${PASSWORD} --legacy-api --grpc --control-api"
SVC_BACKGROUND=yes
SVC_WRITE_PID=yes
