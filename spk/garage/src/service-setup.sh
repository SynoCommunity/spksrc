
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
GROUP="sc-garage"

SVC_BACKGROUND=y
SVC_WRITE_PID=y

# prevent openssl warnings on DSM6
export RANDFILE=/dev/null

service_postinst()
{
   CONFIG_DIR="${SHARE_PATH}/garage"
   CONFIG_FILE="${CONFIG_DIR}/garage.toml"

   mkdir -p "${CONFIG_DIR}"

   if [ ! -f "${CONFIG_FILE}" ]; then
      echo "Creating default Garage config at ${CONFIG_FILE}"
      RPC_SECRET=$(openssl rand -hex 32)
      ADMIN_TOKEN=$(openssl rand -hex 32)
      METRICS_TOKEN=$(openssl rand -hex 32)

      sed \
         -e "s|@SHARE_PATH@|$SHARE_PATH|g" \
         -e "s|@RPC_SECRET@|$RPC_SECRET|g" \
         -e "s|@ADMIN_TOKEN@|$ADMIN_TOKEN|g" \
         -e "s|@METRICS_TOKEN@|$METRICS_TOKEN|g" \
         "${SYNOPKG_PKGDEST}/garage_config_template.toml" > "${CONFIG_FILE}"
   fi
}


service_prestart ()
{
   INST_FUNCTIONS=$(dirname $0)"/functions"
   if [ -r "${INST_FUNCTIONS}" ]; then
      . "${INST_FUNCTIONS}"
      load_variables_from_file ${INST_VARIABLES}
      echo "Variables read from ${INST_VARIABLES}"
   fi

   SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/garage -c ${SHARE_PATH}/garage/garage.toml server"
}

