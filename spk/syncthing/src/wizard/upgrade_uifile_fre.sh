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
    "step_title": "Important : Mise \u00e0 jour majeure",
    "items": [{
        "desc": "<b style=\\"color: red\\">Attention : Vous effectuez une mise \u00e0 jour de Syncthing v1.x vers v2.x.</b>"
    },{
        "desc": "<b>Migration de la base de donn\u00e9es :</b> Le moteur de base de donn\u00e9es est pass\u00e9 de LevelDB \u00e0 SQLite. Au premier lancement apr\u00e8s la mise \u00e0 jour, un processus de migration aura lieu qui peut \u00eatre long pour les installations importantes."
    },{
        "desc": "<b style=\\"color: red\\">N'interrompez pas le processus de migration.</b>"
    },{
        "desc": "<b>Recommandation :</b> Sauvegardez votre configuration et base de donn\u00e9es Syncthing avant de continuer."
    },{
        "desc": "Pour plus de d\u00e9tails sur les changements importants, consultez les <a target=\"_blank\" href=\"https://github.com/syncthing/syncthing/releases/tag/v2.0.0\">notes de version Syncthing v2.0.0</a>."
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
        "desc": "Les permissions pour ce paquet sont g\u00e9r\u00e9es par le groupe <b>'sc-syncthing'</b>. <br>En utilisant File Station, ajoutez ce groupe \u00e0 chaque dossier auquel Syncthing devrait avoir acc\u00e8s. <br/>Veuillez lire <a target=\"_blank\" href=\"https://github.com/SynoCommunity/spksrc/wiki/Permission-Management\">Gestion des Permissions</a> pour plus de d\u00e9tails."
    },{
        "desc": "<b>Personnalisation</b>"
    },{
        "desc": "Pour une personnalisation avanc\u00e9e, vous pouvez modifier le fichier <code>/var/packages/syncthing/var/options.conf</code>. Par exemple, vous pouvez d\u00e9finir un dossier <code>HOME</code> personnalis\u00e9 ou des param\u00e8tres suppl\u00e9mentaires pour d\u00e9marrer Syncthing. <br/>Pour modifier le fichier options, vous avez besoin d'un acc\u00e8s <code>SSH</code> avec un utilisateur privil\u00e9gi\u00e9. Pour appliquer vos modifications, vous devez red\u00e9marrer Syncthing dans le Centre de Paquets."
    },{
        "desc": "<b>Cette mise \u00e0 jour ne modifie pas votre fichier <code>options.conf</code> existant. Veuillez trouver des exemples suppl\u00e9mentaires dans le fichier fourni <code>options.conf.new</code> dans le m\u00eame dossier.</b>"
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
