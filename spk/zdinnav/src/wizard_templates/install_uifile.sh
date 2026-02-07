#!/bin/bash
# For storing configuration records 存放用配置记录(群晖自带的数据持久化)
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

get_wizard_zdinnav_install() {
	# Default config initialization 默认初始化配置
	local zdinnav_data_folder_name="ZdinNav"
	local zdinnav_database_type="Sqlite"
	local zdinnav_database_connection="Data Source=ZdinNav.db;Mode=ReadWriteCreate;"

	# Read and record info from the user's previous config file 用户之前的配置文件读取记录信息
	if [ -f "$ZDINNAV_DATA_RECORDING_PATH" ]; then
		local zdinnav_folder_path=$(jq -r '.zdinnav_data_folder' "$ZDINNAV_DATA_RECORDING_PATH")
		if [ -d "$zdinnav_folder_path" ]; then
			# 获取文件夹名称
			zdinnav_data_folder_name=$(sed -e 's/\/$//' -e 's/.*\///' <<<"$zdinnav_folder_path")
		fi
		# Place separately in wizard_config.json for easy user deletion and reset 单独放在wizard_config.json这里方便用户可以删除，重置
		local zdinnav_wizard_json="${zdinnav_folder_path}configuration/wizard_config.json"
		if [ -f "$zdinnav_wizard_json" ]; then
			# Read info from the user's previous config file 读取配置文件信息
			zdinnav_database_type=$(jq -r '.database_type' "$zdinnav_wizard_json")
			zdinnav_database_connection=$(jq -r '.connection_settings' "$zdinnav_wizard_json")
		fi
	fi

	# 转译处理
	zdinnav_data_folder_name=$(printf '%s' "$zdinnav_data_folder_name" | quote_json)
	zdinnav_database_type=$(printf '%s' "$zdinnav_database_type" | quote_json)
	zdinnav_database_connection=$(printf '%s' "$zdinnav_database_connection" | quote_json)

	local wizard_install=$(
		/bin/cat <<EOF
  {
    "step_title": "{{{ZDINNAV_WIZARD_INSTALL_TITLE}}}",
    "invalid_next_disabled_v2": true,
    "items": [
      {
        "type": "textfield",
        "desc": "{{{ZDINNAV_WIZARD_INSTALL_PATH_DESCRIPTION}}}<b style=\"color: red\">{{{ZDINNAV_WIZARD_INSTALL_WARNING_DESCRIPTION}}}</b>",
        "subitems": [
          {
            "key": "zdinnav_wizard_data_folder_name",
            "desc": "{{{ZDINNAV_WIZARD_INSTALL_PATH}}}",
            "defaultValue": "${zdinnav_data_folder_name}",
            "validator": {
              "allowBlank": false,
              "regex": {
                "expr": "/^[\\\w.][\\\w. -]{0,30}[\\\w.-][\\\\$]?$|^[\\\w][\\\\$]?$/",
                "errorText": "{{{ZDINNAV_WIZARD_INSTALL_WARNING_PATH}}}"
              }
            }
          }
        ]
      }
    ]
  },
  {
    "step_title": "{{{ZDINNAV_WIZARD_INSTALL_SETTINGS_TITLE}}}",
    "invalid_next_disabled_v2": true,
    "items": [
      {
        "desc": "{{{ZDINNAV_WIZARD_INSTALL_WARNING_db_a}}}<b style=\"color: red\">{{{ZDINNAV_WIZARD_INSTALL_WARNING_db_b}}}</b>"
      },
      {
        "desc": "{{{ZDINNAV_WIZARD_INSTALL_WARNING_db_c}}}"
      },
      {
        "desc": "{{{ZDINNAV_WIZARD_INSTALL_WARNING_db_d}}}"
      },
      {
        "type": "combobox",
        "subitems": [
          {
            "key": "zdinnav_wizard_database_type",
            "desc": "{{{ZDINNAV_WIZARD_INSTALL_DATABASE_TYPE}}}",
            "editable": true,
            "defaultValue": "${zdinnav_database_type}",
            "store": [
              "Sqlite",
              "PostgreSQL",
              "MySql",
              "SqlServer"
            ],
            "validator": {
              "allowBlank": false
            }
          }
        ]
      },
      {
        "type": "textfield",
        "desc": "{{{ZDINNAV_WIZARD_INSTALL_CONNECTION_DESCRIPTION}}}",
        "subitems": [
          {
            "key": "zdinnav_wizard_database_connection",
            "desc": "{{{ZDINNAV_WIZARD_INSTALL_CONNECTION}}}",
            "defaultValue": "${zdinnav_database_connection}",
            "validator": {
              "allowBlank": false
            }
          }
        ]
      }
    ]
  },
  {
    "step_title": "{{{ZDINNAV_WIZARD_INSTALL_MORE_TITLE}}}",
    "items": [
      {
        "desc": "{{{ZDINNAV_WIZARD_INSTALL_GUIDE}}} <a target=\"_blank\" href=\"https://www.bilibili.com/list/309910878/?sid=5054762&bvid=BV1EzqSB8Eck\">{{{ZDINNAV_WIZARD_INSTALL_WATCH}}}</a>，{{{ZDINNAV_WIZARD_INSTALL_LINK}}} <a target=\"_blank\" href=\"https://github.com/MyTkme/ZdinNav-Link\">Github</a>。"
      },
      {
        "desc": "{{{ZDINNAV_WIZARD_INSTALL_JOIN}}} <a target=\"_blank\" href=\"https://qm.qq.com/q/2jzO6bYQEI\">{{{ZDINNAV_WIZARD_INSTALL_QQ_GROUP}}}</a>，{{{ZDINNAV_WIZARD_INSTALL_TPLEASANT}}}"
      },
      {
        "desc": "<b style=\"color: #d14141\">{{{DEFAULT_ACCOUNT_REMARK}}}</b>"
      }
    ]
  }
EOF
	)

	echo "$wizard_install"
}

main() {
	local install_page=""
	local wizard_install_config=$(get_wizard_zdinnav_install)
	install_page=$(page_append "$install_page" "$wizard_install_config")
	echo "[$install_page]" >"${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
