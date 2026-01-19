
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
GROUP="sc-garage"

SVC_BACKGROUND=y
SVC_WRITE_PID=y


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
      cat > "${CONFIG_FILE}" <<EOF
metadata_dir = "${SHARE_PATH}/garage/meta"
data_dir = "${SHARE_PATH}/garage/data"
db_engine = "sqlite"

replication_factor = 1

block_ram_buffer_max = "128MiB"

rpc_bind_addr = "[::]:3901"
rpc_public_addr = "127.0.0.1:3901"
rpc_secret = "${RPC_SECRET}"

[s3_api]
s3_region = "garage"
api_bind_addr = "[::]:3900"
root_domain = ".s3.garage.localhost"

[s3_web]
bind_addr = "[::]:3902"
root_domain = ".web.garage.localhost"
index = "index.html"

[k2v_api]
api_bind_addr = "[::]:3904"

[admin]
api_bind_addr = "[::]:3903"
admin_token = "${ADMIN_TOKEN}"
metrics_token = "${METRICS_TOKEN}"

EOF
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

