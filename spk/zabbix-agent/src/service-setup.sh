
# Package Configuration
CONFIG_FILE="${SYNOPKG_PKGVAR}/zabbix_agentd.conf"

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/sbin/zabbix_agentd -c ${CONFIG_FILE}"

service_postinst ()
{
   # apply wizard variables in config file
   
   # Server=
   sed -e "s|@@wizard_Server@@|${wizard_Server}|g" -i ${CONFIG_FILE}
    
   ## not yet defined, must currently be empty
   # ServerActive=
   sed -e "s|@@wizard_ServerActive@@|${wizard_ServerActive}|g" -i ${CONFIG_FILE}
   
}

