INSTALL_TARGET_DIR="/var/packages/${SYNOPKG_PKGNAME}/target"

service_save ()
{
    # Save configuration of previous installation in ${INSTALL_TARGET_DIR}/etc (upgrades use ${INSTALL_TARGET_DIR}/var)
    if [ -e "${INSTALL_TARGET_DIR}/etc/Muttrc.local" ]; then
        echo "migrate ${INSTALL_TARGET_DIR}/etc/Muttrc.local to ${INSTALL_TARGET_DIR}/var/Muttrc.local"  >> "${INST_LOG}"
        mv ${INSTALL_TARGET_DIR}/etc/Muttrc.local ${TMP_DIR}/Muttrc.local  >> "${INST_LOG}"
    fi
}
