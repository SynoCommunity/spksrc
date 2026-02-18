CFG_FILE="${SYNOPKG_PKGVAR}/shairport-sync.conf"
CFG_TEMPLATE="${SYNOPKG_PKGDEST}/share/shairport-sync.conf.template"

# AirPlay 2 requires connection to DSM's avahi-daemon via D-Bus
# We use system avahi/dbus libraries which are configured for DSM's D-Bus socket
# These paths are consistent across DSM 6.x versions
SYSTEM_AVAHI_CLIENT="/usr/lib/libavahi-client.so.3"
SYSTEM_AVAHI_COMMON="/usr/lib/libavahi-common.so.3"
SYSTEM_DBUS="/usr/lib/libdbus-1.so.3"

# Only set LD_PRELOAD if system libraries exist (AirPlay 2 mode)
if [ -f "${SYSTEM_AVAHI_CLIENT}" ] && [ -f "${SYSTEM_AVAHI_COMMON}" ] && [ -f "${SYSTEM_DBUS}" ]; then
    export LD_PRELOAD="${SYSTEM_AVAHI_CLIENT} ${SYSTEM_AVAHI_COMMON} ${SYSTEM_DBUS}"
    export DBUS_SYSTEM_BUS_ADDRESS="unix:path=/run/dbus/system_bus_socket"
fi

# NQPTP daemon for AirPlay 2 PTP timing (runs on ports 319/320)
NQPTP_BIN="${SYNOPKG_PKGDEST}/bin/nqptp"
NQPTP_PID="${SYNOPKG_PKGVAR}/nqptp.pid"

# Shairport Sync main daemon
SHAIRPORT_BIN="${SYNOPKG_PKGDEST}/bin/shairport-sync"
SHAIRPORT_CMD="${SHAIRPORT_BIN} -c ${CFG_FILE}"

# For AirPlay 2, we manage NQPTP separately via service_prestart/service_poststop
# The main SERVICE_COMMAND is just shairport-sync
SERVICE_COMMAND="${SHAIRPORT_CMD}"

SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_prestart ()
{
    # Check if NQPTP binary exists (AirPlay 2 build)
    if [ -x "${NQPTP_BIN}" ]; then
        # Kill any existing NQPTP processes (from previous failed start or other package)
        pkill -9 nqptp 2>/dev/null || true
        sleep 1

        # Start NQPTP daemon for AirPlay 2 PTP timing
        echo "Starting NQPTP daemon..." >> "${LOG_FILE}"
        "${NQPTP_BIN}" &
        NQPTP_PID_VAL=$!
        echo "${NQPTP_PID_VAL}" > "${NQPTP_PID}"

        # Give NQPTP time to initialize and bind to ports
        sleep 2

        # Verify NQPTP is running
        if ! kill -0 "${NQPTP_PID_VAL}" 2>/dev/null; then
            echo "ERROR: NQPTP failed to start. Check if ports 319/320 are in use." >> "${LOG_FILE}"
            echo "Run 'netstat -tulpn | grep -E \"319|320\"' to check for conflicts." >> "${LOG_FILE}"
            rm -f "${NQPTP_PID}"
            return 1
        fi
        echo "NQPTP started with PID ${NQPTP_PID_VAL}" >> "${LOG_FILE}"
    fi
}

service_poststop ()
{
    # Stop NQPTP daemon if running
    if [ -f "${NQPTP_PID}" ]; then
        NQPTP_PID_VAL=$(cat "${NQPTP_PID}")
        if [ -n "${NQPTP_PID_VAL}" ] && kill -0 "${NQPTP_PID_VAL}" 2>/dev/null; then
            echo "Stopping NQPTP daemon (PID ${NQPTP_PID_VAL})..." >> "${LOG_FILE}"
            kill "${NQPTP_PID_VAL}" 2>/dev/null || true
            sleep 1
            kill -9 "${NQPTP_PID_VAL}" 2>/dev/null || true
        fi
        rm -f "${NQPTP_PID}"
    fi
    # Also kill any orphaned nqptp processes
    pkill -9 nqptp 2>/dev/null || true
}

service_postinst ()
{
    # Link ALSA configuration for the daemon to find
    if [ ! -e "${SYNOPKG_PKGVAR}/.asoundrc" ]; then
        ln -sf "${SYNOPKG_PKGDEST}/share/alsa.conf" "${SYNOPKG_PKGVAR}/.asoundrc"
    fi

    # Copy config template to var directory and apply wizard settings
    if [ -e "${CFG_TEMPLATE}" ]; then
        cp "${CFG_TEMPLATE}" "${CFG_FILE}"
    fi

    # Configure server name (AirPlay display name)
    if [ -n "${wizard_server_name}" ]; then
        # User specified a custom name
        sed -i "s|.*@@SERVER_NAME@@.*|  name = \"${wizard_server_name}\"; // Custom AirPlay name|" "${CFG_FILE}"
    else
        # Use hostname (default)
        sed -i 's|.*@@SERVER_NAME@@.*|  name = "%H"; // Hostname with first letter capitalised|' "${CFG_FILE}"
    fi

    # Parse combined audio config
    # Format: "CardName [hw:X] (mixer: MixerName)" or "Test Mode (no audio output)"
    local audio_device=""
    local mixer_control=""

    if [ "${wizard_audio_config}" = "Test Mode (no audio output)" ]; then
        audio_device="dummy"
        mixer_control=""
    else
        # Extract device: "[hw:X]" -> "hw:X"
        audio_device=$(echo "${wizard_audio_config}" | sed -n 's/.*\[\(hw:[0-9]*\)\].*/\1/p')
        # Extract mixer: "(mixer: X)" -> "X", empty if "software"
        mixer_control=$(echo "${wizard_audio_config}" | sed -n 's/.*(mixer: \([^)]*\)).*/\1/p')
        if [ "${mixer_control}" = "software" ]; then
            mixer_control=""
        fi
    fi

    # Configure output backend and device
    if [ "${audio_device}" = "dummy" ]; then
        # Use dummy backend for testing
        sed -i 's|@@OUTPUT_BACKEND@@|dummy|' "${CFG_FILE}"
        sed -i 's|@@OUTPUT_DEVICE@@|default|' "${CFG_FILE}"
    else
        # Configure ALSA output
        sed -i 's|@@OUTPUT_BACKEND@@|alsa|' "${CFG_FILE}"
        sed -i "s|@@OUTPUT_DEVICE@@|${audio_device:-default}|" "${CFG_FILE}"
    fi

    # Configure mixer control
    if [ -n "${mixer_control}" ]; then
        # User selected a mixer control - use hardware volume control
        sed -i "s|.*@@MIXER_CONTROL@@.*|  mixer_control_name = \"${mixer_control}\";|" "${CFG_FILE}"
    else
        # No mixer control selected - comment out the line for software volume
        sed -i 's|.*@@MIXER_CONTROL@@.*|  // mixer_control_name = "PCM"; // Uncomment and set for hardware volume control|' "${CFG_FILE}"
    fi
}
