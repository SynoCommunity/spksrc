# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts

ARIA2_CFG_FILE="${SYNOPKG_PKGDEST}/var/aria2.conf"
ARIA2_LOG_FILE="${SYNOPKG_PKGDEST}/var/aria2.log"
ARIA2_SES_FILE="${SYNOPKG_PKGDEST}/var/aria2.session"
ARIA2_DHT_FILE="${SYNOPKG_PKGDEST}/var/aria2.dht"
ARIA2_BIN_FILE="${SYNOPKG_PKGDEST}/bin/aria2c"

LOG_FILE="${ARIA2_LOG_FILE}"

SERVICE_COMMAND="${ARIA2_BIN_FILE} --conf-path=${ARIA2_CFG_FILE}"

# SERVICE_EXE = "${ARIA2_BIN_FILE}"
# SERVICE_OPTIONS = " --conf-path=${ARIA2_CFG_FILE}"

# useless in start-stop-daemon
SVC_CWD="${SYNOPKG_PKGDEST}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# These functions are for demonstration purpose of DSM sequence call.
# Only provide useful ones for your own package, logging may be removed.
service_preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        if [ ! -d "${wizard_download_dir}" ]; then
            mkdir --parents "${wizard_download_dir}" || {
                echo "Download directory ${wizard_download_dir} does not exist."
                exit 1
            }
        fi
        set_syno_permissions "${wizard_download_dir}" "${wizard_group}"
    fi
    echo "service_preinst ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
}

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        sed -i -e "s|%dir%|${wizard_download_dir:=/volume1/downloads}|g" ${ARIA2_CFG_FILE}
        sed -i -e "s|%disk-cache%|${wizard_disk_cache:=32M}|g" ${ARIA2_CFG_FILE}
        sed -i -e "s|%file-allocation%|${wizard_file_allocation:=falloc}|g" ${ARIA2_CFG_FILE}
        sed -i -e "s|%log%|${ARIA2_LOG_FILE}g" ${ARIA2_CFG_FILE}
        sed -i -e "s|%log-level%|${wizard_log_level:=error}|g" ${ARIA2_CFG_FILE}
        sed -i -e "s|%input-file%|${ARIA2_SES_FILE}|g" ${ARIA2_CFG_FILE}
        sed -i -e "s|%save-session%|${ARIA2_SES_FILE}|g" ${ARIA2_CFG_FILE}
        sed -i -e "s|%max-concurrent-downloads%|${wizard_max_concurrent_downloads:=10}|g" ${ARIA2_CFG_FILE}
        sed -i -e "s|%max-connection-per-server%|${wizard_max_connection_per_server:=5}|g" ${ARIA2_CFG_FILE}
        sed -i -e "s|%max-upload-limit%|${wizard_max_upload_limit:=16K}|g" ${ARIA2_CFG_FILE}
        sed -i -e "s|%seed-ratio%|${wizard_seed_ratio:=0.0}|g" ${ARIA2_CFG_FILE}
        sed -i -e "s|%seed-time%|${wizard_seed_time:=0}|g" ${ARIA2_CFG_FILE}
        sed -i -e "s|%dht-file-path%|${ARIA2_DHT_FILE}|g" ${ARIA2_CFG_FILE}
        sed -i -e "s|%rpc-secret%|${wizard_rpc_secret}|g" ${ARIA2_CFG_FILE}
    fi
    echo "service_postinst ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
}

service_preuninst ()
{
    echo "service_preuninst ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
}

service_preupgrade ()
{
    echo "service_preupgrade ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
}

service_postupgrade ()
{
    echo "service_postupgrade ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
}

service_poststop ()
{
    echo "After stop" >> $LOG_FILE
}
