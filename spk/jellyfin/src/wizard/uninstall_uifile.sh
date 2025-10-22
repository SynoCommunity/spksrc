#!/bin/bash

quote_json ()
{
  sed -e 's|\\|\\\\|g' -e 's|\"|\\\"|g'
}

page_append ()
{
  if [ -z "$1" ]; then
    echo "$2"
  elif [ -z "$2" ]; then
    echo "$1"
  else
    echo "$1,$2"
  fi
}

check_backup_file() {
  # Ensure package name and var directory are defined
  [ -z "${SYNOPKG_PKGVAR}" ] && SYNOPKG_PKGVAR="${SYNOPKG_PKGDEST}/var"
  [ -z "${SYNOPKG_PKGNAME}" ] && SYNOPKG_PKGNAME="jellyfin"

  sc_backup="${SYNOPKG_PKGVAR}/sc_backup"
  expected_prefix="${SYNOPKG_PKGNAME}_backup_v10.10.7_"

  # No backup directory → false
  [ -d "${sc_backup}" ] || return 1

  # Look for a matching backup file (e.g. jellyfin_backup_v10.10.7_YYYYMMDD.tar.gz)
  set -- "${sc_backup}/${expected_prefix}"*.tar.gz

  # No matching file → false
  [ -e "$1" ] || return 1

  # Found a valid backup → true
  return 0
}

PAGE_UNINSTALL_RESTORE=$(/bin/cat<<EOF
{
  "step_title": "Uninstall package",
  "items": [{
    "type": "singleselect",
    "desc": "Keep, restore or delete package settings.",
    "subitems": [{
      "key": "wizard_keep_data",
      "desc": "<b>Uninstall only.</b> Keep existing files for future re-installation.",
      "defaultValue": true
    }, {
      "key": "wizard_restore_data",
      "desc": "<b style=\"color: green\">Restore backup of the package data files from previous version. (Not Recoverable)</b>",
      "defaultValue": false
    }, {
      "key": "wizard_delete_data",
      "desc": "<b style=\"color: red\">Erase all of the package data files. (Not Recoverable)</b>",
      "defaultValue": false
    }]
  }]
}
EOF
)

PAGE_UNINSTALL=$(/bin/cat<<EOF
{
  "step_title": "Uninstall package",
  "items": [{
    "type": "singleselect",
    "desc": "Keep or delete package settings.",
    "subitems": [{
      "key": "wizard_keep_data",
      "desc": "<b>Uninstall only.</b> Keep existing files for future re-installation.",
      "defaultValue": true
    }, {
      "key": "wizard_delete_data",
      "desc": "<b style=\"color: red\">Erase all of the package data files. (Not Recoverable)</b>",
      "defaultValue": false
    }]
  }]
}
EOF
)

main () {
  local uninstall_page=""
  if check_backup_file; then
    uninstall_page=$(page_append "$uninstall_page" "$PAGE_UNINSTALL_RESTORE")
  else
    uninstall_page=$(page_append "$uninstall_page" "$PAGE_UNINSTALL")
  fi
  echo "[$uninstall_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
