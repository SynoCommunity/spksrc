
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
SVC_USER="sc-${SYNOPKG_PKGNAME}"
GROUP="sc-${SYNOPKG_PKGNAME}"

ENV_VARIABLES="${SYNOPKG_PKGVAR}/environment-variables"
CRED_DIR="${SYNOPKG_PKGVAR}/credentials"
LOG_DIR="${SYNOPKG_PKGVAR}/logs"

API_PORT=9200
CONSOLE_PORT=9201

SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
   # The admin credentials from the wizard are written to files that only the
   # service user can read (RUSTFS_ACCESS_KEY_FILE / RUSTFS_SECRET_KEY_FILE),
   # not into installer-variables which DSM keeps readable. On an upgrade the
   # wizard does not run again, so the existing files are kept untouched.
   if [ -n "${wizard_root_user}" ] && [ -n "${wizard_root_password}" ]; then
      mkdir -p "${CRED_DIR}"
      ( umask 077
        printf '%s' "${wizard_root_user}"     > "${CRED_DIR}/access_key"
        printf '%s' "${wizard_root_password}" > "${CRED_DIR}/secret_key" )
      chown -R "${SVC_USER}:${GROUP}" "${CRED_DIR}" 2>/dev/null || true
      chmod 700 "${CRED_DIR}"
      chmod 600 "${CRED_DIR}/access_key" "${CRED_DIR}/secret_key"
   fi

   mkdir -p "${LOG_DIR}"
   chown "${SVC_USER}:${GROUP}" "${LOG_DIR}" 2>/dev/null || true
}

# Read KEY=value lines from a file and export them. Empty lines and lines
# starting with # are ignored.
export_variables_from_file ()
{
   if [ -n "$1" ] && [ -r "$1" ]; then
      while read -r _line; do
         if [ "$(echo "${_line}" | grep -v '^[[:space:]]*#')" != "" ]; then
            _key="$(echo "${_line}" | cut --fields=1 --delimiter==)"
            _value="$(echo "${_line}" | cut --fields=2- --delimiter==)"
            export "${_key}=${_value}"
         fi
      done < "$1"
   fi
}

service_prestart ()
{
   export HOME="${SYNOPKG_PKGVAR}"
   export RUSTFS_ADDRESS=":${API_PORT}"
   export RUSTFS_CONSOLE_ENABLE=true
   export RUSTFS_CONSOLE_ADDRESS=":${CONSOLE_PORT}"
   export RUSTFS_ACCESS_KEY_FILE="${CRED_DIR}/access_key"
   export RUSTFS_SECRET_KEY_FILE="${CRED_DIR}/secret_key"
   export RUSTFS_OBS_LOG_DIRECTORY="${LOG_DIR}"

   # A typical NAS has a single HDD volume. Under sustained backup load the
   # built-in 5 s drive probes time out, RustFS marks its only drive faulty
   # and answers 503 / SlowDown ("write quorum unavailable"). The high_latency
   # profile plus the related budgets below avoid this. See the upstream
   # docs/operations/drive-timeout-tuning.md. Override any of these in the
   # environment-variables file below.
   export RUSTFS_DRIVE_TIMEOUT_PROFILE=high_latency
   export RUSTFS_DRIVE_ACTIVE_CHECK_TIMEOUT_SECS=30
   export RUSTFS_DRIVE_SUSPECT_FAILURE_THRESHOLD=10
   export RUSTFS_OBJECT_DISK_WRITE_STALL_TIMEOUT=120
   export RUSTFS_OBJECT_DISK_PERMIT_WAIT_TIMEOUT=30

   # User overrides take precedence over the defaults above.
   export_variables_from_file "${ENV_VARIABLES}"

   SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/rustfs server ${SHARE_PATH}"
}
