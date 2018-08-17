#!/bin/sh

if [ -r "${CFG_FILE}" ]; then
    . "${CFG_FILE}"
fi

/bin/stdbuf -o L -e L ${BIN_FILE} "${PS3_DIR}" >> ${LOG_FILE} 2>&1 &
echo "$!" > "${PID_FILE}"
