#!/bin/bash

page_append()
{
    if [ -z "$1" ]; then
        echo "$2"
    elif [ -z "$2" ]; then
        echo "$1"
    else
        echo "$1,$2"
    fi
}

# Build combined audio device + mixer options
# Format: "CardName [hw:X] (mixer: MixerName)" - user-friendly display
# Special case: "Test Mode (no audio output)" for dummy backend
# Parsed in service-setup.sh to extract device and mixer
build_audio_options()
{
    local options='"Test Mode (no audio output)"'

    if [ -f /proc/asound/cards ]; then
        while IFS= read -r line; do
            if echo "$line" | grep -qE '^[[:space:]]*[0-9]+[[:space:]]\['; then
                card_num=$(echo "$line" | sed -n 's/^[[:space:]]*\([0-9]*\).*/\1/p')
                card_name=$(echo "$line" | sed -n 's/.*\[\([^]]*\)\].*/\1/p' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                
                if [ -n "$card_num" ]; then
                    local card_dir="/proc/asound/card${card_num}"
                    local display_name="${card_name:-Card $card_num}"
                    
                    # Check usbmixer for USB audio devices
                    if [ -f "$card_dir/usbmixer" ]; then
                        while IFS= read -r mixer_line; do
                            if echo "$mixer_line" | grep -q 'Playback Volume'; then
                                control_name=$(echo "$mixer_line" | sed -n 's/.*name="\([^"]*\) Playback Volume".*/\1/p')
                                if [ -n "$control_name" ]; then
                                    options="$options, \"$display_name [hw:$card_num] (mixer: $control_name)\""
                                fi
                            fi
                        done < "$card_dir/usbmixer"
                    fi
                    
                    # Check oss_mixer for standard ALSA mixers
                    if [ -f "$card_dir/oss_mixer" ]; then
                        while IFS= read -r mixer_line; do
                            control_name=$(echo "$mixer_line" | awk -F'"' '{print $2}')
                            if [ -n "$control_name" ]; then
                                # Avoid duplicates
                                if ! echo "$options" | grep -qF "[hw:$card_num] (mixer: $control_name)"; then
                                    options="$options, \"$display_name [hw:$card_num] (mixer: $control_name)\""
                                fi
                            fi
                        done < "$card_dir/oss_mixer"
                    fi
                    
                    # Always add software volume option for each card
                    options="$options, \"$display_name [hw:$card_num] (mixer: software)\""
                fi
            fi
        done < /proc/asound/cards
    fi

    echo "[$options]"
}

AUDIO_OPTIONS=$(build_audio_options)

# Page 1: Welcome and server name
PAGE_SETUP=$(/bin/cat<<EOF
{
    "step_title": "Shairport Sync Setup",
    "items": [{
        "desc": "<b>Shairport Sync</b> turns your Synology NAS into an AirPlay audio receiver, allowing you to stream music wirelessly from your iPhone, iPad, Mac, or iTunes.<br><br><b>Note:</b> A USB audio device (such as a USB sound card or USB speakers) must be connected to your NAS for audio playback."
    },
    {
        "type": "textfield",
        "desc": "Enter the name that will appear when you select an AirPlay device on your Apple devices:",
        "subitems": [{
            "key": "wizard_server_name",
            "desc": "AirPlay name",
            "defaultValue": "",
            "emptyText": "Leave blank to use NAS hostname"
        }]
    }]
}
EOF
)

# Page 2: Combined audio device and mixer selection
PAGE_AUDIO=$(/bin/cat<<EOF
{
    "step_title": "Audio Output",
    "items": [{
        "desc": "Select your audio output device and volume control method."
    },
    {
        "type": "combobox",
        "desc": "Audio configuration:",
        "subitems": [{
            "key": "wizard_audio_config",
            "desc": "Audio configuration",
            "editable": false,
            "defaultValue": "Test Mode (no audio output)",
            "store": $AUDIO_OPTIONS
        }]
    },
    {
        "desc": "<br><b>Hardware mixer:</b> Volume controlled by your audio device (best quality).<br><b>Software mixer:</b> Volume adjusted digitally by Shairport Sync.<br><b>Test Mode:</b> No sound output, useful for verifying installation."
    }]
}
EOF
)

main()
{
    local install_page=""
    install_page=$(page_append "$install_page" "$PAGE_SETUP")
    install_page=$(page_append "$install_page" "$PAGE_AUDIO")
    echo "[$install_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
