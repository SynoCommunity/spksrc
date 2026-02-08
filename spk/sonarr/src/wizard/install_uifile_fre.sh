#!/bin/bash

function incompatible_upgrade
{
    cat <<EOF >"${SYNOPKG_TEMP_LOGFILE}"
[{
	"step_title": "ATTENTION! Mise à niveau incompatible détectée",
	"invalid_next_disabled_v2": true,
	"items": [{
		"type": "textfield",
		"desc": "<strong style='color:red'>AVERTISSEMENT:</strong> Cette mise à jour est une mise à niveau vers Sonarr v4 à partir de Sonarr v3. Nous avons détecté que vous avez installé Sonarr v2. Nous vous suggérons de mettre à niveau votre installation précédente vers Sonarr v3 avant d'installer cette mise à niveau.<br><br><b>L'installation va s'arrêter.</b>",
		"subitems": [{
			"hidden": true,
			"validator": {
				"fn": "{return false;}"
			}
		}]
	}]
}]
EOF
}

function upgrade_with_config
{
    cat <<EOF >"${SYNOPKG_TEMP_LOGFILE}"
[{
	"step_title": "Télécharger une sauvegarde avant la mise à niveau",
	"items": [{
		"desc": "<strong style='color:red'>IMPORTANT:</strong> Cette mise à jour est une mise à niveau vers Sonarr v4. Nous vous suggérons de télécharger une sauvegarde manuelle par mesure de précaution avant d'installer cette mise à jour.<br><br>Vous pouvez télécharger une sauvegarde via l'interface Web intégrée de Sonarr.<br>Pour ce faire, accédez à <b>System>Backup</b> dans l'interface utilisateur Sonarr.<br><br>Créez une sauvegarde, puis téléchargez une copie de cette sauvegarde avant d'installer cette mise à niveau."
	}]
}, {
	"step_title": "Mettre à jour Sonarr",
	"items": [{
		"desc": "Au premier démarrage de Sonarr cela peut prendre un moment avant que l'interface ne soit disponible !<br><br>Garder Sonarr à jour en utilisant System>Updates dans l'interface Sonarr."
	}]
}, {
	"step_title": "Permissions DSM",
	"items": [{
		"desc": "Merci de lire <a target=\"_blank\" href=\"https://github.com/SynoCommunity/spksrc/wiki/Permission-Management\">Permission Management</a> pour plus de détails."
	}]
}]
EOF
}

function upgrade_no_config
{
    cat <<EOF >"${SYNOPKG_TEMP_LOGFILE}"
[{
	"step_title": "ATTENTION! Risque de perte de données détecté",
	"items": [{
		"desc": "<strong style='color:red'>WARNING:</strong> Cette mise à jour est une mise à niveau vers Sonarr v4. Nous n'avons pas pu trouver votre répertoire AppData à partir de votre installation précédente. Nous vous suggérons de télécharger une sauvegarde manuelle avant d'installer cette mise à jour.<br><br>Vous pouvez télécharger une sauvegarde via l'interface Web intégrée de Sonarr.<br>Pour ce faire, accédez à <b>System>Backup</b> dans l'interface utilisateur Sonarr.<br><br>Créez une sauvegarde, puis téléchargez une copie de cette sauvegarde avant d'installer cette mise à niveau."
	}]
}, {
	"step_title": "Mettre à jour Sonarr",
	"items": [{
		"desc": "Au premier démarrage de Sonarr cela peut prendre un moment avant que l'interface ne soit disponible !<br><br>Garder Sonarr à jour en utilisant System>Updates dans l'interface Sonarr."
	}]
}, {
	"step_title": "Permissions DSM",
	"items": [{
		"desc": "Merci de lire <a target=\"_blank\" href=\"https://github.com/SynoCommunity/spksrc/wiki/Permission-Management\">Permission Management</a> pour plus de détails."
	}]
}]
EOF
}

function new_installation
{
    cat <<EOF >"${SYNOPKG_TEMP_LOGFILE}"
[{
	"step_title": "Mettre à jour Sonarr",
	"items": [{
		"desc": "Au premier démarrage de Sonarr cela peut prendre un moment avant que l'interface ne soit disponible !<br><br>Garder Sonarr à jour en utilisant System>Updates dans l'interface Sonarr."
	}]
}, {
	"step_title": "Permissions DSM",
	"items": [{
		"desc": "Merci de lire <a target=\"_blank\" href=\"https://github.com/SynoCommunity/spksrc/wiki/Permission-Management\">Permission Management</a> pour plus de détails."
	}]
}]
EOF
}

# Set up variables to identify legacy Sonarr versions
LEGACY_SPK_NAME="nzbdrone"
LEGACY_SYNOPKG_PKGDEST="/var/packages/${LEGACY_SPK_NAME}/target"
# Check for legacy package data storage location
if [ -d "/var/packages/${LEGACY_SPK_NAME}/var" ]; then
    LEGACY_SYNOPKG_PKGVAR="/var/packages/${LEGACY_SPK_NAME}/var"
else
    LEGACY_SYNOPKG_PKGVAR="${LEGACY_SYNOPKG_PKGDEST}/var"
fi
LEGACY_CONFIG_DIR="${LEGACY_SYNOPKG_PKGVAR}/.config"
# Some have it stored in the root of package
LEGACY_OLD_CONFIG_DIR="${LEGACY_SYNOPKG_PKGDEST}/.config"

# Check for legacy Sonarr versions
if [ -d "${LEGACY_SYNOPKG_PKGDEST}" ]; then
    if [ -f "${LEGACY_SYNOPKG_PKGDEST}/share/NzbDrone/NzbDrone.exe" ]; then
        # v2 installed
        incompatible_upgrade
    elif [ -f "${LEGACY_SYNOPKG_PKGDEST}/share/Sonarr/Sonarr.exe" ]; then
        # v3 installed
        if [ -d "${LEGACY_CONFIG_DIR}/Sonarr" ]; then
            upgrade_with_config
        elif [ -d "${LEGACY_OLD_CONFIG_DIR}/Sonarr" ]; then
            upgrade_with_config
        else
            upgrade_no_config
        fi
    fi
else
    # no legacy version detected
    new_installation
fi
