
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
GROUP="sc-go2rtc"

GO2RTC_CFG_FILE="${SYNOPKG_PKGVAR}/go2rtc.yaml"

CONSOLE_PORT=1984

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/go2rtc -config ${GO2RTC_CFG_FILE}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
   echo -e "api:\n  username: ${wizard_root_user}\n  password: ${wizard_root_password}\n" > ${GO2RTC_CFG_FILE}
}
