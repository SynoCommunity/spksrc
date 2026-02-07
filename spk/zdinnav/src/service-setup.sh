ZDINNAV="${SYNOPKG_PKGDEST}/application/bin/ZdinNav.Api"
ZDINNAV_LOG_FILE="${SYNOPKG_PKGVAR}/zdinnav.log"
SERVICE_COMMAND="${ZDINNAV} --config-dir ${SYNOPKG_PKGVAR} --pid-file ${PID_FILE} --logfile ${LOG_FILE}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y
# For storing configuration records 存放用配置记录(群晖自带的数据持久化，安装向导无法获取)
# ZDINNAV_DATA_RECORDING_PATH="${SYNOPKG_PKGVAR}/ZdinNavOtherSettings.json"
ZDINNAV_DATA_RECORDING_PATH="/usr/syno/etc/packages/${SYNOPKG_PKGNAME}/zdinnav_other_settings.json"

# For debugging 日志记录（调试使用）
log_msg() {
	# echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >>${ZDINNAV_LOG_FILE}
	# echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >>"/tmp/zdinnav_test.log"
	# 防止运行无上面的调试代码，导致的异常
	return 0
}

# Path for user data storage 用户存储数据(必须/结尾)
get_zdinnav_folder() {
	# Note: The default path of Synology shared folders is /volumeX/[Shared Folder Name]; the mount volume must be obtained first (compatible with DSM 6/7) 
	# 注：群晖共享文件夹默认路径为 /volumeX/共享文件夹名，需先获取挂载卷（适配DSM 6/7）
	if [ -z "${SYNOPKG_PKGDEST_VOL}" ]; then
		# 兼容DSM 6（无SYNOPKG_PKGDEST_VOL时默认/volume1）
		SYNOPKG_PKGDEST_VOL="/volume1"
	fi
	# 拼接实际路径：卷路径 + zdinnav_wizard_data_folder_name
	echo "${SYNOPKG_PKGDEST_VOL}/${zdinnav_wizard_data_folder_name}/"
}

# 安装完毕后,触发此函数
validate_preinst() {
	log_msg "1、自定义日志， validate_preinst 调用了"
	# Path for user data storage
	local zdinnav_data_folder=$(get_zdinnav_folder)
	# Create directory 创建目录（容错，防止文件路径不存在）
	mkdir -p "$(dirname "${ZDINNAV_DATA_RECORDING_PATH}")" 2>/dev/null
}

# validate_preupgrade() {
# 	log_msg "3、自定义日志， validate_preupgrade 调用了"
# }
# service_preinst() {
# 	log_msg "4、自定义日志， service_preinst 调用了"
# }

# 安装后 调用（文件复制完成）
service_postinst() {
	# 用户数据存放路径
	local zdinnav_data_folder=$(get_zdinnav_folder)
	# Create data persistence folder 创建数据持久化 文件夹
	# install -d -m 755 "${zdinnav_data_folder}"
	install -d -m 755 "${zdinnav_data_folder}database"
	install -d -m 755 "${zdinnav_data_folder}configuration"

	# Save user's config data 保存用户的配置数据
	local zdinnav_wizard_json="${zdinnav_data_folder}configuration/wizard_config.json"
	# wizard_config.json 文件如果不存在则创建
	if [[ ! -f "$zdinnav_wizard_json" ]]; then
		echo "{}" >"$zdinnav_wizard_json"
	fi
	# Save JSON config (stored separately in wizard_config.json for easy user deletion and reset)
	# 保存json配置（单独放在wizard_config.json这里方便用户可以删除，重置）
	jq --arg remark 用户向导配置记录 \
		--arg database_type "$zdinnav_wizard_database_type" \
		--arg connection_settings "$zdinnav_wizard_database_connection" \
		--arg port "${SERVICE_PORT}" \
		'.remark = $remark |
		.database_type = $database_type |
		.connection_settings = $connection_settings |
		.port = $port' \
		"$zdinnav_wizard_json" >/tmp/zdinnav_temp.json &&
		mv /tmp/zdinnav_temp.json "$zdinnav_wizard_json"

	# Zdinnav Config File Settings 智淀导航配置文件设置
	sed -e "s|DBTYPE_VAR|${zdinnav_wizard_database_type}|g" \
		-e "s|CONNECTIONSTRING_VAR|${zdinnav_wizard_database_connection}|g" \
		-e "s|PORT_VAR|${SERVICE_PORT}|g" \
		"${SYNOPKG_PKGDEST}/application/configuration/zdinNavSettings.json" >"${zdinnav_data_folder}configuration/zdinNavSettings.json"

	# Zdinnav Other Configs 智淀导航其它配置
	jq -n \
		--arg remark "此配置谨慎操作，卸载，确认删除数据，会删除此路径全部文件" \
		--arg zdinnav_data_folder "$zdinnav_data_folder" \
		'{
		"remark": $remark,
		"zdinnav_data_folder": $zdinnav_data_folder
		}' >"${ZDINNAV_DATA_RECORDING_PATH}"

	log_msg "安装参数调试：$zdinnav_data_folder"

	# 创建软连接
	$LN "${SYNOPKG_PKGDEST}/application/web" "${SYNOPKG_PKGDEST}/application/bin/zdin-nav"
	$LN "${zdinnav_data_folder}database" "${SYNOPKG_PKGDEST}/application/bin/database"
	$LN "${zdinnav_data_folder}configuration" "${SYNOPKG_PKGDEST}/application/bin/configuration"
	# 设置755
	chmod -R 755 "${SYNOPKG_PKGDEST}/application/bin/zdin-nav"
	chmod 755 "${SYNOPKG_PKGDEST}/application/bin/ZdinNav.Api"
	log_msg "5、自定义日志， service_postinst 调用了"
}

# service_postuninst() {
# 	log_msg "7、自定义日志， service_postuninst 调用了"
# }
# service_preupgrade() {
# 	log_msg "8、自定义日志， service_preupgrade 调用了"
# }
# service_postupgrade() {
# 	log_msg "9、自定义日志， service_postupgrade 调用了"
# }
# # 程序启动调用
# service_prestart() {
# 	log_msg "10、自定义日志， service_prestart 调用了"
# }
# # 程序停止时调用
# service_poststop() {
# 	log_msg "11、自定义日志， service_poststop 调用了"
# }

# 卸卸载之前的校验触发
validate_preuninst() {
	if [ "${wizard_delete_data}" = "true" ]; then
		if [ -f "$ZDINNAV_DATA_RECORDING_PATH" ]; then
			ZDINNAV_FOLDER_PATH=$(jq -r '.zdinnav_data_folder' "$ZDINNAV_DATA_RECORDING_PATH")
		fi
	fi
}

# 卸载后的事件处理
service_preuninst() {
	if [ "${wizard_delete_data}" = "true" ]; then
		if [ -n "$ZDINNAV_FOLDER_PATH" ] && [ -e "$ZDINNAV_FOLDER_PATH" ]; then
			echo "Remove installed ZDINNAV folder (${ZDINNAV_FOLDER_PATH})"
			# Shared files cannot be deleted, but the data inside can (no other solution found for now)
			# 共享文件无法删除，里面的数据可以删除(目前找不到其它办法)
			$RM -rf "${ZDINNAV_FOLDER_PATH}"/*
			$RM -rf "${ZDINNAV_DATA_RECORDING_PATH}"
		fi
	else
		# force deleting DSM 7 package data
		wizard_delete_data=true
	fi
}
