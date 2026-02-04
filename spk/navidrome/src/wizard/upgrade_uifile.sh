#!/bin/sh

# Extract version components from SYNOPKG_OLD_PKGVER (format: X.Y.Z-R)
OLD_VERSION="${SYNOPKG_OLD_PKGVER%-*}"
OLD_MAJOR="${OLD_VERSION%%.*}"
OLD_MINOR_PATCH="${OLD_VERSION#*.}"
OLD_MINOR="${OLD_MINOR_PATCH%%.*}"

# Display warning only for upgrades from versions < 0.58.0
# v0.58.0 introduced multi-library support with irreversible schema changes
if [ -n "${OLD_MAJOR}" ] && [ "${OLD_MAJOR}" -eq 0 ] && [ "${OLD_MINOR}" -lt 58 ]; then

cat <<EOF > "${SYNOPKG_TEMP_LOGFILE}"
[{
  "step_title": "Important Update Notice",
  "items": [{
      "desc": "You are upgrading from <b>v${OLD_VERSION}</b> to a version that includes significant changes introduced in <a target=\"_blank\" href=\"https://github.com/navidrome/navidrome/releases/tag/v0.58.0\">Navidrome v0.58.0</a>."
    }, {
      "desc": "<b style=\"color: red\">WARNING:</b> This update includes database schema changes that are <b>NOT reversible</b> by downgrading to a previous version."
    }, {
      "desc": "Before proceeding: <b>BACKUP YOUR DATABASE</b><br/>Location: <code>/var/packages/navidrome/var/navidrome.db</code><br/>Use File Station, SSH, or a scheduled task to create a backup copy."
    }, {
      "desc": "After the update completes, you must run a <b>Full Scan</b> of your music library."
    }, {
      "desc": "<b>New in v0.58.0+:</b> Multi-library support allows organizing multiple music collections with separate permission controls."
    }
  ]
}]
EOF

fi
exit 0
