
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
KIWIX_SERVE="${SYNOPKG_PKGDEST}/bin/kiwix-serve"
CONFIG_FILE="${SYNOPKG_PKGVAR}/kiwix.cfg"
SVC_WRITE_PID=y
SVC_BACKGROUND=y

SHARED_ZIM_FOLDER=${SYNOPKG_PKGVAR}
if [ -r "${CONFIG_FILE}" ]; then
    . "${CONFIG_FILE}"
fi

LIBRARY_FILE="${SHARED_ZIM_FOLDER}/library.xml"
SERVICE_COMMAND="${KIWIX_SERVE} --port=${SERVICE_PORT} --library ${LIBRARY_FILE}"

service_prestart ()
{
    if [ ! -d "${SHARED_ZIM_FOLDER}" ]; then
        echo "Error: Missing shared folder for zim content [${SHARED_ZIM_FOLDER}]."
        exit 1
    fi

    if [ ! -f "${LIBRARY_FILE}" ]; then
        cp ${SYNOPKG_PKGVAR}/empty_library.xml "${LIBRARY_FILE}"
    fi
}

service_postinst ()
{
    sed -e "s|@@_wizard_shared_folder_@@|${SHARE_PATH}|g" -i "${CONFIG_FILE}"
}

service_preupgrade ()
{
    # create file with installer variables on the fly
    if [ ! -e "${INST_VARIABLES}" ]; then
        if [ -e "${CONFIG_FILE}" ]; then
            if [ -z "${SHARE_PATH}" ]; then
                SHARE_PATH=$(cat ${CONFIG_FILE} | grep SHARED_ZIM_FOLDER | cut -d= -f2)
            fi
            if [ -z "${SHARE_NAME}" -a -n "${SHARE_PATH}" ]; then
                SHARE_NAME=$(basename ${SHARE_PATH})
            fi
            echo "Create ${INST_VARIABLES} [SHARE_PATH=${SHARE_PATH}, SHARE_NAME=${SHARE_NAME}]"
            save_wizard_variables
        else
            echo "WARNING: cannot create ${INST_VARIABLES}. Config not found: ${CONFIG_FILE}"
        fi
    else
        echo "Installer variables available"
        cat "${INST_VARIABLES}"
    fi
}
