
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
    sed -e "s|@@_wizard_shared_folder_@@|${wizard_data_volume}/${wizard_data_folder}|g" -i "${CONFIG_FILE}"
}
