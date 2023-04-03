PYTHON_DIR="/var/packages/python310/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"
PYTHON=${SYNOPKG_PKGDEST}/env/bin/python3
OCTOPRINT=${SYNOPKG_PKGDEST}/env/bin/octoprint
SERVICE_COMMAND="${PYTHON} ${OCTOPRINT} daemon start -b ${SYNOPKG_PKGVAR}/.octoprint -c ${SYNOPKG_PKGVAR}/.octoprint/config.yaml --pid ${PID_FILE}"


# save and restore the pip-cache on package update
# ------------------------------------------------
# Avoid the use of ${SYNOPKG_PKGVAR} folder for the pip cache.
# Under DSM<7 this folder's ownership will be changed to package user,
# but the installer runs under root and the cache must be owned by root.
PIP_CACHE_BACKUP_DIR=${TMP_DIR}/pip-cache
PIP_CACHE_DIR=${SYNOPKG_PKGDEST}/pip-cache
export PIP_DOWNLOAD_CACHE=${PIP_CACHE_DIR}

service_save ()
{
    if [ -d "${PIP_CACHE_DIR}" ]; then 
        echo "Save pip cache to ${PIP_CACHE_BACKUP_DIR}"
        $MKDIR ${TMP_DIR}/pip-cache
        $CP ${PIP_CACHE_DIR}/. ${PIP_CACHE_BACKUP_DIR}
    fi
}

service_postinst ()
{
    separator="===================================================="

    echo ${separator}
    if [ "${SYNOPKG_PKG_STATUS}" == "UPGRADE" -a -d "${PIP_CACHE_BACKUP_DIR}" ]; then 
        echo "Restore pip cache from ${PIP_CACHE_BACKUP_DIR}"
        $MV ${PIP_CACHE_BACKUP_DIR} ${PIP_CACHE_DIR}/
        # ensure current user is owner of pip-cache
        chown -R $(id -u):$(id -g) ${PIP_CACHE_DIR}/
    else
        echo "Create pip cache directory: ${PIP_CACHE_DIR}"
        $MKDIR ${PIP_CACHE_DIR}
    fi

    echo ${separator}
    echo "Install Python virtual environment"
    install_python_virtualenv

    echo ${separator}
    echo "Install packages from wheels"
    pip install --disable-pip-version-check --no-deps --no-input --no-index ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl

    echo ${separator}
    echo "Install pure python packages from index"
    pip install --disable-pip-version-check --no-deps --no-input --cache-dir ${PIP_CACHE_DIR} --requirement ${SYNOPKG_PKGDEST}/share/wheelhouse/requirements-pure.txt

    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        # allow installation of plugins
        set_unix_permissions "${SYNOPKG_PKGDEST}/env/"
    fi
}


service_prestart()
{
    insmod /lib/modules/usbserial.ko
    insmod /lib/modules/ftdi_sio.ko
    insmod /lib/modules/cdc-acm.ko
    
    # Create device
    test -e /dev/ttyACM0 || mknod /dev/ttyACM0 c 166 0
    chmod 777 /dev/ttyACM0
}

service_poststop ()
{
    rmmod /lib/modules/usbserial.ko
    rmmod /lib/modules/ftdi_sio.ko
    rmmod /lib/modules/cdc-acm.ko
}
