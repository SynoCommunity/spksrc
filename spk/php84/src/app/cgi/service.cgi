#!/bin/sh
# PHP 8.4 Service Control CGI Script
# POSIX-compliant - Handles service start/stop/restart operations

# Package paths
SYNOPKG_PKGDEST="${SYNOPKG_PKGDEST:-/var/packages/php84/target}"
SYNOPKG_PKGVAR="${SYNOPKG_PKGVAR:-/var/packages/php84/var}"
SYNOPKG_PKGNAME="${SYNOPKG_PKGNAME:-php84}"

# Paths
SERVICE_SCRIPT="${SYNOPKG_PKGDEST}/scripts/start-stop-status"
PID_FILE="${SYNOPKG_PKGVAR}/run/php-fpm.pid"

# Output headers
echo "Content-Type: application/json"
echo ""

# Check if service is running
is_running() {
    if [ -f "$PID_FILE" ]; then
        pid=$(cat "$PID_FILE" 2>/dev/null)
        if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
            return 0
        fi
    fi
    return 1
}

# Get service status
get_status() {
    if is_running; then
        pid=$(cat "$PID_FILE" 2>/dev/null)
        echo "{\"success\":true,\"status\":\"running\",\"pid\":$pid}"
    else
        echo '{"success":true,"status":"stopped","pid":null}'
    fi
}

# Parse action from query string
get_action() {
    echo "$QUERY_STRING" | tr '&' '\n' | while read param; do
        key=$(echo "$param" | cut -d'=' -f1)
        if [ "$key" = "action" ]; then
            echo "$param" | cut -d'=' -f2
            return
        fi
    done
}

# Main request handler
REQUEST_METHOD="${REQUEST_METHOD:-GET}"
action=$(get_action)

case "$REQUEST_METHOD" in
    GET)
        case "$action" in
            status|"")
                get_status
                ;;
            *)
                echo '{"success":false,"error":"Unknown action"}'
                ;;
        esac
        ;;
    POST)
        # Read POST data to get action
        if [ -n "$CONTENT_LENGTH" ] && [ "$CONTENT_LENGTH" -gt 0 ]; then
            read -r POST_DATA
            # Extract action from JSON (simple parsing)
            action=$(echo "$POST_DATA" | tr ',' '\n' | tr -d '{}\"' | while read line; do
                key=$(echo "$line" | cut -d':' -f1 | tr -d ' ')
                if [ "$key" = "action" ]; then
                    echo "$line" | cut -d':' -f2 | tr -d ' '
                    break
                fi
            done)
        fi

        case "$action" in
            start)
                if is_running; then
                    echo '{"success":true,"message":"Service already running"}'
                else
                    # Use synopkg to start service
                    synopkg start "$SYNOPKG_PKGNAME" >/dev/null 2>&1
                    sleep 2
                    if is_running; then
                        echo '{"success":true,"message":"Service started"}'
                    else
                        echo '{"success":false,"error":"Failed to start service"}'
                    fi
                fi
                ;;
            stop)
                if ! is_running; then
                    echo '{"success":true,"message":"Service not running"}'
                else
                    synopkg stop "$SYNOPKG_PKGNAME" >/dev/null 2>&1
                    sleep 2
                    if ! is_running; then
                        echo '{"success":true,"message":"Service stopped"}'
                    else
                        echo '{"success":false,"error":"Failed to stop service"}'
                    fi
                fi
                ;;
            restart)
                synopkg restart "$SYNOPKG_PKGNAME" >/dev/null 2>&1
                sleep 3
                if is_running; then
                    echo '{"success":true,"message":"Service restarted"}'
                else
                    echo '{"success":false,"error":"Failed to restart service"}'
                fi
                ;;
            reload)
                if ! is_running; then
                    echo '{"success":false,"error":"Service not running"}'
                else
                    pid=$(cat "$PID_FILE" 2>/dev/null)
                    kill -USR2 "$pid" 2>/dev/null
                    sleep 1
                    if is_running; then
                        echo '{"success":true,"message":"Configuration reloaded"}'
                    else
                        echo '{"success":false,"error":"Service crashed during reload"}'
                    fi
                fi
                ;;
            *)
                echo '{"success":false,"error":"Unknown action. Use: start, stop, restart, reload"}'
                ;;
        esac
        ;;
    *)
        echo '{"success":false,"error":"Method not allowed"}'
        ;;
esac
