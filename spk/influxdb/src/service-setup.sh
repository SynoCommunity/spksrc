SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/influxd"
SVC_BACKGROUND=yes
SVC_WRITE_PID=yes
SVC_CWD="${SYNOPKG_PKGVAR}"


service_preinst ()
{
    # Set the port to 8085 in a config.yaml file
    # This is the port that the web interface will be available on
    cat << EOF > "${SYNOPKG_PKGVAR}"/config.yaml
    http-bind-address: ":8085"
    reporting-disabled: true
EOF
}