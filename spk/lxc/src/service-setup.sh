#! /bin/sh

. "$(dirname $0)/aa-profiles"

service_postinst ()
{
    echo "[begin] Linking to AppArmor tunables"
    AA_TUNABLES_DIR=/etc/apparmor.d/tunables/
    for aa_tunable in $(ls ${AA_TUNABLES_DIR}); do
        LINK_NAME=${SYNOPKG_PKGDEST}${AA_TUNABLES_DIR}$aa_tunable
        LINK_TARGET=${AA_TUNABLES_DIR}$aa_tunable
        echo "Create link ${LINK_NAME} -> ${LINK_TARGET}"
        ln -s "${LINK_TARGET}" "${LINK_NAME}"
    done
    echo "[end]   Linking to AppArmor tunables"

    aa_save_wizard_settings
    aa_profiles_activate
}

service_preuninst ()
{
    aa_profiles_deactivate
}
