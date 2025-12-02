DDNS_GO="${SYNOPKG_PKGDEST}/bin/ddns-go -l :${SERVICE_PORT}"
CONFIG_FILE="${SYNOPKG_PKGVAR}/config.yaml"

SVC_BACKGROUND=yes
SVC_WRITE_PID=yes

# The following content refers to the service-setup.sh file in the minio package.
INST_ETC="/var/packages/${SYNOPKG_PKGNAME}/etc"
INST_VARIABLES="${INST_ETC}/installer-variables"
ENV_VARIABLES="${SYNOPKG_PKGVAR}/environment-variables"

service_postinst ()
{
    if [ -n "${wizard_frequency}" ] && [ -n "${wizard_cachetimes}" ]; then
        echo "DDNS_GO_FREQUENCY=${wizard_frequency}" > ${INST_VARIABLES}
        echo "DDNS_GO_CACHETIMES=${wizard_cachetimes}" >> ${INST_VARIABLES}
    fi
}

export_variables_from_file ()
{
   if [ -n "$1" -a -r "$1" ]; then
      while read -r _line; do
        if [ "$(echo ${_line} | grep -v ^[/s]*#)" != "" ]; then
           _key="$(echo ${_line} | cut --fields=1 --delimiter==)"
           _value="$(echo ${_line} | cut --fields=2- --delimiter==)"
           export "${_key}=${_value}"
        fi
      done < "$1"
   fi
}

service_prestart ()
{
   # Reload wizard variables stored by postinst
   export_variables_from_file "${INST_VARIABLES}"

   # Load custom variables
   export_variables_from_file "${ENV_VARIABLES}"

   SERVICE_COMMAND="${DDNS_GO} -c ${CONFIG_FILE}  -f ${DDNS_GO_FREQUENCY} -cacheTimes ${DDNS_GO_CACHETIMES}"
}
