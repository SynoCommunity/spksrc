# Loom service definition for SynoCommunity / spksrc.
#
# Loom is a single static binary. All mutable state (loom.json config, the
# sqlite database under data/loom.db, caches and logs) lives under one writable
# directory. ${SYNOPKG_PKGVAR} is preserved across package upgrades by DSM, so
# pointing both LOOM_CONFIG_DIR and LOOM_DATA_DIR at it gives upgrade-safe,
# self-contained persistence.

LOOM="${SYNOPKG_PKGDEST}/bin/loom"

export LOOM_CONFIG_DIR="${SYNOPKG_PKGVAR}"
export LOOM_DATA_DIR="${SYNOPKG_PKGVAR}"
export LOOM_HTTP_ADDR=":${SERVICE_PORT:-8989}"
# Some Go libraries fall back to $HOME for caches; keep them inside our var dir.
export HOME="${SYNOPKG_PKGVAR}"

SERVICE_COMMAND="${LOOM} serve"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_prestart ()
{
    # Loom opens ${LOOM_CONFIG_DIR}/data/loom.db on boot; make sure the
    # directory exists and is owned by the package service user.
    mkdir -p "${SYNOPKG_PKGVAR}/data"
}
