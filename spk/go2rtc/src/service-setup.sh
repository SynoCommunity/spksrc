
CFG_FILE="${SYNOPKG_PKGVAR}/go2rtc.yaml"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/go2rtc -config ${CFG_FILE}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y


service_postinst ()
{
   if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
      sed -e "s|@@root_user@@|${wizard_root_user}|g" \
          -e "s|@@root_password@@|${wizard_root_password}|g" \
          -i ${CFG_FILE}
   fi
}
