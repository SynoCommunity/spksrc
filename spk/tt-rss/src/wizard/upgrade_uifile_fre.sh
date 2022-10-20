#!/bin/bash

function with_migration
{
  cat <<EOF >"${SYNOPKG_TEMP_LOGFILE}"
[ {
  "step_title": "Migration de la base de donnée de tt-rss",
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
      } ]
    }, {
      "type": "password",
      "desc": "Saisissez les mot de passes root de vos installations Maria DB:",
      "subitems": [ {
        "key": "wizard_mariadb5_password_root",
        "desc": "Maria DB 5"
      }, {
        "key": "wizard_mysql_password_root",
        "desc": "Maria DB 10"
      } ]
    }, {
      "type": "password",
      "desc": "Un nouvel utilisateur 'ttrss' va être créé. Saisissez un mot de passe pour l'utilisateur 'ttrss'.",
      "subitems": [ {
        "key": "wizard_mysql_password_ttrss",
        "desc": "Mot de passe Ttrss"
      } ]
    } ]
  }, {
    "step_title": "WebStation PHP Configuration",
    "items": [ {
      "desc": "Tiny Tiny RSS requiert que les extensions PHP suivantes soient activ&eacute;es pour le profil PHP courant (configurables dans <code>Web Station</code> &gt; <code>Param&egrave;tres PHP</code> dans l'onglet  <code>Param&egrave;tres de serveur par d&eacute;faut</code>):<br /><ul><li><code>curl</code></li><li><code>gd</code></li><li><code>intl</code></li><li><code>mysqli</code></li><li><code>pdo_mysql</code></li></ul>"
    } ]
  }
]  
EOF
}

function without_migration
{
  cat <<EOF >"${SYNOPKG_TEMP_LOGFILE}"
[ {
  "step_title": "WebStation PHP Configuration",
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
  }, {
    "desc": "Tiny Tiny RSS requiert que les extensions PHP suivantes soient activ&eacute;es pour le profil PHP courant (configurables dans <code>Web Station</code> &gt; <code>Param&egrave;tres PHP</code> dans l'onglet  <code>Param&egrave;tres de serveur par d&eacute;faut</code>):"
  }, {
    "desc": "<ul><li><code>curl</code></li><li><code>gd</code></li><li><code>intl</code></li><li><code>mysqli</code></li><li><code>pdo_mysql</code></li></ul>"
  } ]
} ]
EOF
}

if [[ "$SYNOPKG_OLD_PKGVER" =~ [[:digit:]]{8}-[[:digit:]]+ ]]; then
  SPK_REV="${SYNOPKG_OLD_PKGVER//[0-9]*-}"
  if [[ "${SPK_REV}" -lt 15 ]]; then
      with_migration
  else
      without_migration
  fi
else
  with_migration
fi

exit 0