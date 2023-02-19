
load_variables_from_file "${INST_VARIABLES}"

initialize_variables

wizard_download_share_input()
{
  local wizard_download_share_input_value=$1
  local wizard_download_dir_input_value=$2
  cat <<END_OF_INPUT
{
    "type": "textfield",
    "subitems": [
        {
            "key": "wizard_download_share",
            "desc": "${DOWNLOAD_SHARED_FOLDER_LOCATION}",
            "defaultValue": "${wizard_download_share_input_value}",
            "disabled": true
        },
        {
            "key": "wizard_download_dir",
            "defaultValue": "${wizard_download_dir_input_value}",
            "hidden": true
        }
    ]
}
END_OF_INPUT
}

data_share_migration_step() {
  cat <<END_OF_STEP
{
    "step_title": "${DSM_PERMISSIONS_STEP_TITLE}",
    "items": [
        {
            "desc": "${DSM_PERMISSIONS_STEP_DESC}"
        },
        $(wizard_download_share_input "${SHARE_NAME}" "${SHARE_PATH}")
    ]
}
END_OF_STEP
}

{
  echo "["
  if [ "$(echo "${SYNOPKG_OLD_PKGVER}" | sed -r "s/^.*-([0-9]+)$/\1/")" -lt 13 ]; then
    # Means that we'll need to have a wizard step about the download directory
    data_share_migration_step;
  fi
  echo "]";
}> "${SYNOPKG_TEMP_LOGFILE}"
