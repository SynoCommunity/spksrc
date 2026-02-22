
# evaluate version dependent path (do it /bin/sh compatible)
for config_dir in ${SYNOPKG_PKGDEST}/lib/rabbitmq_server-*/sbin; do
    RABBITMQ_SBIN=${config_dir}
    break
done

SERVICE_COMMAND="${RABBITMQ_SBIN}/rabbitmq-server"
SVC_CWD="${SYNOPKG_PKGDEST}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# HOME to place the erlang cookie into
# Use SYNOPKG_PKGVAR so CLI tools can find it
export HOME=${SYNOPKG_PKGVAR}

service_postinst ()
{
    echo "Set SYS_PREFIX=${SYNOPKG_PKGDEST} in ${RABBITMQ_SBIN}/rabbitmq-defaults"
    sed -i "s%SYS_PREFIX=%SYS_PREFIX=${SYNOPKG_PKGDEST}%g" ${RABBITMQ_SBIN}/rabbitmq-defaults
}
