
# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts

service_prestart ()
{
    # Replace generic service startup
    MONO_PATH="/var/packages/mono/target/bin"
    PATH="${SYNOPKG_PKGDEST}/bin:${MONO_PATH}:${PATH}"
    MONO="${MONO_PATH}/mono"
    JACKETT="${SYNOPKG_PKGDEST}/share/${SYNOPKG_PKGNAME}/JackettConsole.exe"
    HOME_DIR="${SYNOPKG_PKGVAR}"

    # workaround for mono bug with armv5 (https://github.com/mono/mono/issues/12537)
    if [ "$SYNOPKG_DSM_ARCH" == "88f8621" -o "$SYNOPKG_DSM_ARCH" == "88f8622" ]; then
        MONO="MONO_ENV_OPTIONS='-O=-aot,-float32' ${MONO_PATH}/mono"
    fi

    echo "Starting Jackett as user ${EFF_USER}" >> ${LOG_FILE}
    COMMAND="env HOME=${HOME_DIR} PATH=${PATH} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${MONO} ${JACKETT} --PIDFile ${PID_FILE}"

    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 6 ]; then
        su ${EFF_USER} -s /bin/sh -c "${COMMAND}" >> ${LOG_FILE} 2>&1 &
    else
        ${COMMAND} >> ${LOG_FILE} 2>&1 &
    fi
}

service_postinst ()
{
    # Discard legacy obsolete busybox user account
    BIN=${SYNOPKG_PKGDEST}/bin
    $BIN/busybox --install $BIN
    $BIN/delgroup "${USER}" "users" >> ${INST_LOG}
    $BIN/deluser "${USER}" >> ${INST_LOG}

    echo "service_postinst ${SYNOPKG_PKG_STATUS}" >> ${INST_LOG}
}
