
PYTHON_DIR="/var/packages/python311/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"
CONFIG_FILE="${SYNOPKG_PKGVAR}/homeserver.yaml"
HOMESERVER="${SYNOPKG_PKGDEST}/env/bin/synapse_homeserver"
SERVICE_COMMAND="${HOMESERVER} --config-path ${CONFIG_FILE} --daemonize --config-directory ${SYNOPKG_PKGVAR} --data-directory ${SYNOPKG_PKGVAR}"
# synapse_homeserver pid file name is not configurable
PID_FILE=${SYNOPKG_PKGVAR}/homeserver.pid

export LD_PRELOAD=${SYNOPKG_PKGDEST}/lib/libjemalloc.so.2


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

    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        echo ${separator}
        if [ "${wizard_report_stats}" = "true" ]; then
            REPORT_STATS="--report-stats=yes"
        else
            REPORT_STATS="--report-stats=no"
        fi
        if [ "${wizard_open_private_ports}" = "true" ]; then
            # avoid the "bind_addresses" definition in generated config
            EXTERNAL_ACCESS=" --open-private-ports"
        else
            EXTERNAL_ACCESS=""
        fi
        echo "Create initial configuration for server '${wizard_servername}' (${REPORT_STATS}${EXTERNAL_ACCESS})"
        cd ${SYNOPKG_PKGVAR} && ${HOMESERVER} --config-path ${CONFIG_FILE} --server-name ${wizard_servername} --generate-config ${REPORT_STATS} ${EXTERNAL_ACCESS}
    fi
}
