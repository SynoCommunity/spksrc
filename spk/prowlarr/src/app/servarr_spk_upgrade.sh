#!/bin/sh
# ------------------------------------------------------------
# Servarr SPK Updater (Synology) — Prowlarr / Radarr / Lidarr
# Called by app with:
#   $1 = PID of running app
#   $2 = Update temp dir (already extracted)
#   $3 = Path to running executable (…/share/<App>/bin/<App>)
#   $4..$N = flags (e.g., /data=..., /nobrowser, etc.)
#
# Script log -> <DATA_DIR>/UpdateLogs/YYYY.MM.DD-HH.MM.txt
# App runtime -> <HOME_DIR>/<app>.log
# PID file    -> <DATA_DIR>/<app>.pid
#
# Exit codes:
#   0 success | 3 start failed | 4 dest not writable
#   5 source missing | 6 bin guard failed | 9 bad target exe
# ------------------------------------------------------------

set -eu

# ---------- Required args ----------
PID="${1:?need PID}"
UPDATE_DIR="${2:?need UpdateDir}"
TARGET_EXE="${3:?need TargetExe}"
shift 3
RAW_FLAGS="$*"

# ---------- Helpers ----------
log_file=""
log() { printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >>"$log_file"; }
die() { log "ERROR: $*"; exit "${2:-1}"; }

# ---------- Infer app from TARGET_EXE ----------
BIN_DIR="$(dirname "$TARGET_EXE")"              # …/share/<App>/bin
APP_DIR="$(basename "$(dirname "$BIN_DIR")")"   # Prowlarr|Radarr|Lidarr
APP_BIN="$(basename "$TARGET_EXE")"             # Prowlarr|Radarr|Lidarr
APP_LOWER="$(echo "$APP_DIR" | tr 'A-Z' 'a-z')" # prowlarr|radarr|lidarr

case "$APP_DIR/$APP_BIN" in
  Prowlarr/Prowlarr|Radarr/Radarr|Lidarr/Lidarr) ;;
  *) echo "Cannot infer app from $TARGET_EXE"; exit 9 ;;
esac

SRC_DIR="${UPDATE_DIR%/}/${APP_DIR}"            # expected: …/UpdateDir/<App>/

# ---------- Parse flags -> DATA_DIR + normalized restart args ----------
DATA_DIR=""; NOBROWSER=""; EXTRA_FLAGS=""
for tok in $RAW_FLAGS; do
  case "$tok" in
    /data=*|-data=*) DATA_DIR="${tok#*=}" ;;
    /nobrowser|-nobrowser) NOBROWSER="-nobrowser" ;;
    /*|-*) EXTRA_FLAGS="$EXTRA_FLAGS $(echo "$tok" | sed 's@^/@-@')" ;;
    *) EXTRA_FLAGS="$EXTRA_FLAGS \"$tok\"" ;;
  esac
done
[ -n "$DATA_DIR" ] || DATA_DIR="/tmp"
RESTART_ARGS="$NOBROWSER -data=$DATA_DIR$EXTRA_FLAGS"

# ---------- SPK paths ----------
CONFIG_DIR="$(dirname "$DATA_DIR")"
HOME_DIR="$(dirname "$CONFIG_DIR")"              # /var/packages/<pkg>/var
PID_FILE="${DATA_DIR%/}/${APP_LOWER}.pid"
RUN_LOG="${HOME_DIR%/}/${APP_LOWER}.log"

# compute …/@appstore/<pkg> (needed for LD_LIBRARY_PATH on DSM<7)
APP_ROOT="$(dirname "$BIN_DIR")"                 # …/share/<App>
SHARE_DIR="$(dirname "$APP_ROOT")"               # …/share
PKGDEST="$(dirname "$SHARE_DIR")"                # …/@appstore/<pkg>

# ---------- DSM version ----------
DSM_MAJOR=7; DSM_MINOR=0
if [ -r /etc/VERSION ]; then
  DSM_MAJOR="$(awk -F'\"' '/^(majorversion|major)=/ {print $2; exit}' /etc/VERSION 2>/dev/null || echo 7)"
  DSM_MINOR="$(awk -F'\"' '/^(minorversion|minor)=/ {print $2; exit}' /etc/VERSION 2>/dev/null || echo 0)"
fi
is_lt_7_2=false
{ [ "$DSM_MAJOR" -lt 7 ] || { [ "$DSM_MAJOR" -eq 7 ] && [ "$DSM_MINOR" -lt 2 ]; }; } && is_lt_7_2=true

# ---------- Script logging (silent to stdout/stderr) ----------
UPDATE_LOG_DIR="${DATA_DIR%/}/UpdateLogs"
mkdir -p "$UPDATE_LOG_DIR"
log_file="${UPDATE_LOG_DIR}/$(date '+%Y.%m.%d-%H.%M').txt"
exec 1>/dev/null 2>/dev/null

# ---------- Functions ----------
stop_app() {
  if ps -p "$PID" >/dev/null 2>&1; then
    log "Stopping PID $PID (TERM → up to 30s → KILL)"
    kill -TERM "$PID" 2>/dev/null || true
    for _ in $(seq 1 30); do ps -p "$PID" >/dev/null 2>&1 || break; sleep 1; done
    ps -p "$PID" >/dev/null 2>&1 && { kill -KILL "$PID" 2>/dev/null || true; sleep 1; }
  else
    log "PID $PID not running"
  fi
  # clear stale PID file
  [ -f "$PID_FILE" ] && ! ps -p "$(cat "$PID_FILE" 2>/dev/null || echo)" >/dev/null 2>&1 \
    && { rm -f "$PID_FILE"; log "Cleared stale PID: $PID_FILE"; }
}

preserve_lib_if_needed() {
  SAVED_LIB=""
  if $is_lt_7_2 && [ -f "${BIN_DIR}/libe_sqlite3.so" ]; then
    SAVED_LIB="${UPDATE_DIR%/}/.${APP_LOWER}_save_libe_sqlite3.so"
    cp -p "${BIN_DIR}/libe_sqlite3.so" "$SAVED_LIB" 2>/dev/null || true
    log "Preserved libe_sqlite3.so"
  fi
  echo "$SAVED_LIB"
}

replace_binaries() {
  [ -d "$SRC_DIR" ] || die "Source not found: $SRC_DIR" 5
  case "$BIN_DIR" in */${APP_DIR}/bin) ;; *) die "BIN guard failed: $BIN_DIR" 6 ;; esac

  # write test (root usually required)
  if [ ! -w "$BIN_DIR" ] && ! ( T="${BIN_DIR}/.__w.$$"; : >"$T" 2>/dev/null && rm -f "$T" ); then
    die "Destination not writable: $BIN_DIR (run as root)" 4
  fi

  log "Wipe $BIN_DIR"
  rm -rf "${BIN_DIR:?}/"* 2>/dev/null || true

  log "Copy $SRC_DIR -> $BIN_DIR"
  cp -a "${SRC_DIR}/." "${BIN_DIR}/"

  chmod +x "${BIN_DIR}/${APP_BIN}" 2>/dev/null || true
}

restore_lib_if_saved() {
  SAVED_LIB="$1"
  [ -n "$SAVED_LIB" ] && [ -f "$SAVED_LIB" ] \
    && { cp -p "$SAVED_LIB" "${BIN_DIR}/libe_sqlite3.so" 2>/dev/null || true; log "Restored libe_sqlite3.so"; }
}

start_app() {
  ENV_PREFIX="env HOME=${HOME_DIR}"
  [ "$DSM_MAJOR" -lt 7 ] && [ -d "${PKGDEST}/lib" ] && ENV_PREFIX="env HOME=${HOME_DIR} LD_LIBRARY_PATH=${PKGDEST}/lib"

  touch "$RUN_LOG" 2>/dev/null || true
  log "Start ${APP_LOWER} cmd: ${ENV_PREFIX} ${TARGET_EXE} -nobrowser -data=$DATA_DIR"

  cd "$BIN_DIR"
  # shellcheck disable=SC2086
  nohup setsid ${ENV_PREFIX} "${TARGET_EXE}" -nobrowser -data="$DATA_DIR" $EXTRA_FLAGS >>"$RUN_LOG" 2>&1 &
  NEW_PID=$!
  sleep 1

  # prefer PID file; else child PID
  if [ -f "$PID_FILE" ] && ps -p "$(cat "$PID_FILE" 2>/dev/null || echo)" >/dev/null 2>&1; then
    log "Started via PID file: $(cat "$PID_FILE" 2>/dev/null || true)"
    return 0
  fi
  ps -p "${NEW_PID:-0}" >/dev/null 2>&1 && { log "Started child PID: $NEW_PID"; return 0; }
  return 1
}

# ---------- Run ----------
log "=== ${APP_DIR} upgrade | DSM ${DSM_MAJOR}.${DSM_MINOR} ==="
log "SRC=$SRC_DIR | BIN=$BIN_DIR | DATA=$DATA_DIR | RUN_LOG=$RUN_LOG"

stop_app
SAVED="$(preserve_lib_if_needed)"
replace_binaries
restore_lib_if_saved "$SAVED"

if start_app; then
  log "=== done ==="
  exit 0
else
  die "Start failed; see $RUN_LOG" 3
fi
