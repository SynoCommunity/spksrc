#!/bin/bash

WEB_DIR="/var/services/web_packages"
# for backwards compatability
if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
	WEB_DIR="/var/services/web"
	if [ -z ${SYNOPKG_PKGNAME} ]; then
		SYNOPKG_PKGNAME="owncloud"
	fi
fi
OCROOT="${WEB_DIR}/${SYNOPKG_PKGNAME}"
OC_NEW_VER=$(echo ${SYNOPKG_PKGVER} | cut -d'-' -f1)
OC_OLD_VER=$(echo ${SYNOPKG_OLD_PKGVER} | cut -d'-' -f1)

quote_json () {
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

is_upgrade_possible ()
{
	# ownCloud upgrades only possible from 8.2.11, 9.0.9, 9.1.X, or 10.X.Y
	valid_versions=("8.2.11" "9.0.9" "9.1.*" "10.*.*")
	previous=${OC_OLD_VER}
	for version in "${valid_versions[@]}"; do
		if echo "$previous" | grep -q "$version"; then
			return 0  # Success or true
		fi
	done
	return 1  # Failure or false
}

PAGE_NO_UPDATE=$(/bin/cat<<EOF
{
	"step_title": "Mise à jour incompatible",
	"invalid_next_disabled_v2": true,
	"items": [{
		"type": "textfield",
		"desc": "<strong>AVIS:</strong> La version ${OC_OLD_VER} de ownCloud ne peut pas être mise à jour vers la version ${OC_NEW_VER}. Veuillez désinstaller la version précédente et n'oubliez pas de sauvegarder vos fichiers <code>${OCROOT}/data</code> avant de le faire.",
		"subitems": [{
			"hidden": true,
			"validator": {
				"fn": "{return false;}"
			}
		}]
	}]
}
EOF
)

TEXT_LIMITATIONS=$(/bin/cat<<EOF
<table>
	<tr>
		<td valign="top">1.</td>
		<td valign="top">Les tâches cron ne peuvent pas être gérées pendant le processus de mise à niveau. Nous vous recommandons de les désactiver manuellement avant la mise à niveau.</td>
	</tr>
	<tr>
		<td valign="top">2.</td>
		<td valign="top">Le serveur Web ne peut pas être géré pendant le processus de mise à niveau. Pendant la mise à niveau, le serveur Web sera placé en mode maintenance. Nous vous recommandons d'arrêter Web Station avant la mise à niveau.</td>
	</tr>
	<tr>
		<td valign="top">3.</td>
		<td valign="top">La compatibilité des applications tierces ne peut pas être automatiquement validée pendant le processus de mise à niveau. Veuillez vérifier manuellement la compatibilité des applications avant la mise à niveau, car les applications seront migrées.</td>
	</tr>
</table>
EOF
)

PAGE_LIMITATIONS=$(/bin/cat<<EOF
{
	"step_title": "Limitations de la mise à niveau",
	"items": [{
		"desc": "Veuillez noter les limitations suivantes lors de la mise à jour du package ownCloud:"
	}, {
		"desc": "$(echo $TEXT_LIMITATIONS | quote_json)"
	}]
}
EOF
)

main ()
{
	local upgrade_page=""
	if is_upgrade_possible; then
		upgrade_page=$(page_append "$upgrade_page" "$PAGE_LIMITATIONS")
	else
		upgrade_page=$(page_append "$upgrade_page" "$PAGE_NO_UPDATE")
	fi
	echo "[$upgrade_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
