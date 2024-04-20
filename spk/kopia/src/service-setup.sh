export XDG_CACHE_HOME=${SYNOPKG_PKGVAR}/cache
ENV="USER= KOPIA_LOG_DIR=${SYNOPKG_PKGVAR} KOPIA_CACHE_DIR=${SYNOPKG_PKGVAR} KOPIA_CONFIG_PATH=${SYNOPKG_PKGVAR}/config"
TLS_CONFIG="--tls-generate-cert --tls-cert-file ${SYNOPKG_PKGVAR}/default.crt --tls-key-file ${SYNOPKG_PKGVAR}/default.key"
KOPIA=${SYNOPKG_PKGDEST}/bin/kopia
SERVICE_COMMAND="${KOPIA} server start --ui ${TLS_CONFIG} --address=0.0.0.0:${SERVICE_PORT} --grpc --control-api --enable-actions"
SVC_BACKGROUND=yes
SVC_WRITE_PID=yes

service_prestart () {
    call_func "load_variables_from_file"
    SERVICE_COMMAND+=" --server-username=${wizard_username} --server-password=${wizard_password}"
}
