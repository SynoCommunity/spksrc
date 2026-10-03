#!/bin/sh
# Post-remove command for tvheadend: delete the files left next to a removed
# recording -- comskip's cutpoints and logo (.edl, .txt, .logo.txt, and .log
# or .csv when enabled) and tvheadend's own scene markers (.sm).  tvheadend
# only deletes the recording itself.
#
# Configuration > Recording > Digital Video Recorder Profiles >
#   Post-remove command:
#     /var/packages/tvheadend/target/bin/tv_postremove_cleanup.sh "%f"
#
# $1 is the full path of the removed recording; only files sharing its base
# name are touched.

[ -n "$1" ] || exit 0
base="${1%.*}"
for ext in edl txt logo.txt log csv sm; do
    rm -f -- "$base.$ext"
done
