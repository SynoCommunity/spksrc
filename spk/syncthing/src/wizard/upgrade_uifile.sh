#!/bin/sh

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

# Check for major version upgrade from v1.x
check_major_upgrade ()
{
    SYNCTHING="/var/packages/${SYNOPKG_PKGNAME}/target/bin/syncthing"
    if [ -x "${SYNCTHING}" ]; then
        SYNOPKG_PKGVAR="/var/packages/${SYNOPKG_PKGNAME}/var"
        OLD_MAJOR_VER=$(HOME="${SYNOPKG_PKGVAR}" "${SYNCTHING}" --version 2>/dev/null | awk '{print $2}' | cut -d. -f1 | tr -d 'v')
        if [ "${OLD_MAJOR_VER}" = "1" ]; then
            return 0  # true
        fi
    fi
    return 1  # false
}

PAGE_MAJOR_UPGRADE=$(/bin/cat<<EOF
{
    "step_title": "Important: Major Version Upgrade",
    "items": [{
        "desc": "<b>Warning:</b> You are upgrading from Syncthing v1.x to v2.x."
    },{
        "desc": "<b>Database Migration:</b> The database backend has switched from LevelDB to SQLite. On first launch after the upgrade, there will be a migration process which can be lengthy for larger setups."
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
    upgrade_page=""
    if check_major_upgrade; then
        upgrade_page=$(page_append "$upgrade_page" "$PAGE_MAJOR_UPGRADE")
    fi
    upgrade_page=$(page_append "$upgrade_page" "$PAGE_PERMISSIONS")
    echo "[$upgrade_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
