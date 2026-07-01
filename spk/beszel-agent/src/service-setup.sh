export PATH="/usr/local/bin:$PATH"

ENV_FILE="${SYNOPKG_PKGVAR}/environment.txt"


export_variables_from_file ()
{
    if [ -n "$1" ] && [ -r "$1" ]; then
        while IFS= read -r _line; do
            if [ -z "${_line}" ] || [ "${_line#\#}" != "${_line}" ]; then
                continue
            fi
            IFS=';'
            set -- ${_line}
            IFS=' '
            for _item in "$@"; do
                _item="${_item#"${_item%%[![:space:]]*}"}"
                _item="${_item%"${_item##*[![:space:]]}"}"
                case "${_item}" in
                    ""|"#"*)
                        continue
                        ;;
                    *"="*)
                        _key="${_item%%=*}"
                        _value="${_item#*=}"
                        export "${_key}=${_value}"
                        ;;
                esac
            done
        done < "$1"
    fi
}

export_variables_from_file "${ENV_FILE}"

BESZEL_AGENT="${SYNOPKG_PKGDEST}/bin/beszel-agent"
SERVICE_COMMAND="${BESZEL_AGENT}"

SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
    printf 'SKIP_SYSTEMD=true\n' > "${ENV_FILE}"

    if [ -n "${wizard_pub_key}" ]; then
        printf 'KEY=%s\n' "${wizard_pub_key}" >> "${ENV_FILE}"
    fi

    if [ -n "${wizard_extra_fs}" ]; then
        printf 'EXTRA_FILESYSTEMS=%s\n' "${wizard_extra_fs}" >> "${ENV_FILE}"
    fi

    if [ -n "${wizard_smart_devices}" ]; then
        printf 'SMART_DEVICES=%s\n' "${wizard_smart_devices}" >> "${ENV_FILE}"
    fi

    if [ -n "${wizard_extra_env}" ]; then
        printf '%s\n' "${wizard_extra_env}" >> "${ENV_FILE}"
    fi
}