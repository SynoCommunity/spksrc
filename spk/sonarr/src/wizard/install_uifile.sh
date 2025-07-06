#!/bin/bash

function incompatible_upgrade
{
    cat <<EOF >"${SYNOPKG_TEMP_LOGFILE}"
[{
	"step_title": "ATTENTION! Incompatible upgrade detected",
	"invalid_next_disabled_v2": true,
	"items": [{
		"type": "textfield",
		"desc": "<strong style='color:red'>WARNING:</strong> This update is an upgrade to Sonarr v4 from Sonarr v3. We have detected that you have Sonarr v2 installed. We suggest that you upgrade your previous installation to Sonarr v3 before installing this upgrade.<br><br><b>Installation will abort.</b>",
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
	"step_title": "Download a backup before upgrading",
	"items": [{
		"desc": "<strong style='color:red'>IMPORTANT:</strong> This update is an upgrade to Sonarr v4. We suggest that you download a manual backup as a precautionary measure before installing this update.<br><br>You can download a backup via Sonarr's built-in web-interface.<br>To do this, navigate to <b>System>Backup</b> in the Sonarr UI.<br><br>Create a backup and then download a copy of that backup before installing this upgrade."
	}]
}, {
	"step_title": "Starting and updating Sonarr",
	"items": [{
		"desc": "The first time Sonarr is started it might take a few moments for the interface to become available!<br><br>Keep Sonarr up-to-date by using Sonarr's built-in updater.<br>Navigate to System>Updates in the Sonarr UI."
	}]
}, {
	"step_title": "DSM Permissions",
	"items": [{
		"desc": "Please read <a target=\"_blank\" href=\"https://github.com/SynoCommunity/spksrc/wiki/Permission-Management\">Permission Management</a> for details."
	}]
}]
EOF
}

function upgrade_no_config
{
    cat <<EOF >"${SYNOPKG_TEMP_LOGFILE}"
[{
	"step_title": "ATTENTION! Data loss risk detected",
	"items": [{
		"desc": "<strong style='color:red'>WARNING:</strong> This update is an upgrade to Sonarr v4. We could not find your AppData directory from your previous installation. We suggest that you download a manual backup before installing this update.<br><br>You can download a backup via Sonarr's built-in web-interface.<br>To do this, navigate to <b>System>Backup</b> in the Sonarr UI.<br><br>Create a backup and then download a copy of that backup before installing this upgrade."
	}]
}, {
	"step_title": "Starting and updating Sonarr",
	"items": [{
		"desc": "The first time Sonarr is started it might take a few moments for the interface to become available!<br><br>Keep Sonarr up-to-date by using Sonarr's built-in updater.<br>Navigate to System>Updates in the Sonarr UI."
	}]
}, {
	"step_title": "DSM Permissions",
	"items": [{
		"desc": "Please read <a target=\"_blank\" href=\"https://github.com/SynoCommunity/spksrc/wiki/Permission-Management\">Permission Management</a> for details."
	}]
}]
EOF
}

function new_installation
{
    cat <<EOF >"${SYNOPKG_TEMP_LOGFILE}"
[{
	"step_title": "Starting and updating Sonarr",
	"items": [{
		"desc": "The first time Sonarr is started it might take a few moments for the interface to become available!<br><br>Keep Sonarr up-to-date by using Sonarr's built-in updater.<br>Navigate to System>Updates in the Sonarr UI."
	}]
}, {
	"step_title": "DSM Permissions",
	"items": [{
		"desc": "Please read <a target=\"_blank\" href=\"https://github.com/SynoCommunity/spksrc/wiki/Permission-Management\">Permission Management</a> for details."
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
