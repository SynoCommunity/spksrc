#!/bin/bash

function with_migration
{
  cat <<EOF >"${SYNOPKG_TEMP_LOGFILE}"
[ {
  "step_title": "DB Migration for tt-rss",
  "items": [ {
    "type": "multiselect",
    "subitems": [ {
        "key": "wizard_run_migration",
        "desc": "Run migration",
        "defaultValue": true,
        "hidden": true
      }, {
        "key": "wizard_create_db",
        "desc": "Creates initial DB",
        "defaultValue": false,
        "hidden": true
      }, {
         "key": "mysql_grant_user",
         "desc": "Initializes user rights",
         "defaultValue": true,
         "hidden": true
       } ]
    }, {
      "type": "password",
      "desc": "Enter your respective Maria DB installation root account passwords",
      "subitems": [ {
          "key": "wizard_mariadb5_password_root",
          "desc": "Maria DB 5",
          "validator": {
              "allowBlank": false
          }
        }, {
          "key": "wizard_mysql_password_root",
          "desc": "Maria DB 10",
          "validator": {
              "allowBlank": false
          }
        } ]
    }, {
       "type": "password",
       "desc": "A new 'ttrss' user will be created. Please enter a password for the 'ttrss' user.",
       "subitems": [{
         "key": "wizard_mysql_password_ttrss",
         "desc": "Ttrss password"
       }]
     } ]
  }]  
EOF
}

function without_migration
{
  cat <<EOF >"${SYNOPKG_TEMP_LOGFILE}"
[ {
  "step_title": "WebStation PHP Profile",
  "items": [ {
    "type": "multiselect",
    "subitems": [ {
        "key": "wizard_run_migration",
        "desc": "Run migration",
        "defaultValue": false,
        "hidden": true
      }, {
        "key": "wizard_create_db",
        "desc": "Creates initial DB",
        "defaultValue": false,
        "hidden": true
      }, {
        "key": "mysql_grant_user",
        "desc": "Initializes user rights",
        "defaultValue": false,
        "hidden": true
      } ]
    } ]
} ]
EOF
}


if [[ "${SYNOPKG_OLD_PKGVER}" =~ [[:digit:]]{8}-[[:digit:]]+ ]]; then
  SPK_REV="${SYNOPKG_OLD_PKGVER//[0-9]*-}"
  if [[ "${SPK_REV}" -lt 15 ]]; then
      with_migration
  else
      without_migration
  fi
else
  with_migration
fi
