
PYTHON_DIR="/var/packages/python313/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"
HACS_VERS=2.0.5

CONFIG_DIR="${SYNOPKG_PKGVAR}/config"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/env/bin/hass -v --config ${CONFIG_DIR} --log-file ${LOG_FILE}"
SVC_WRITE_PID=y
SVC_BACKGROUND=y
SVC_CWD="${SYNOPKG_PKGVAR}"
HOME="${SYNOPKG_PKGVAR}"
# required for native libraries in the package (like cross/opus for voip-utils)
export LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib

# save and restore the pip-cache on package update
# ------------------------------------------------
# Avoid the use of ${SYNOPKG_PKGVAR} folder for the pip cache.
# Under DSM<7 this folder's ownership will be changed to sc-homeassistant,
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
    echo "Download HACS ${HACS_VERS} and install to: ${CONFIG_DIR}/custom_components/hacs"
    wget -nv -O ${SYNOPKG_PKGVAR}/hacs.zip https://github.com/hacs/integration/releases/download/${HACS_VERS}/hacs.zip
    mkdir -p "${CONFIG_DIR}/custom_components"
    ${SYNOPKG_PKGDEST}/bin/unzip -qo ${SYNOPKG_PKGVAR}/hacs.zip -d ${CONFIG_DIR}/custom_components/hacs
    rm -f ${SYNOPKG_PKGVAR}/hacs.zip

    echo ${separator}
    echo "Install packages from wheelhouse"
    pip install --disable-pip-version-check --no-deps --no-input --no-index ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl

    echo ${separator}
    echo "Install cross python packages"
    pip install --disable-pip-version-check --no-deps --no-input --cache-dir ${PIP_CACHE_DIR} --requirement ${SYNOPKG_PKGDEST}/share/requirements-cross_from_index.txt

    echo ${separator}
    echo "Install pure python packages"
    pip install --disable-pip-version-check --no-deps --no-input --cache-dir ${PIP_CACHE_DIR} --requirement ${SYNOPKG_PKGDEST}/share/requirements-pure.txt

    echo ${separator}
    echo "Install additional packages for some integrations"
    pip install --disable-pip-version-check --no-deps --no-input --cache-dir ${PIP_CACHE_DIR} --requirement ${SYNOPKG_PKGDEST}/share/requirements-integrations.txt

    if [ "${SYNOPKG_PKG_STATUS}" == "UPGRADE" ]; then
        if [ -e ${SYNOPKG_PKGVAR}/requirements-custom.txt ]; then
            echo ${separator}
            echo "Install custom packages"
            pip install --disable-pip-version-check --no-input --cache-dir ${PIP_CACHE_DIR} --requirement ${SYNOPKG_PKGVAR}/requirements-custom.txt
        fi
    fi

    echo ${separator}
    echo "Patch some packages after installation"
    ### patch integrations
    SITE_PACKAGES=$(realpath ${SYNOPKG_PKGDEST}/env/lib/python*/site-packages)
    # aioasuswrt==1.5.1 does not exist, let it find aioasuswrt==1.5.4
    sed -e 's/aioasuswrt==1.5.1/aioasuswrt>=1.5.1,<2.0.0/g' -i.orig ${SITE_PACKAGES}/homeassistant/components/asuswrt/manifest.json
    # opuslib does not find libopus.so with 'find_library'
    sed -e "s|lib_location = find_library('opus')|lib_location = '${SYNOPKG_PKGDEST}/lib/libopus.so'|g" -i.orig ${SITE_PACKAGES}/opuslib/api/__init__.py
    # aiodhcpwatcher does not find libpcap.so
    sed -e "s|find_library(\"pcap\")|\"${SYNOPKG_PKGDEST}/lib/libpcap.so\"|g" -i.orig ${SITE_PACKAGES}/scapy/libs/winpcapy.py

    echo "Provide chunk for tami4 integration"
    ### install chunk stub required by tami4 integration
    cp -p ${SYNOPKG_PKGDEST}/share/chunk.py ${SITE_PACKAGES}/
    
    echo "Restrict packages to explicit versions"
    CONSTRAINTS=${SITE_PACKAGES}/homeassistant/package_constraints.txt
    echo ""                                 >> ${CONSTRAINTS}
    echo "# Added by SynoCommunity package" >> ${CONSTRAINTS}
    echo "pycares==4.11.0"                  >> ${CONSTRAINTS}
    echo "caio==0.9.24"                     >> ${CONSTRAINTS}
    echo "scapy==2.6.1"                     >> ${CONSTRAINTS}
    echo "voip_utils==0.3.4"                >> ${CONSTRAINTS}
}
