
# evaluate version dependent path
PATTERN=( ${SYNOPKG_PKGDEST}/lib/rabbitmq_server-*/sbin )
RABBITMQ_SBIN=${PATTERN[0]}

SERVICE_COMMAND="${RABBITMQ_SBIN}/rabbitmq-server"
SVC_CWD="${SYNOPKG_PKGDEST}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# HOME to place the erlang cookie into
export HOME=${SYNOPKG_PKGDEST}

service_postinst ()
{
    echo "Set SYS_PREFIX=${SYNOPKG_PKGDEST} in ${RABBITMQ_SBIN}/rabbitmq-defaults"
    sed -i "s%SYS_PREFIX=%SYS_PREFIX=${SYNOPKG_PKGDEST}%g" ${RABBITMQ_SBIN}/rabbitmq-defaults
}

