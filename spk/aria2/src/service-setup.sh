
ARIA2_CFG_FILE="${SYNOPKG_PKGVAR}/aria2.conf"
ARIA2_LOG_FILE="${SYNOPKG_PKGVAR}/aria2.log"
ARIA2_SES_FILE="${SYNOPKG_PKGVAR}/aria2.session"
ARIA2_DHT_FILE="${SYNOPKG_PKGVAR}/aria2.dht"
ARIA2_BIN_FILE="${SYNOPKG_PKGDEST}/bin/aria2c"

LOG_FILE="${ARIA2_LOG_FILE}"

SERVICE_COMMAND="${ARIA2_BIN_FILE} --conf-path=${ARIA2_CFG_FILE}"

# useless in start-stop-daemon
SVC_CWD="${SYNOPKG_PKGDEST}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y


service_preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        if [ ! -d "${wizard_download_dir}" ]; then
            mkdir --parents "${wizard_download_dir}" || {
                echo "Download directory ${wizard_download_dir} does not exist."
                exit 1
            }
        fi
    fi
}

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        sed -e "s|%dir%|${wizard_download_dir:=/volume1/downloads}|g" \
            -e "s|%disk-cache%|${wizard_disk_cache:=32M}|g" \
            -e "s|%file-allocation%|${wizard_file_allocation:=falloc}|g" \
            -e "s|%log%|${ARIA2_LOG_FILE}g" \
            -e "s|%log-level%|${wizard_log_level:=error}|g" \
            -e "s|%input-file%|${ARIA2_SES_FILE}|g" \
            -e "s|%save-session%|${ARIA2_SES_FILE}|g" \
            -e "s|%max-concurrent-downloads%|${wizard_max_concurrent_downloads:=10}|g" \
            -e "s|%max-connection-per-server%|${wizard_max_connection_per_server:=5}|g" \
            -e "s|%max-upload-limit%|${wizard_max_upload_limit:=16K}|g" \
            -e "s|%seed-ratio%|${wizard_seed_ratio:=0.0}|g" \
            -e "s|%seed-time%|${wizard_seed_time:=0}|g" \
            -e "s|%dht-file-path%|${ARIA2_DHT_FILE}|g" \
            -e "s|%rpc-secret%|${wizard_rpc_secret}|g" \
            -i ${ARIA2_CFG_FILE}
    fi
}
