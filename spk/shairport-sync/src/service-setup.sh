CFG_FILE="${SYNOPKG_PKGVAR}/shairport-sync.conf"
CFG_TEMPLATE="${SYNOPKG_PKGDEST}/share/shairport-sync.conf.template"

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/shairport-sync -c ${CFG_FILE}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

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
