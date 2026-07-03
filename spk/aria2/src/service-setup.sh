
CFG_FILE="${SYNOPKG_PKGVAR}/aria2.conf"
DHT_FILE="${SYNOPKG_PKGVAR}/dht.dat"
SESSION_FILE="${SYNOPKG_PKGVAR}/aria2.session"

ARIA2C="${SYNOPKG_PKGDEST}/bin/aria2c"
SERVICE_COMMAND="${ARIA2C} --conf-path=${CFG_FILE}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
   if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
      # create required files
      touch ${DHT_FILE}
      touch ${SESSION_FILE}
      
      # apply wizzard settings
      sed -e "s|%dir%|${SHARE_PATH}|g" \
          -e "s|%disk-cache%|${wizard_disk_cache}|g" \
          -e "s|%file-allocation%|${wizard_file_allocation}|g" \
          -e "s|%log-level%|${wizard_log_level}|g" \
          -e "s|%max-concurrent-downloads%|${wizard_max_concurrent_downloads}|g" \
          -e "s|%max-connection-per-server%|${wizard_max_connection_per_server}|g" \
          -e "s|%max-upload-limit%|${wizard_max_upload_limit}|g" \
          -e "s|%seed-ratio%|${wizard_seed_ratio}|g" \
          -e "s|%seed-time%|${wizard_seed_time}|g" \
          -e "s|%rpc-secret%|${wizard_rpc_secret}|g" \
          -i ${CFG_FILE}
    fi
}
