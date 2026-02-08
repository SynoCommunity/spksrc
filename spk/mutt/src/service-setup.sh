
service_save ()
{
    # Save configuration of previous installation in ${SYNOPKG_PKGDEST}/etc (upgrades use ${SYNOPKG_PKGVAR})
    if [ -e "${SYNOPKG_PKGDEST}/etc/Muttrc.local" ]; then
        echo "migrate ${SYNOPKG_PKGDEST}/etc/Muttrc.local to ${SYNOPKG_PKGVAR}/Muttrc.local"
        mv ${SYNOPKG_PKGDEST}/etc/Muttrc.local ${TMP_DIR}/Muttrc.local
    fi
}

