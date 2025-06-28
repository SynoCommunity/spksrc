OPENLIST="${SYNOPKG_PKGDEST}/bin/openlist --data ${SYNOPKG_PKGVAR}"

SERVICE_COMMAND="${OPENLIST} server"
SVC_BACKGROUND=yes
SVC_WRITE_PID=yes

# TODO: get admin password from installation wizard
wizard_admin_password=admin

service_postinst ()
{
   if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
      echo "Set OpenList amdin password"
      ${OPENLIST} password set ${wizard_admin_password}
   fi
}
