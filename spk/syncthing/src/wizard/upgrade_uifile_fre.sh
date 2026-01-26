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
    "step_title": "Important : Mise à jour majeure",
    "items": [{
        "desc": "<b>Attention :</b> Vous effectuez une mise à jour de Syncthing v1.x vers v2.x."
    },{
        "desc": "<b>Migration de la base de données :</b> Le moteur de base de données est passé de LevelDB à SQLite. Au premier lancement après la mise à jour, un processus de migration aura lieu qui peut être long pour les installations importantes."
    },{
        "desc": "Pour plus de détails sur les changements importants, consultez les <a target=\"_blank\" href=\"https://github.com/syncthing/syncthing/releases/tag/v2.0.0\">notes de version Syncthing v2.0.0</a>."
    }]
}
EOF
)

PAGE_PERMISSIONS=$(/bin/cat<<EOF
{
    "step_title": "Permissions et Personnalisation",
    "items": [{
        "desc": "<b>Permissions</b>"
    },{
        "desc": "Les permissions pour ce paquet sont gérées par le groupe <b>'sc-syncthing'</b>. <br>En utilisant File Station, ajoutez ce groupe à chaque dossier auquel Syncthing devrait avoir accès. <br/>Veuillez lire <a target=\"_blank\" href=\"https://github.com/SynoCommunity/spksrc/wiki/Permission-Management\">Gestion des Permissions</a> pour plus de détails."
    },{
        "desc": "<b>Personnalisation</b>"
    },{
        "desc": "Pour une personnalisation avancée, vous pouvez modifier le fichier <code>/var/packages/syncthing/var/options.conf</code>. Par exemple, vous pouvez définir un dossier <code>HOME</code> personnalisé ou des paramètres supplémentaires pour démarrer Syncthing. <br/>Pour modifier le fichier options, vous avez besoin d'un accès <code>SSH</code> avec un utilisateur privilégié. Pour appliquer vos modifications, vous devez redémarrer Syncthing dans le Centre de Paquets."
    },{
        "desc": "<b>Cette mise à jour ne modifie pas votre fichier <code>options.conf</code> existant. Veuillez trouver des exemples supplémentaires dans le fichier fourni <code>options.conf.new</code> dans le même dossier.</b>"
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
