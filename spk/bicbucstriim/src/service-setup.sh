
# Package
PACKAGE="bicbucstriim"
SHORTNAME="bbs"

# Others
WEB_DIR="/var/services/web_packages"
WEB_ROOT="${WEB_DIR}/${SHORTNAME}"

service_save ()
{
    # Save data
    [ -d ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE} ] && ${RM} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}
    echo "Backup existing data to ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}"
    ${MKDIR} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/data
    rsync -aX ${WEB_ROOT}/data/authors ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/data/ 2>&1
    rsync -aX ${WEB_ROOT}/data/titles ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/data/ 2>&1
    rsync -aX ${WEB_ROOT}/data/data.db ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/data/ 2>&1
}

service_restore ()
{
    # Restore data
    echo "Restore previous data from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}"
    rsync -aX -I ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/data/authors ${WEB_ROOT}/data/ 2>&1
    rsync -aX -I ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/data/titles ${WEB_ROOT}/data/ 2>&1
    rsync -aX -I ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/data/data.db ${WEB_ROOT}/data/ 2>&1

    # Remove upgrade backup files
    ${RM} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}
}
