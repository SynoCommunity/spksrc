PYTHON_DIR="/var/packages/python312/target/bin"
PYTHON="${PYTHON_DIR}/python3"

APP_DIR="${SYNOPKG_PKGDEST}/share/smartoptimizerui"

PATH="${PYTHON_DIR}:${PATH}"

HOME="${SYNOPKG_PKGVAR}"
TMPDIR="${SYNOPKG_PKGVAR}/tmp"

export PATH
export HOME
export TMPDIR

export SMART_UI_HOST="0.0.0.0"
export SMART_UI_PORT="8788"
export SMART_UI_ENABLE_ACTIONS="1"

export RADARR_OPTIMIZER_SCRIPT="${APP_DIR}/radarr-smart-optimizer.py"
export SONARR_OPTIMIZER_SCRIPT="${APP_DIR}/sonarr-smart-optimizer.py"

export RADARR_OPTIMIZER_STATE="${SYNOPKG_PKGVAR}/data/radarr-state.json"
export SONARR_OPTIMIZER_STATE="${SYNOPKG_PKGVAR}/data/sonarr-state.json"

export SMART_OPTIMIZER_CONTROL="${SYNOPKG_PKGVAR}/config/smart-optimizer-control.json"
export SMART_OPTIMIZER_CONNECTIONS="${SYNOPKG_PKGVAR}/config/smart-optimizer-connections.json"
export SMART_OPTIMIZER_AUTH="${SYNOPKG_PKGVAR}/config/smart-optimizer-auth.json"

export SMART_OPTIMIZER_CACHE_DIR="${SYNOPKG_PKGVAR}/data"
export SMART_OPTIMIZER_UPDATE_DIR="${SYNOPKG_PKGVAR}/updates"

export SMART_UI_ASSET_DIR="${APP_DIR}/assets"

export SMART_OPTIMIZER_NATIVE_SPK="1"
export SMART_OPTIMIZER_VERSION="2.1.0"
export SMART_OPTIMIZER_PACKAGE_VERSION="2.1.0"

SVC_BACKGROUND=y
SVC_WRITE_PID=y
SVC_CWD="${APP_DIR}"

SERVICE_COMMAND="${PYTHON} ${APP_DIR}/smart-optimizer-ui.py"

service_postinst ()
{
    mkdir -p \
        "${SYNOPKG_PKGVAR}/config" \
        "${SYNOPKG_PKGVAR}/data" \
        "${SYNOPKG_PKGVAR}/tmp" \
        "${SYNOPKG_PKGVAR}/updates"
}
