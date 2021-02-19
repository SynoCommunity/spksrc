SERVICE_COMMAND='/var/packages/rabbitmq/target/lib/rabbitmq_server-3.8.12/sbin/rabbitmq-server'
SVC_CWD="${SYNOPKG_PKGDEST}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y


service_postinst ()
{

    sed -i 's/SYS_PREFIX\=/SYS_PREFIX\=\/var\/packages\/rabbitmq\/target\//g' /var/packages/rabbitmq/target/lib/rabbitmq_server-3.8.12/sbin/rabbitmq-defaults

}

