
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
GROUP="sc-restic-rest-server"

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

ARGS=""

if [ "${WIZARD_APPEND_ONLY}" == "true" ]; then
    ARGS="${ARGS} --append-only"
fi
if [ "${WIZARD_PRIVATE_REPOS}" == "true" ]; then
    ARGS="${ARGS} --private-repos"
fi
if [ "${WIZARD_PROMETHEUS}" == "true" ]; then
    ARGS="${ARGS} --prometheus"

    if [ "${WIZARD_PROMETHEUS_NO_AUTH}" == "true" ]; then
        ARGS="${ARGS} --prometheus-no-auth"
    fi
fi

PORT=8500

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/restic-rest-server --listen ":${PORT}" --path ${WIZARD_DATA_VOLUME}/${WIZARD_DATA_DIRECTORY} ${ARGS}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y


service_postinst ()
{
    touch ${wizard_data_volume}/${wizard_data_directory}/.htpasswd
    echo WIZARD_DATA_VOLUME="${wizard_data_volume}"                 >> ${INST_VARIABLES}
    echo WIZARD_DATA_DIRECTORY="${wizard_data_directory}"           >> ${INST_VARIABLES}
    echo WIZARD_APPEND_ONLY="${wizard_append_only}"                 >> ${INST_VARIABLES}
    echo WIZARD_PRIVATE_REPOS="${wizard_private_repos}"             >> ${INST_VARIABLES}
    echo WIZARD_PROMETHEUS="${wizard_prometheus}"                   >> ${INST_VARIABLES}
    echo WIZARD_PROMETHEUS_NO_AUTH="${wizard_prometheus_no_auth}"   >> ${INST_VARIABLES}
}
