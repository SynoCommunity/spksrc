#!/bin/bash
# 存放用配置记录(群晖自带的数据持久化)
ZDINNAV_DATA_RECORDING_PATH="/usr/syno/etc/packages/${SYNOPKG_PKGNAME}/zdinnav_other_settings.json"

quote_json() {
	sed -e 's|\\|\\\\|g' -e 's|\"|\\\"|g'
}

page_append() {
	if [ -z "$1" ]; then
		echo "$2"
	elif [ -z "$2" ]; then
		echo "$1"
	else
		echo "$1,$2"
	fi
}

get_wizard_zdinnav_uninstall() {
	# 用户数据保存路径的文件夹名称
	local zdinnav_data_folder_name="ZdinNav"
	if [ -f "$ZDINNAV_DATA_RECORDING_PATH" ]; then
		local zdinnav_folder_path=$(jq -r '.zdinnav_data_folder' "$ZDINNAV_DATA_RECORDING_PATH")
		if [ -n "$zdinnav_folder_path" ]; then
			# 获取文件夹名称
			zdinnav_data_folder_name=$(sed -e 's/\/$//' -e 's/.*\///' <<<"$zdinnav_folder_path")
		fi
	fi
	# 转译处理
	zdinnav_data_folder_name=$(printf '%s' "$zdinnav_data_folder_name" | quote_json)

	local wizard_uninstall=$(
		/bin/cat <<EOF
{
    "step_title": "{{{ZDINNAV_WIZARD_UNINSTALL_TITLE}}}",
    "items": [{
        "type": "singleselect",
        "desc": "{{{ZDINNAV_WIZARD_UNINSTALL_DESCRIPTION}}}",
        "subitems": [{
            "key": "wizard_keep_data",
            "desc": "{{{ZDINNAV_WIZARD_UNINSTALL_KEEP}}}",
            "defaultValue": true
        }, {
            "key": "wizard_delete_data",
            "desc": "<b style=\"color: red\">{{{ZDINNAV_WIZARD_UNINSTALL_DELETE}}}${zdinnav_data_folder_name}</b>",  
            "defaultValue": false
        }]
    }]
}
EOF
	)

	echo "$wizard_uninstall"
}

main() {
	local uninstall_page=""
	local wizard_uninstall_config=$(get_wizard_zdinnav_uninstall)
	uninstall_page=$(page_append "$uninstall_page" "$wizard_uninstall_config")
	echo "[$uninstall_page]" >"${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
