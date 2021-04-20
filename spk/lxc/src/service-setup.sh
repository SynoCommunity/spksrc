AA_PARSER_BIN=${SYNOPKG_PKGDEST}/sbin/apparmor_parser
AA_PARSER="${AA_PARSER_BIN} --config-file ${SYNOPKG_PKGDEST}/etc/apparmor/parser.conf"

AA_PROFILE_LXC_START="${SYNOPKG_PKGDEST}/etc/apparmor.d/usr.bin.lxc-start"

service_postinst ()
{
    echo "[begin] Linking to AppArmor tunables"
    AA_TUNABLES_DIR=/etc/apparmor.d/tunables/
    for aa_tunable in $(ls ${AA_TUNABLES_DIR}); do
        LINK_NAME=${SYNOPKG_PKGDEST}${AA_TUNABLES_DIR}$aa_tunable
        LINK_TARGET=${AA_TUNABLES_DIR}$aa_tunable
        echo "Create link ${LINK_NAME} -> ${LINK_TARGET}"
        ln -s ${LINK_TARGET} ${LINK_NAME}
    done
    echo "[end]   Linking to AppArmor tunables"

    if [ -x ${AA_PARSER_BIN} ]; then
        echo "Updating AppArmor profile"
        ${AA_PARSER} -r -C ${AA_PROFILE_LXC_START}
    else
        echo "We do not have an up-to-date AppArmor parser"
        echo "LXC containers will have to run unconfined"
    fi
}

service_preuninst ()
{
    if [ -x ${AA_PARSER_BIN} ]; then
        echo "Removing AppArmor profile"
        ${AA_PARSER} -R ${AA_PROFILE_LXC_START}
    else
        echo "There is no AppArmor profile to remove"
    fi
}
