#!/bin/bash

cat <<'JSON' >"${SYNOPKG_TEMP_LOGFILE}"
[
  {
    "step_title": "{{NEXTCLOUD_UPGRADE_NOTICE_STEP_TITLE}}",
    "items": [
      {
        "desc": "{{NEXTCLOUD_UPGRADE_NOTICE_DESCRIPTION}}"
      }
    ],
    "invalid_next_disabled_v2": true
  }
]
JSON
