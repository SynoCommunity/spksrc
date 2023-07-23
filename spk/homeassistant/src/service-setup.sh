
PYTHON_DIR="/var/packages/python310/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"

CONFIG_DIR="${SYNOPKG_PKGVAR}/config"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/env/bin/hass -v --config ${CONFIG_DIR} --log-file ${LOG_FILE}"
SVC_WRITE_PID=y
SVC_BACKGROUND=y
SVC_CWD="${SYNOPKG_PKGVAR}"
HOME="${SYNOPKG_PKGVAR}"


# save and restore the pip-cache on package update
# ------------------------------------------------
# Avoid the use of ${SYNOPKG_PKGVAR} folder for the pip cache.
# Under DSM<7 this folder's ownership will be changed to sc-homeassistant,
# but the installer runs under root and the cache must be owned by root.
PIP_CACHE_BACKUP_DIR=${TMP_DIR}/pip-cache
PIP_CACHE_DIR=${SYNOPKG_PKGDEST}/pip-cache
export PIP_DOWNLOAD_CACHE=${PIP_CACHE_DIR}
# avoid installation to user specific site-packages folder
export PYTHONNOUSERSIZE=1

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
    echo "Downgrade pip for homeassistant compatibility"
    pip install --disable-pip-version-check pip==22.2.2

    echo ${separator}
    echo "Install HACS into: ${CONFIG_DIR}/custom_components/hacs"
    mkdir -p "${CONFIG_DIR}/custom_components/hacs"
    tar -xzf ${SYNOPKG_PKGDEST}/share/hacs.tar.gz -C ${CONFIG_DIR}/custom_components/hacs

    echo ${separator}
    echo "Install packages from wheels"
    pip install --disable-pip-version-check --no-deps --no-input --no-index ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl

    echo ${separator}
    echo "Install pure python packages from index"
    pip install --disable-pip-version-check --no-deps --no-input --cache-dir ${PIP_CACHE_DIR} --requirement ${SYNOPKG_PKGDEST}/share/wheelhouse/requirements-pure.txt

    echo ${separator}
    echo "Install packages for homeassistant.components from index"
    pip install --disable-pip-version-check --no-input --cache-dir ${PIP_CACHE_DIR} --requirement ${SYNOPKG_PKGDEST}/share/postinst_components_requirements.txt


    if [ "${SYNOPKG_PKG_STATUS}" == "UPGRADE" ]; then
        if [ "$SYNOPKG_DSM_VERSION_MAJOR" -lt 7 ]; then
            # restore custom requirements file
            if [ -f ${TMP_DIR}/requirements-custom.txt ]; then
                $CP ${TMP_DIR}/requirements-custom.txt ${SYNOPKG_PKGVAR}/requirements-custom.txt
            fi
        fi
        if [ -e ${SYNOPKG_PKGVAR}/requirements-custom.txt ]; then
            echo ${separator}
            echo "Install custom packages from index"
            pip install --disable-pip-version-check --no-input --cache-dir ${PIP_CACHE_DIR} --requirement ${SYNOPKG_PKGVAR}/requirements-custom.txt
        fi
    else
        $MV ${SYNOPKG_PKGVAR}/requirements-custom.txt.new ${SYNOPKG_PKGVAR}/requirements-custom.txt
    fi

    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        # ensure package user has access to the virtual env packages, installed as root
        set_unix_permissions ${SYNOPKG_PKGDEST}/env
    fi
}
