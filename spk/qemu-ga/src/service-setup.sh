
CUSTOM_PORT_FILE=${SYNOPKG_PKGVAR}/custom_port.txt
CUSTOM_PORT="$(test -r ${CUSTOM_PORT_FILE} && cat ${CUSTOM_PORT_FILE} | xargs)"
CUSTOM_PORT_PARAMETER=
if [ -n "${CUSTOM_PORT}" -a -e "${CUSTOM_PORT}" ]; then
   CUSTOM_PORT_PARAMETER="-p ${CUSTOM_PORT}"
fi

DAEMON=${SYNOPKG_PKGDEST}/bin/qemu-ga
SERVICE_COMMAND="${DAEMON} --daemonize --logfile ${LOG_FILE} --pidfile ${PID_FILE} ${CUSTOM_PORT_PARAMETER}"

service_postinst ()
{
   # ensure "statedir" var/run exists
   mkdir -p ${SYNOPKG_PKGVAR}/run
   
   # optionally create file with custom port
   if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
      if [ -n "${wizard_custom_port}" ]; then
         echo "${wizard_custom_port}" > ${CUSTOM_PORT_FILE}
      else
         # ensure file does not exist (could be retained when uninstalling under DSM 7)
         rm -f ${CUSTOM_PORT_FILE}
      fi
   fi
}

service_prestart ()
{
   # Create /dev/virtio-ports/org.qemu.guest_agent.0 on demand
   if [ ! -f /dev/virtio-ports/org.qemu.guest_agent.0 ]; then
      mkdir -p /dev/virtio-ports
      touch /dev/virtio-ports/org.qemu.guest_agent.0
   fi
}

service_postuninst ()
{
   # remove /dev/virtio-ports/org.qemu.guest_agent.0
   if [ -f /dev/virtio-ports/org.qemu.guest_agent.0 ]; then
      rm -f /dev/virtio-ports/org.qemu.guest_agent.0
   fi
}
