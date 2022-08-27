
NODE_RED_DIR=${SYNOPKG_PKGDEST}/packages/node_modules/node-red

SERVICE_COMMAND="npm start"
SVC_CWD=${NODE_RED_DIR}
SVC_BACKGROUND=y
SVC_WRITE_PID=y

export HOME=${SYNOPKG_PKGVAR}

service_postinst ()
{
    cd ${NODE_RED_DIR} && npm install
}
