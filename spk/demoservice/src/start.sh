#!/bin/sh

# we need a single file to start the service and create the pid-file
# the combination of 
# - SVC_BACKGROUND=y
# - SVC_WRITE_PID=y
# does not work in DSM 5 when SERVICE_COMMAND is a commend with parameters
# On DSM 5 /bin/sh is ash and not bash and '/bin/sh -c "command parameter" &' will create a new process for "command parameter"
# finally we have two processes in the background, but are not able to retrieve the PID of "command parameter"
# 

if [ -z "${PID_FILE}" ]; then
echo "ERROR: PID_FILE is not defined. This script must be run in the context of DSM service command."
exit 1
fi


PYTHON=python
if [ -n "$(which python3 2> /dev/null)" ]; then
PYTHON=python3
fi

PYTHON_VERSION=$(${PYTHON} --version 2>&1)
PYTHON_MAJOR_VERSION=$(echo ${PYTHON_VERSION} | cut -d ' ' -f2 | cut -d . -f1)

SERVER_MODULE="SimpleHTTPServer"
if [ "${PYTHON_MAJOR_VERSION}" == "3" ]; then
SERVER_MODULE="http.server"
fi

echo "current user: $(id)"
echo "python version: ${PYTHON_VERSION}"
echo "service command: ${PYTHON} -m ${SERVER_MODULE} ${SERVICE_PORT}"

${PYTHON} -m ${SERVER_MODULE} ${SERVICE_PORT} &
echo "$!" > ${PID_FILE}
