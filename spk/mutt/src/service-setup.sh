
service_preupgrad ()
{
    # Save configuration
    rm -rf ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${INSTALL_DIR}/etc/Muttrc.local ${TMP_DIR}/${PACKAGE}/Muttrc.local
}

service_postupgrade ()
{
    # Restore configuration
    mv ${TMP_DIR}/${PACKAGE}/Muttrc.local ${INSTALL_DIR}/etc/Muttrc.local
    rm -rf ${TMP_DIR}/${PACKAGE}
}
