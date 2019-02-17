#!/bin/sh

#/**
# * @file run.sh
# * @brief just start WebGrab+Plus
# * @author Francis De Paemeleere, adaptations by m4tt075
# * @date 31/07/2016
# */

#backup the current working dir
WG_BCKP_DIR="$(pwd)"

HOME_DIR="/var/packages/webgrabplus/target/var"
MONO_PATH="/var/packages/mono/target/bin"
PATH="/var/packages/webgrabplus/target/bin:${MONO_PATH}:${PATH}"
MONO="${MONO_PATH}/mono"
WEBGRABPLUS="/var/packages/webgrabplus/target/share/webgrabplus/bin/WebGrab+Plus.exe"

function quit {
    #restore previous working dir
    cd "$WG_BCKP_DIR"
    exit $1;
}

env HOME="${HOME_DIR}" PATH="${PATH}" "${MONO}" "${WEBGRABPLUS}" "${HOME_DIR}"

quit 0;
