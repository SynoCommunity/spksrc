#!/bin/sh

# Extract version components from SYNOPKG_OLD_PKGVER (format: X.Y.Z-R)
OLD_VERSION="${SYNOPKG_OLD_PKGVER%-*}"
OLD_MAJOR="${OLD_VERSION%%.*}"
OLD_MINOR_PATCH="${OLD_VERSION#*.}"
OLD_MINOR="${OLD_MINOR_PATCH%%.*}"

# Display wizard only for upgrades from versions < 2.1.0
# v2.1.0 introduced the built-in monitoring dashboard
if [ -n "${OLD_MAJOR}" ] && [ "${OLD_MAJOR}" -eq 2 ] && [ "${OLD_MINOR}" -lt 1 ]; then

cat <<EOF > "${SYNOPKG_TEMP_LOGFILE}"
[{
    "step_title": "Nouveau tableau de bord",
    "items": [{
        "desc": "Cette mise à jour remplace l'éditeur de configuration par un tableau de bord de surveillance intégré affichant les statistiques DNS en temps réel.<br><br>Définissez vos identifiants ci-dessous. Laissez le mot de passe vide pour désactiver l'authentification.<br>Le tableau de bord sera accessible sur le port 8153."
    }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_ui_user",
            "desc": "Nom d'utilisateur",
            "defaultValue": "admin",
            "validator": {
                "allowBlank": false,
                "minLength": 1
            }
        }]
    }, {
        "type": "password",
        "subitems": [{
            "key": "wizard_ui_pass",
            "desc": "Mot de passe",
            "defaultValue": "",
            "validator": {
                "allowBlank": true
            }
        }]
    }, {
        "desc": "Votre configuration DNS existante sera préservée."
    }]
}]
EOF

fi
exit 0
