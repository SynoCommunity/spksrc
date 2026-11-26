#!/bin/sh

# iCloud Photo Sync – spksrc service-setup.sh
# Consolidates preinst, postinst, preuninst, postupgrade, and
# start-stop-status into the hook functions expected by spksrc's
# installer framework.

SCHEDULER="${SYNOPKG_PKGDEST}/bin/scheduler.py"
PID_FILE="${SYNOPKG_PKGVAR}/scheduler.pid"
LOG_DIR="${SYNOPKG_PKGVAR}/logs"
LOG_FILE="${LOG_DIR}/scheduler.log"
STARTUP_ERR="${LOG_DIR}/startup-error.log"

PYTHON_BIN="${SYNOPKG_PKGDEST}/env/bin/python3"

detect_default_volume() {
    for v in /volume[0-9]*; do
        [ -d "$v" ] && case "$v" in *USB*|*@*) continue;; esac && echo "$v" && return
    done
    echo "/volume1"
}

SVC_BACKGROUND=y
SVC_WRITE_PID=y

# ---------- helpers ----------------------------------------------------------

find_python() {
    # Prefer the virtualenv provided by spksrc's python wheel support.
    if [ -x "${PYTHON_BIN}" ]; then
        echo "${PYTHON_BIN}"
        return 0
    fi
    # Fallback: system Python or SynoCommunity Python package.
    for c in \
        /usr/bin/python3 \
        /usr/bin/python3.8 \
        /usr/bin/python3.9 \
        /usr/bin/python3.10 \
        /usr/bin/python3.11 \
        /usr/local/bin/python3 \
        /var/packages/py3k/target/usr/bin/python3 \
        /var/packages/python3/target/usr/bin/python3 \
        /var/packages/python311/target/bin/python3
    do
        [ -x "$c" ] && { echo "$c"; return 0; }
    done
    command -v python3 2>/dev/null && return 0
    return 1
}

is_running() {
    [ -f "$PID_FILE" ] || return 1
    PID=$(cat "$PID_FILE" 2>/dev/null)
    [ -n "$PID" ] || return 1
    kill -0 "$PID" 2>/dev/null
}

log_startup_err() {
    {
        echo "==== $(date '+%Y-%m-%d %H:%M:%S') service-setup failure ===="
        echo "$@"
    } >> "$STARTUP_ERR" 2>/dev/null
}

kill_package_processes() {
    pkill -f "${SYNOPKG_PKGDEST}/bin/sync_runner.py" 2>/dev/null || true
    pkill -f "${SYNOPKG_PKGDEST}/bin/scheduler.py" 2>/dev/null || true
    sleep 1
    pkill -9 -f "${SYNOPKG_PKGDEST}/bin/sync_runner.py" 2>/dev/null || true
    pkill -9 -f "${SYNOPKG_PKGDEST}/bin/scheduler.py" 2>/dev/null || true
}

clean_legacy_artifacts() {
    sed -i "/#iCloudPhotoSync/d" /etc/crontab 2>/dev/null || true
    rm -f /etc/cron.d/iCloudPhotoSync 2>/dev/null || true
    rm -f /etc/sudoers.d/iCloudPhotoSync 2>/dev/null || true
}

# ---------- lifecycle hooks --------------------------------------------------

service_preinst() {
    PYTHON=$(find_python)
    if [ -z "$PYTHON" ]; then
        echo "iCloud Photo Sync requires Python 3. Install the Python 3 package from DSM Package Center or SynoCommunity."
        exit 1
    fi
}

service_postinst() {
    mkdir -p "${SYNOPKG_PKGVAR}/accounts"
    mkdir -p "${SYNOPKG_PKGVAR}/logs"

    if [ ! -f "${SYNOPKG_PKGVAR}/config.json" ]; then
        _vol=$(detect_default_volume)
        echo "{\"accounts\": [], \"default_target_dir\": \"${_vol}/iCloudPhotos\"}" \
            > "${SYNOPKG_PKGVAR}/config.json"
    fi

    clean_legacy_artifacts

    # Post-install message
    if [ -n "$SYNOPKG_TEMP_LOGFILE" ]; then
        _vol=$(detect_default_volume)
        LANG_FILE="/usr/syno/etc/preference/${USER}/synodefault"
        DSM_LANG=""
        if [ -f "$LANG_FILE" ]; then
            DSM_LANG=$(grep -o '"lang":"[^"]*"' "$LANG_FILE" 2>/dev/null \
                | head -1 | sed 's/"lang":"//;s/"//')
        fi

        if [ "$DSM_LANG" = "ger" ]; then
            cat >> "$SYNOPKG_TEMP_LOGFILE" <<MSGEOF
<br><p style="color:blue"><big><b>Installation erfolgreich!</b></big></p>
<br><p>Fotos werden standardmäßig in den Ordner <b>${_vol}/iCloudPhotos</b> synchronisiert, der automatisch eingerichtet wurde.</p>
<br><p style="color:blue"><b>Eigenen Zielordner verwenden?</b></p>
<p>Wenn du einen anderen Shared Folder als Ziel verwenden möchtest, musst du dem Paket-Benutzer Schreibzugriff gewähren:</p><br>
<p>1. Öffne <b>Systemsteuerung</b> und wähle <b>Gemeinsamer Ordner</b></p>
<p>2. Wähle den gewünschten Ordner und klicke auf <b>Bearbeiten</b></p>
<p>3. Klicke auf den Reiter <b>Berechtigungen</b></p>
<p>4. <span style="color:red"><b>Wichtig:</b></span> Ändere das Dropdown von <b>Lokale Benutzer</b> auf <b>Systeminterner Benutzer</b></p>
<p>5. Aktiviere die <b>Lesen/Schreiben</b>-Checkbox für den Benutzer <b>sc-icloudphotosync</b></p>
<p>6. Klicke auf <b>Speichern</b></p>
MSGEOF
        else
            cat >> "$SYNOPKG_TEMP_LOGFILE" <<MSGEOF
<br><p style="color:blue"><big><b>Installation successful!</b></big></p>
<br><p>Photos will be synced to <b>${_vol}/iCloudPhotos</b> by default, which has been set up automatically.</p>
<br><p style="color:blue"><b>Want to use a custom target folder?</b></p>
<p>If you want to sync to a different shared folder, you need to grant write access to the package user:</p><br>
<p>1. Open <b>Control Panel</b> and select <b>Shared Folder</b></p>
<p>2. Select the target share and click <b>Edit</b></p>
<p>3. Click the <b>Permissions</b> tab</p>
<p>4. <span style="color:red"><b>Important:</b></span> Change the dropdown from <b>Local Users</b> to <b>System internal user</b></p>
<p>5. Check the <b>Read/Write</b> checkbox for the <b>sc-icloudphotosync</b> user</p>
<p>6. Click <b>Save</b></p>
MSGEOF
        fi
    fi
}

service_preuninst() {
    kill_package_processes
    clean_legacy_artifacts
}

service_postuninst() {
    true
}

service_preupgrade() {
    true
}

service_postupgrade() {
    clean_legacy_artifacts
}

service_prestart() {
    mkdir -p "$LOG_DIR" 2>/dev/null || true

    PYTHON=$(find_python)
    if [ -z "$PYTHON" ]; then
        log_startup_err "No Python 3 interpreter found."
        return 1
    fi

    if [ ! -f "$SCHEDULER" ]; then
        log_startup_err "Scheduler script missing: $SCHEDULER"
        return 1
    fi

    if ! "$PYTHON" -c "import sys; sys.exit(0)" >> "$STARTUP_ERR" 2>&1; then
        log_startup_err "Python interpreter failed sanity check: $PYTHON"
        return 1
    fi

    if ! "$PYTHON" -c "
import sys, os
sys.path.insert(0, os.path.join('${SYNOPKG_PKGDEST}', 'lib'))
sys.path.insert(0, os.path.join('${SYNOPKG_PKGDEST}', 'lib', 'vendor'))
import config_manager, notifier, sync_engine
" >> "$STARTUP_ERR" 2>&1; then
        log_startup_err "Python module import check failed (see above). Python: $PYTHON"
        return 1
    fi

    SERVICE_COMMAND="$PYTHON $SCHEDULER"
}

service_poststop() {
    kill_package_processes
    rm -f "$PID_FILE"
}
