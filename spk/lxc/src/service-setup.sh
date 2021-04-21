#! /bin/sh

. "$(dirname $0)/utils"

VAR_LIB_LXC="${SYNOPKG_PKGDEST}/var/lib/lxc"
LXC_USER=sc-lxc

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

    save_wizard_settings

    create_lxc_share

    aa_profiles_activate
}

service_preuninst ()
{
    aa_profiles_deactivate

    remove_lxc_share
}

create_lxc_share ()
{
    load_settings

    if ! synoshare --get "${LXC_SHARE_NAME}" 2>/dev/null; then
        echo "Creating LXC share ${LXC_SHARE_PATH}"
        if ! synoshare --add "${LXC_SHARE_NAME}" "LXC data" "${LXC_SHARE_PATH}" "" "${LXC_USER}" "" 0 0; then
                echo "Failed to create LXC share ${LXC_SHARE_PATH}"
                exit 1
        fi
    else
        echo "Share \"${LXC_SHARE_NAME}\" already exists"
        # TODO: Check that the full path matches what we expect

        echo "Giving \"${LXC_USER}\" RW permissions for \"${LXC_SHARE_NAME}\""
        synoshare --setuser "${LXC_SHARE_NAME}" RW + "${LXC_USER}"
    fi

    echo "Create bind mount ${VAR_LIB_LXC} -> ${LXC_SHARE_PATH}"
    mount --bind "${LXC_SHARE_PATH}" ${VAR_LIB_LXC}
}

remove_lxc_share ()
{
    load_settings

    echo "Unmount bind mount ${VAR_LIB_LXC} -> ${LXC_SHARE_PATH}"
    umount ${VAR_LIB_LXC}

    if [ "${wizard_lxc_delete_share}" = "true" ]; then
        echo "Removing LXC share ${LXC_SHARE_PATH}"
        synoshare --del TRUE ${LXC_SHARE_NAME}
    else
        echo "Keeping LXC share ${LXC_SHARE_PATH}"
    fi
   
}
