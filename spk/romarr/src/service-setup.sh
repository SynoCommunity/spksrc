# ROMarr service definition, sourced by the spksrc installer and start-stop-status scripts.
# shellcheck shell=sh disable=SC2034  # the SVC_* and SERVICE_* names are read by those scripts

PYTHON_DIR="/var/packages/python312/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python3"
ROMARR_HOME="${SYNOPKG_PKGDEST}/share/romarr"
ENV_FILE="${SYNOPKG_PKGVAR}/romarr.env"

# Everything ROMarr writes lives in the package's var folder, which DSM keeps
# across upgrades: the settings file (API key, password hash, history), the
# installed ROM Hub plugins and the library backend state.
export ROMARR_DATA="${SYNOPKG_PKGVAR}/romarr.json"
export ROM_HUB_HOME="${SYNOPKG_PKGVAR}/rom-hub"
export ROMARR_BACKENDS_DIR="${SYNOPKG_PKGVAR}/backends"
export ROMARR_PORT="${SERVICE_PORT}"
export PYTHONUNBUFFERED=1
export PYTHONDONTWRITEBYTECODE=1

# romarr.env holds the library path the installer chose, plus anything the
# operator adds (ROMARR_PASSWORD, PROWLARR_URL, DAT_PATH, ...). Plain
# KEY=value lines only; nothing in it is executed.
if [ -r "${ENV_FILE}" ]; then
    while IFS='=' read -r key value; do
        case "${key}" in
            ''|\#*) continue ;;
            *[!A-Za-z0-9_]*) continue ;;
        esac
        export "${key}=${value}"
    done < "${ENV_FILE}"
fi

SVC_BACKGROUND=y
SVC_WRITE_PID=y
SVC_CWD="${ROMARR_HOME}"

SERVICE_COMMAND="${PYTHON} -m romarr"

service_postinst ()
{
    install_python_virtualenv
    # The wheelhouse ships every wheel ROMarr needs: install without PyPI.
    WHEELS_OFFLINE=1 install_python_wheels

    mkdir -p "${ROM_HUB_HOME}" "${ROMARR_BACKENDS_DIR}"

    # Written on a fresh install only: ROMarr copies LIBRARY_PATH into its own
    # settings on first start and the Settings page owns it after that.
    if [ ! -e "${ENV_FILE}" ]; then
        {
            echo "# ROMarr environment, read at every start. KEY=value per line."
            echo "LIBRARY_PATH=${SHARE_PATH}"
            echo "LIBRARY_KIND=folder"
        } > "${ENV_FILE}"
        chmod 600 "${ENV_FILE}"
    fi
}
