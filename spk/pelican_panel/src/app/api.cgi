#!/bin/sh
# CGI proxy for Wings API - forwards requests to the loading-proxy on port 8080

# Handle CORS preflight
if [ "$REQUEST_METHOD" = "OPTIONS" ]; then
    echo "Content-Type: application/json"
    echo "Access-Control-Allow-Origin: *"
    echo "Access-Control-Allow-Methods: GET, POST, OPTIONS"
    echo "Access-Control-Allow-Headers: Content-Type"
    echo ""
    exit 0
fi

# Get the action from query string
ACTION=$(echo "$QUERY_STRING" | sed -n 's/.*action=\([^&]*\).*/\1/p')

# Set content type and CORS headers
echo "Content-Type: application/json"
echo "Access-Control-Allow-Origin: *"
echo ""

case "$ACTION" in
    status)
        curl -s --connect-timeout 5 --max-time 10 "http://127.0.0.1:8080/api/wings/status" 2>/dev/null || echo '{"success":false,"error":"Service unavailable"}'
        ;;
    get-config)
        curl -s --connect-timeout 5 --max-time 10 "http://127.0.0.1:8080/api/wings/config" 2>/dev/null || echo '{"success":false,"error":"Service unavailable"}'
        ;;
    save-config)
        # Read POST data from stdin
        if [ "$REQUEST_METHOD" = "POST" ]; then
            if [ -n "$CONTENT_LENGTH" ] && [ "$CONTENT_LENGTH" -gt 0 ] 2>/dev/null; then
                POST_DATA=$(dd bs=1 count="$CONTENT_LENGTH" 2>/dev/null)
            else
                POST_DATA=$(cat)
            fi
            curl -s --connect-timeout 5 --max-time 30 -X POST -H "Content-Type: application/json" -d "$POST_DATA" "http://127.0.0.1:8080/api/wings/config" 2>/dev/null || echo '{"success":false,"error":"Service unavailable"}'
        else
            echo '{"success":false,"error":"POST method required"}'
        fi
        ;;
    *)
        echo '{"success":false,"error":"Unknown action"}'
        ;;
esac
