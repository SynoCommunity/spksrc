# Stockfish service setup

WEBGUI_HOME="${SYNOPKG_PKGDEST}/share/webgui"
NODE_BIN="/var/packages/Node.js_v18/target/usr/local/bin/node"

# Service configuration
SERVICE_COMMAND="${NODE_BIN} server.js"
SVC_CWD="${WEBGUI_HOME}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# Environment variables
export STOCKFISH_PATH="${SYNOPKG_PKGDEST}/bin/stockfish"
export PORT=${SERVICE_PORT}
