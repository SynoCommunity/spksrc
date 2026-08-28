SVC_BACKGROUND=y
SVC_WRITE_PID=y

PYTHON_DIR="/var/packages/python314/target/bin"
FFMPEG_DIR="/var/packages/ffmpeg8/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}:${FFMPEG_DIR}:${PATH}"

service_postinst ()
{
    install_python_virtualenv
    install_python_wheels

    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        CONFIG="${SYNOPKG_PKGVAR}/copyparty.conf"
        cp "${SYNOPKG_PKGDEST}/share/copyparty/copyparty.conf" "${CONFIG}"
        sed -i -e "s|@USER@|${wizard_admin_user}|g" \
               -e "s|@PASS@|${wizard_admin_password}|g" \
               -e "s|@SHARE@|${SHARE_PATH}|g" \
               "${CONFIG}"
        chmod 600 "${CONFIG}"
    fi
}

service_prestart ()
{
    CONFIG="${SYNOPKG_PKGVAR}/copyparty.conf"
    SERVICE_COMMAND="${SYNOPKG_PKGDEST}/env/bin/python3 -m copyparty -c ${CONFIG}"
}
