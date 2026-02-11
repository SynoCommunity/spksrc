
# Package Configuration
CONFIG_FILE="${SYNOPKG_PKGVAR}/zabbix_agentd.conf"

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/sbin/zabbix_agentd -c ${CONFIG_FILE}"


validate_preinst ()
{
   if [ -z "${wizard_Hostname}" -a -n "${wizard_ServerActive}" ]; then
      echo "Invalid Configuration. Empty Hostname is not allowed when ServerActiv is configured."
      exit 1
   fi
}


service_postinst ()
{
   # apply wizard variables in config file
   
   # Server=
   sed -e "s|@@wizard_Server@@|${wizard_Server}|g" -i ${CONFIG_FILE}

   # ServerActive=
   sed -e "s|@@wizard_ServerActive@@|${wizard_ServerActive}|g" -i ${CONFIG_FILE}
   # Hostname=
   sed -e "s|@@wizard_Hostname@@|${wizard_Hostname}|g" -i ${CONFIG_FILE}
}
