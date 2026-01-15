#!/bin/sh

# we need a single file to start the service and create the pid-file
# the combination of 
# - SVC_BACKGROUND=y
# - SVC_WRITE_PID=y
# does not work in DSM 5 when SERVICE_COMMAND is a command with parameters.
# On DSM 5 /bin/sh is ash and not bash and '/bin/sh -c "command parameter" &' will create a new process for "command parameter"
# finally we have two processes in the background, but are not able to retrieve the PID of "command parameter"
# 

if [ -z "${SYNOPKG_PKGDEST}" -o -z "${PID_FILE}" -o -z "${SERVICE_PORT}" ]; then
    echo "ERROR: SYNOPKG_PKGDEST, PID_FILE or SERVICE_PORT is not defined. This script must be run in the context of DSM service command."
    exit 1
fi

${SYNOPKG_PKGDEST}/bin/ympd -w ${SERVICE_PORT}
echo "$!" > ${PID_FILE}

