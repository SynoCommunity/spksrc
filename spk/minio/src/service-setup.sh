
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
GROUP="sc-minio"

INST_ETC="/var/packages/${SYNOPKG_PKGNAME}/etc"
INST_VARIABLES="${INST_ETC}/installer-variables"
ENV_VARIABLES="${SYNOPKG_PKGVAR}/environment-variables"

CONSOLE_PORT=9001

SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
   echo HOME="${SYNOPKG_PKGVAR}"                           >> ${INST_VARIABLES}
   echo MINIO_ROOT_USER="${wizard_root_user}"              >> ${INST_VARIABLES}
   echo MINIO_ROOT_PASSWORD="${wizard_root_password}"      >> ${INST_VARIABLES}
}

# function to read and export variables from a text file
# empty lines and lines starting with # are ignored
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

   SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/minio server --quiet --console-address :${CONSOLE_PORT} --anonymous ${SHARE_PATH}"
}
