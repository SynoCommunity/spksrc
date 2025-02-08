
# Package
PACKAGE="cops"

# Others
WEB_DIR="/var/services/web_packages"
WEB_ROOT="${WEB_DIR}/${PACKAGE}"

service_postinst ()
{
    # Initialize or update configuration file based on user preferences.
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        CFG_FILE="${WEB_ROOT}/config_local.php"
        DEFAULT_CFG_FILE="${SYNOPKG_PKGDEST}/web/config_local.php.synology"
        # Create a default configuration file
        if [ ! -f "${CFG_FILE}" ]; then
            cp "${DEFAULT_CFG_FILE}" "${CFG_FILE}"
            url_rewriting=$([ "${wizard_use_url_rewriting}" = "true" ] && echo "1" || echo "0")
            sed -i -e "s|@calibre_dir@|${SHARE_PATH:=/volume1/calibre}/|g" ${CFG_FILE}
            sed -i -e "s|@cops_title@|${wizard_cops_title:=COPS}|g" ${CFG_FILE}
            sed -i -e "s|@use_url_rewriting@|${url_rewriting:=0}|g" ${CFG_FILE}
            chmod ga+w "${CFG_FILE}"
        fi
    fi
}

service_save ()
{
    # Save some stuff
    [ -d ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE} ] && ${RM} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}
    echo "Backup existing data to ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}"
    ${MKDIR} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/web
    # Save cops configuration files
    rsync -aX ${WEB_ROOT}/config_local.php ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/web/ 2>&1
    rsync -aX ${WEB_ROOT}/.htaccess ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/web/ 2>&1
}

service_restore ()
{
    if [ -f "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/web/config_local.php" ]; then
        # Restore some stuff
        echo "Restore previous data from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}"
        # Restore cops configuration file
        rsync -aX -I ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/web/config_local.php ${WEB_ROOT}/config_local.php 2>&1
    else
        # Backup missing, re-initialise default values
        CFG_FILE="${WEB_ROOT}/config_local.php"
        DEFAULT_CFG_FILE="${SYNOPKG_PKGDEST}/web/config_local.php.synology"
        if [ ! -f "${CFG_FILE}" ]; then
            echo "Backup data missing, re-initialising default values"
            # Create a default configuration file
            cp "${DEFAULT_CFG_FILE}" "${CFG_FILE}"
            url_rewriting=$([ "${wizard_use_url_rewriting}" = "true" ] && echo "1" || echo "0")
            sed -i -e "s|@calibre_dir@|${SHARE_PATH:=/volume1/calibre}/|g" ${CFG_FILE}
            sed -i -e "s|@cops_title@|${wizard_cops_title:=COPS}|g" ${CFG_FILE}
            sed -i -e "s|@use_url_rewriting@|${url_rewriting:=0}|g" ${CFG_FILE}
            chmod ga+w "${CFG_FILE}"
        fi
    fi
    if [ -f "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/web/.htaccess" ]; then
        # Check if the .htaccess file has been modified
        if [ -f ${WEB_ROOT}/.htaccess ]; then
            SRC_FILE=${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/web/.htaccess
            DST_FILE=${WEB_ROOT}/.htaccess
            OUTPUT_FILE=${WEB_ROOT}/.htaccess.diff
            DIFFERENCES=$(diff "$SRC_FILE" "$DST_FILE")
            if [ -n "$DIFFERENCES" ]; then
                # Write the differences to the output file
                echo "$DIFFERENCES" > "$OUTPUT_FILE"
                echo "Modifications to .htaccess file detected. Details saved to $OUTPUT_FILE"
            fi
        fi
    fi

    # Remove upgrade backup files
    ${RM} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}
}
