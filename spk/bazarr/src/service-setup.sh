FFMPEG_DIR="/var/packages/ffmpeg7/target/bin"
PYTHON_DIR="/var/packages/python312/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${FFMPEG_DIR}:${PATH}"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python3"
LANGUAGE="env LANG=en_US.UTF-8 LC_ALL=en_US.utf8"

SVC_BACKGROUND=y
SVC_WRITE_PID=y
SVC_CWD="${SYNOPKG_PKGDEST}/share/${SYNOPKG_PKGNAME}"

SERVICE_COMMAND="$LANGUAGE $PYTHON ${SVC_CWD}/bazarr.py --no-update --config ${SYNOPKG_PKGVAR}/data "

# save and restore the pip-cache on package update
# ------------------------------------------------
# Avoid the use of ${SYNOPKG_PKGVAR} folder for the pip cache.
# Under DSM<7 this folder's ownership will be changed to sc-bazarr,
# but the installer runs under root and the cache must be owned by the same user.
PIP_CACHE_BACKUP_DIR=${TMP_DIR}/pip-cache
PIP_CACHE_DIR=${SYNOPKG_PKGDEST}/pip-cache
export PIP_DOWNLOAD_CACHE=${PIP_CACHE_DIR}
# avoid installation to user specific site-packages folder
export PYTHONNOUSERSITE=1

service_save ()
{
    if [ -d "${PIP_CACHE_DIR}" ]; then 
        echo "Save pip cache to ${PIP_CACHE_BACKUP_DIR}"
        $MKDIR ${PIP_CACHE_BACKUP_DIR}
        $CP ${PIP_CACHE_DIR}/. ${PIP_CACHE_BACKUP_DIR}
    fi
}

service_postinst ()
{
    separator="===================================================="

    echo ${separator}
    if [ "${SYNOPKG_PKG_STATUS}" = "UPGRADE" ] && [ -d "${PIP_CACHE_BACKUP_DIR}" ]; then 
        echo "Restore pip cache from ${PIP_CACHE_BACKUP_DIR}"
        $MV ${PIP_CACHE_BACKUP_DIR} ${PIP_CACHE_DIR}/
        # ensure current user is owner of pip-cache
        chown -R "$(id -u)":"$(id -g)" ${PIP_CACHE_DIR}/
    else
        echo "Create pip cache directory: ${PIP_CACHE_DIR}"
        $MKDIR ${PIP_CACHE_DIR}
    fi

    echo ${separator}
    echo "Install Python virtual environment"
    install_python_virtualenv
    
    echo ${separator}
    echo "Install packages from wheelhouse"
    pip install --disable-pip-version-check --no-deps --no-input --no-index ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl

    if [ -e ${SYNOPKG_PKGDEST}/share/requirements-pure.txt ]; then
      echo ${separator}
      echo "Install pure python packages from index"
      pip install --disable-pip-version-check --no-deps --no-input --cache-dir ${PIP_CACHE_DIR} --requirement ${SYNOPKG_PKGDEST}/share/requirements-pure.txt
    fi

    if [ "${SYNOPKG_PKG_STATUS}" = "UPGRADE" ]; then
        if [ -e ${SYNOPKG_PKGVAR}/requirements-custom.txt ]; then
            echo ${separator}
            echo "Install custom packages from index"
            pip install --disable-pip-version-check --no-input --cache-dir ${PIP_CACHE_DIR} --requirement ${SYNOPKG_PKGVAR}/requirements-custom.txt
        fi
    fi

    echo ${separator}
    echo "Installed modules:"
    pip freeze
}
