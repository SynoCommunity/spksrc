
DAEMON=${SYNOPKG_PKGDEST}/bin/qemu-ga
SERVICE_COMMAND="${DAEMON} --daemonize --logfile ${LOG_FILE} --pidfile ${PID_FILE}"


service_postinst ()
{
   # ensure "statedir" var/run exists
   mkdir -p ${SYNOPKG_PKGVAR}/run
   
}

service_prestart ()
{
   # Create /dev/virtio-ports/org.qemu.guest_agent.0 on demand
   if ( [ ! -f /dev/virtio-ports/org.qemu.guest_agent.0 ] ); then
      mkdir -p /dev/virtio-ports
      touch /dev/virtio-ports/org.qemu.guest_agent.0
   fi   
}
