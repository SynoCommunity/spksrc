#!/bin/bash

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

# Get the current installed syncthing version from the binary
SYNCTHING="/var/packages/${SYNOPKG_PKGNAME}/target/bin/syncthing"
SYNOPKG_PKGVAR="/var/packages/${SYNOPKG_PKGNAME}/var"

OLD_MAJOR_VER=""
if [ -x "${SYNCTHING}" ]; then
    CUR_VER=$(HOME="${SYNOPKG_PKGVAR}" "${SYNCTHING}" --version 2>/dev/null | awk '{print $2}' | cut -d'-' -f1)
    OLD_MAJOR_VER=$(echo "${CUR_VER}" | cut -d. -f1 | tr -d 'v')
fi

PAGE_MAJOR_UPGRADE=$(/bin/cat<<EOF
{
    "step_title": "Important: Major Version Upgrade",
    "items": [{
        "desc": "<b style=\\"color: red\\">Warning: You are upgrading from Syncthing v1.x to v2.x.</b>"
    },{
        "desc": "<b>Database Migration:</b> The database backend has switched from LevelDB to SQLite. On first launch after the upgrade, there will be a migration process which can be lengthy for larger setups."
    },{
        "desc": "<b style=\\"color: red\\">Do not interrupt the migration process.</b>"
    },{
        "desc": "<b>Recommendation:</b> Backup your Syncthing configuration and database before proceeding."
    },{
        "desc": "For full details on breaking changes, see the <a target=\"_blank\" href=\"https://github.com/syncthing/syncthing/releases/tag/v2.0.0\">Syncthing v2.0.0 release notes</a>."
    }]
}
EOF
)

PAGE_PERMISSIONS=$(/bin/cat<<EOF
{
    "step_title": "Permissions and Customization",
    "items": [{
        "desc": "<b>Permissions</b>"
    },{
        "desc": "Permissions for this package are handled by the <b>'sc-syncthing'</b> group. <br>Using File Station, add this group to every folder Syncthing should be allowed to access. <br/>Please read <a target=\"_blank\" href=\"https://github.com/SynoCommunity/spksrc/wiki/Permission-Management\">Permission Management</a> for details."
    },{
        "desc": "<b>Customization</b>"
    },{
        "desc": "For advanced customization you can edit the file <code>/var/packages/syncthing/var/options.conf</code>. For example, you can define a custom <code>HOME</code> folder or additional parameters to start Syncthing with. <br/>To modify the options file, you need <code>SSH</code> access with a privileged user. To apply your modifications, you have to restart Syncthing in the Package Center."
    },{
        "desc": "<b>This update does not modify your existing <code>options.conf</code> file. Please find additional examples in the provided file <code>options.conf.new</code> in the same folder.</b>"
    }]
}
EOF
)

main ()
{
    local wizard_pages=""

    # Show major upgrade warning for v1.x to v2.x upgrades
    if [ "${OLD_MAJOR_VER}" = "1" ]; then
        wizard_pages=$(page_append "${wizard_pages}" "${PAGE_MAJOR_UPGRADE}")
    fi

    # Always show the permissions page
    wizard_pages=$(page_append "${wizard_pages}" "${PAGE_PERMISSIONS}")

    echo "[${wizard_pages}]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
