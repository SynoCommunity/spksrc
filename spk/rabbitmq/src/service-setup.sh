SERVICE_COMMAND='/var/packages/rabbitmq/target/lib/rabbitmq_server-3.8.12/sbin/rabbitmq-server'
SVC_CWD="${SYNOPKG_PKGDEST}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# HOME useful at installation time
export HOME=/var/packages/rabbitmq/home

MQ_BIN=/var/packages/rabbitmq/target/lib/rabbitmq_server-3.8.12/sbin

service_postinst ()
{

    sed -i 's/SYS_PREFIX\=/SYS_PREFIX\=\/var\/packages\/rabbitmq\/target\//g' ${MQ_BIN}/rabbitmq-d
efaults

    # install plugins for rabbitmq management
    ${MQ_BIN}/rabbitmq-plugins enable rabbitmq_management

}

