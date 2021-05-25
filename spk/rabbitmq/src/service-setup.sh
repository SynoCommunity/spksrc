
RABBITMQ_SBIN=${SYNOPKG_PKGDEST}/lib/rabbitmq_server-3.8.16/sbin
SERVICE_COMMAND="${RABBITMQ_SBIN}/rabbitmq-server"
SVC_CWD="${SYNOPKG_PKGDEST}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# HOME to place the erlang cookie into
export HOME=${SYNOPKG_PKGDEST}

service_postinst ()
{
    sed -i "s%SYS_PREFIX=%SYS_PREFIX=${SYNOPKG_PKGDEST}%g" ${RABBITMQ_SBIN}/rabbitmq-defaults
}

