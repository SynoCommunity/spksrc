INFLUXD_CONFIG_PATH=$(SYNOPKG_PKGVAR)/config.yml
INFLUXD=${SYNOPKG_PKGDEST}/bin/influxd

export INFLUXD_CONFIG_PATH=${INFLUXD_CONFIG_PATH}

SERVICE_COMMAND="${INFLUXD}"
SVC_BACKGROUND=yes
SVC_WRITE_PID=yes
SVC_CWD="${SYNOPKG_PKGVAR}"

service_preinst ()
{
    cat << EOF > "${INFLUXD_CONFIG_PATH}"
    http-bind-address: ":${SERVICE_PORT}"
    reporting-disabled: true
    bolt-path: "${SYNOPKG_PKGVAR}/.influxdbv2/influxd.bolt"
    engine-path: "${SYNOPKG_PKGVAR}/.influxdbv2/engine"
    sqlite-path: "${SYNOPKG_PKGVAR}/.influxdbv2/influxd.sqlite"
EOF
}
