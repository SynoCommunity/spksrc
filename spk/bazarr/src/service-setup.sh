FFMPEG_DIR="/var/packages/ffmpeg7/target/bin"
PYTHON_DIR="/var/packages/python311/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${FFMPEG_DIR}:${PATH}"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python3"
LANGUAGE="env LANG=en_US.UTF-8 LC_ALL=en_US.utf8"

GROUP="sc-download"
SVC_BACKGROUND=y
SVC_WRITE_PID=y
SVC_CWD="${SYNOPKG_PKGDEST}/share/${SYNOPKG_PKGNAME}"

SERVICE_COMMAND="$LANGUAGE $PYTHON ${SVC_CWD}/bazarr.py --no-update --config ${SYNOPKG_PKGVAR}/data "

service_postinst ()
{
    # Create a Python virtualenv
    install_python_virtualenv

    # Install the wheels (using virtual env through PATH)
    install_python_wheels

    mkdir -p "${SYNOPKG_PKGVAR}/data"

    if [ -n "${SYNOPKG_DSM_VERSION_MAJOR}" ] && [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
      set_unix_permissions "${SYNOPKG_PKGVAR}/data"
    fi
}
