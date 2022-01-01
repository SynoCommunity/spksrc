#!/bin/bash
DOCKER_INSPECT="/usr/local/bin/docker_inspect"
case "$1" in
    start)
        ;;
    stop)
        ;;
    status)
        "$DOCKER_INSPECT" "radarr" | grep -q "\"Status\": \"running\"," || exit 1
        "$DOCKER_INSPECT" "sonarr" | grep -q "\"Status\": \"running\"," || exit 1
        "$DOCKER_INSPECT" "bazarr" | grep -q "\"Status\": \"running\"," || exit 1
        ;;
    log)
        echo ""
        ;;
    *)
        echo "Usage: $0 {start|stop|status}" >&2
        exit 1
        ;;
esac
exit 0
