#!/bin/bash

WEB_DIR="/var/services/web_packages"
# for backwards compatability
if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
	WEB_DIR="/var/services/web"
fi
if [ -z ${SYNOPKG_PKGDEST_VOL} ]; then
	SYNOPKG_PKGDEST_VOL="/volume1"
fi
OCROOT="${WEB_DIR}/${SYNOPKG_PKGNAME}"
DATADIR="${SYNOPKG_PKGDEST_VOL}/@appdata/${SYNOPKG_PKGNAME}/data"
# for backwards compatability
if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
	DATADIR="$(realpath ${WEB_DIR})/${SYNOPKG_PKGNAME}/data"
fi

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

PAGE_ADMIN_CONFIG=$(/bin/cat<<EOF
{
	"step_title": "Configuration de l'administrateur d'ownCloud",
	"items": [{
		"type": "textfield",
		"desc": "Connexion de l'administrateur. Par défaut, 'admin'",
		"subitems": [{
			"key": "wizard_owncloud_admin_username",
			"desc": "Nom d'utilisateur",
			"defaultValue": "admin",
			"validator": {
				"allowBlank": false
			}
		}]
	}, {
		"type": "password",
		"desc": "Mot de passe de l'administrateur. Par défaut, 'admin'",
		"subitems": [{
			"key": "wizard_owncloud_admin_password",
			"desc": "Mot de passe",
			"defaultValue": "admin",
			"validator": {
				"allowBlank": false
			}
		}]
	}, {
		"type": "textfield",
		"desc": "répertoire de données ownCloud",
		"subitems": [{
			"key": "wizard_owncloud_datadirectory",
			"desc": "Répertoire",
			"defaultValue": "$DATADIR",
			"validator": {
				"allowBlank": false,
				"regex": {
					"expr": "/^\\\/volume[0-9]+\\\//",
					"errorText": "Le chemin doit commencer par /volume?/ avec ? le numéro de volume"
				}
			}
		}]
	}]
}, {
	"step_title": "Domaines de confiance ownCloud",
	"items": [{
		"type": "textfield",
		"desc": "Pour accéder à votre serveur ownCloud, vous devez mettre en liste blanche toutes les URL dans vos paramètres, y compris toutes les URL supplémentaires que vous souhaitez utiliser en plus du nom d'hôte actuel.",
		"subitems": [{
			"key": "wizard_owncloud_trusted_domain_1",
			"desc": "Domaine ou adresse IP",
			"emptyText": "localhost"
		}, {
			"key": "wizard_owncloud_trusted_domain_2",
			"desc": "Domaine ou adresse IP",
			"emptyText": "server1.example.com"
		}, {
			"key": "wizard_owncloud_trusted_domain_3",
			"desc": "Domaine ou adresse IP",
			"emptyText": "192.168.1.50"
		}]
	}]
}
EOF
)

main () {
	local install_page=""
	install_page=$(page_append "$install_page" "$PAGE_ADMIN_CONFIG")
	echo "[$install_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
