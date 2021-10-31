PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
GROUP="sc-minio"

INST_ETC="/var/packages/${SYNOPKG_PKGNAME}/etc"
INST_VARIABLES="${INST_ETC}/installer-variables"

# Reload wizard variables stored by postinst
if [ -r "${INST_VARIABLES}" ]; then
    # we cannot source the file to reload the variables, when values have special characters like <, >, ...
    for _line in $(cat "${INST_VARIABLES}"); do
        _key="$(echo ${_line} | awk -F'=' '{print $1}')"
        _value="$(echo ${_line} | awk -F'=' '{print $2}')"
        declare "${_key}=${_value}"
    done
fi

export MINIO_ROOT_USER="${WIZARD_ROOT_USER}"
export MINIO_ROOT_PASSWORD="${WIZARD_ROOT_PASSWORD}"
export HOME="${SYNOPKG_PKGVAR}"

CONSOLE_PORT=9001

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/minio server --quiet --console-address :${CONSOLE_PORT} --anonymous ${WIZARD_DATA_VOLUME}/${WIZARD_DATA_DIRECTORY}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y


service_postinst ()
{
    echo WIZARD_DATA_VOLUME="${wizard_data_volume}"         >> ${INST_VARIABLES}
    echo WIZARD_DATA_DIRECTORY="${wizard_data_directory}"   >> ${INST_VARIABLES}
    echo WIZARD_ROOT_USER="${wizard_root_user}"             >> ${INST_VARIABLES}
    echo WIZARD_ROOT_PASSWORD="${wizard_root_password}"     >> ${INST_VARIABLES}
}

