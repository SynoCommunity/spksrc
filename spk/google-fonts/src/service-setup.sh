

service_postinst ()
{
    # move fonts to share
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        FONTS_FOLDER="${SHARE_PATH}"
        # remove leading and trailing slashes from folder name
        folder=$(echo "${wizard_folder_name}" | sed 's|/$||' | sed 's|^/||')
        if [ -n "${folder}" ]; then
            FONTS_FOLDER="${SHARE_PATH}/${folder}"
            $MKDIR ${FONTS_FOLDER}
        fi
        # save the fonts folder to installer variables (for uninstall)
        echo "FONTS_FOLDER=${FONTS_FOLDER}" >> ${INST_VARIABLES}
        
        echo "Move fonts to ${FONTS_FOLDER}."
        # use rsync since mv might fail if target folder is not empty
        rsync -azh --remove-source-files ${SYNOPKG_PKGDEST}/fonts/* ${FONTS_FOLDER}/
        # rsync does not removes source directories
        $RM ${SYNOPKG_PKGDEST}/fonts
        echo "update imagemagick font type files for ${FONTS_FOLDER}."
        sed -i -e "s|@@install_folder@@/fonts|${FONTS_FOLDER}|g" ${FONTS_FOLDER}/type-*.xml
    fi
}


validate_preuninst ()
{
    if [ "${wizard_delete_data}" = "true" ]; then
        # variables of reload_inst_variables are not available here
        FONTS_FOLDER=$(cat ${INST_VARIABLES} | grep ^FONTS_FOLDER | awk -F'=' '{print $2}')
        if [ -z "${FONTS_FOLDER}" ]; then
            echo "The folder of the installed fonts is not available. You cannot delete the installed fonts (${FONTS_FOLDER})."
            exit 1;
        fi
        if [ ! -e "${FONTS_FOLDER}" ]; then
            echo "The folder of the installed fonts does not exist. It was either moved or deleted. You cannot delete the installed fonts (${FONTS_FOLDER})."
            exit 1;
        fi
    fi
}

service_preuninst ()
{
    if [ "${wizard_delete_data}" = "true" ]; then
        echo "Remove installed fonts folder (${FONTS_FOLDER})"
        $RM "${FONTS_FOLDER}"
    else
        # force deleting DSM 7 package data
        wizard_delete_data=true
    fi
}
