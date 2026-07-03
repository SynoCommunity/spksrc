MONO_PATH="/var/packages/mono/target/bin"
PATH="${SYNOPKG_PKGDEST}/bin:${MONO_PATH}:${PATH}"
MONO="${MONO_PATH}/mono"
JACKETT="${SYNOPKG_PKGDEST}/share/JackettConsole.exe"
HOME_DIR="${SYNOPKG_PKGVAR}"

# workaround for mono bug with armv5 (https://github.com/mono/mono/issues/12537)
if [ "$SYNOPKG_DSM_ARCH" == "88f6281" -o "$SYNOPKG_DSM_ARCH" == "88f6282" ]; then
    MONO="MONO_ENV_OPTIONS='-O=-aot,-float32' ${MONO_PATH}/mono"
fi

SERVICE_COMMAND="env HOME=${HOME_DIR} PATH=${PATH} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${MONO} ${JACKETT} --PIDFile ${PID_FILE}"
SVC_BACKGROUND=y
