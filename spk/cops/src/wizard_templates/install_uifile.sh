

cops_configuration_first_step() {
  cat <<END_OF_STEP
{
    "step_title": "{{{COPS_CONFIGURATION_FIRST_STEP_TITLE}}}",
    "items": [{
        "type": "textfield",
        "desc": "{{{EXISTING_CALIBRE_DIRECTORY_DESCRIPTION}}}",
        "subitems": [{
            "key": "wizard_calibre_dir",
            "defaultValue": "/volume1/calibre/",
            "desc": "{{{EXISTING_CALIBRE_DIRECTORY_LABEL}}}"
        }]
    }, {
        "type": "textfield",
        "desc": "{{{COPS_CATALOG_TITLE_DESCRIPTION}}}",
        "subitems": [{
            "key": "wizard_cops_title",
            "defaultValue": "COPS",
            "desc": "{{{COPS_CATALOG_TITLE_LABEL}}}"
        }]
    }]
}
END_OF_STEP
}

cops_configuration_second_step() {
  cat <<END_OF_STEP
{
    "step_title": "{{{COPS_CONFIGURATION_SECOND_STEP_TITLE}}}",
    "items": [{
        "type": "multiselect",
        "desc": "{{{DO_YOU_WANT_TO_USE_COPS_WITH_A_KOBO_DESCRIPTION}}}",
        "subitems": [{
            "key": "wizard_use_url_rewriting",
            "desc": "{{{DO_YOU_WANT_TO_USE_COPS_WITH_A_KOBO_LABEL}}}"
        }]
    }]
}
END_OF_STEP
}

dsm_permissions() {
    cat <<END_OF_STEP
{
    "step_title": "{{{DSM_PERMISSIONS_TITLE}}}",
    "items": [
        {
            "desc": "{{{DSM_PERMISSIONS_TEXT}}}"
        }
    ]
}
END_OF_STEP
}

php_configuration_requirements() {
  cat <<END_OF_STEP
{
    "step_title": "{{{PHP Configuration Requirements}}}",
    "items": [
        {
            "desc": "{{{PHP_CONFIGURATION_REQUIREMENTS_EXPLANATION}}}"
        },
        {
            "desc": "<ul><li>gd</li><li>intl</li><li>pdo_sqlite</li><li>sqlite3</li><li>zlib</li></ul>"
        }
    ]
}
END_OF_STEP
}

{
  echo "[";
  cops_configuration_first_step;
  echo ","
  cops_configuration_second_step;
  if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
    echo ",";
    php_configuration_requirements;
  fi
  echo ","
  dsm_permissions;
  echo "]";
}> "{{{SYNOPKG_TEMP_LOGFILE}}}"
