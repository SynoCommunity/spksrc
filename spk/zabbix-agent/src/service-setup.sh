
# Package Configuration
CONFIG_FILE="${SYNOPKG_PKGVAR}/zabbix_agentd.conf"

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/sbin/zabbix_agentd -c ${CONFIG_FILE}"


service_postinst ()
{
   # apply wizard variables in config file

   # Server= (required)
   sed -e "s|@@wizard_Server@@|${wizard_Server}|g" -i ${CONFIG_FILE}

   # ServerActive= (optional - comment out if empty)
   if [ -n "${wizard_ServerActive}" ]; then
      sed -e "s|@@wizard_ServerActive@@|${wizard_ServerActive}|g" -i ${CONFIG_FILE}
   else
      sed -e "s|^ServerActive=@@wizard_ServerActive@@|# ServerActive=|g" -i ${CONFIG_FILE}
   fi

   # Hostname= (optional - comment out if empty to use HostnameItem default)
   if [ -n "${wizard_Hostname}" ]; then
      sed -e "s|@@wizard_Hostname@@|${wizard_Hostname}|g" -i ${CONFIG_FILE}
   else
      sed -e "s|^Hostname=@@wizard_Hostname@@|# Hostname=|g" -i ${CONFIG_FILE}
   fi
}
