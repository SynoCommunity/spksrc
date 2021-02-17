SERVICE_COMMAND='/var/packages/rabbitmq-server/target/lib/rabbitmq_server-3.8.12/sbin/rabbitmq-server'
SVC_CWD="${SYNOPKG_PKGDEST}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y



service_preinst ()
{
    echo "service_preinst ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
}

service_postinst ()
{
    echo "service_postinst ${SYNOPKG_PKG_STATUS}" >> $INST_LOG

    sed -i 's/SYS_PREFIX\=/SYS_PREFIX\=\/var\/packages\/rabbitmq-server\/target\//g' /var/packages/rabbitmq-server/target/lib/rabbitmq_server-3.8.12/sbin/rabbitmq-defaults

}

service_preuninst ()
{
    echo "service_preuninst ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
}

service_postinst ()
{
    echo "service_postuninst ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
}

service_preupgrade ()
{
    echo "service_preupgrade ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
}

service_postupgrade ()
{
    echo "service_postupgrade ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
}

service_poststop ()
{
    echo "After stop" >> $LOG_FILE
}

