export XDG_CACHE_HOME=${SYNOPKG_PKGVAR}/cache
export KOPIA_LOG_DIR=${SYNOPKG_PKGVAR}
export KOPIA_CACHE_DIR=${SYNOPKG_PKGVAR}
export KOPIA_CONFIG_PATH=${SYNOPKG_PKGVAR}/config/config.json
TLS_CONFIG="--tls-cert-file ${SYNOPKG_PKGVAR}/default.crt --tls-key-file ${SYNOPKG_PKGVAR}/default.key"
KOPIA=${SYNOPKG_PKGDEST}/bin/kopia
SERVICE_COMMAND="${KOPIA} server start --ui ${TLS_CONFIG} --address=0.0.0.0:${SERVICE_PORT} --grpc --control-api --enable-actions"
SVC_BACKGROUND=yes
SVC_WRITE_PID=yes

service_prestart () {
    wizard_password=$(cat "${SYNOPKG_PKGVAR}/pwd")
    wizard_username=$(cat "${SYNOPKG_PKGVAR}/usr")

    if [ ! -f "${SYNOPKG_PKGVAR}/default.crt" ];then
        SERVICE_COMMAND+=" --tls-generate-cert"
    fi
    SERVICE_COMMAND+=" --server-username=${wizard_username} --server-password=${wizard_password}"
}

service_postinst () {
    if [ ! -f "${SYNOPKG_PKGVAR}/pwd" ]; then
        echo "${wizard_password}" > "${SYNOPKG_PKGVAR}/pwd"
        echo "${wizard_username}" > "${SYNOPKG_PKGVAR}/usr"
    fi
}