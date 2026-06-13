PYTHON_DIR="/var/packages/python312/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"

DATA_PATH=${SYNOPKG_PKGVAR}/data
# config data path provided by custom chip library only:
export CHIP_CONIFG_DATA_PATH=${DATA_PATH}
OTA_PROVIDER_DIR=${SYNOPKG_PKGVAR}/ota
SERVER=${SYNOPKG_PKGDEST}/env/bin/matter-server
SERVICE_COMMAND="${SERVER} --log-file ${LOG_FILE} --storage-path ${DATA_PATH} --ota-provider-dir ${OTA_PROVIDER_DIR}"
SVC_WRITE_PID=y
SVC_BACKGROUND=y


service_postinst ()
{
   separator="===================================================="

   echo ${separator}
   echo "Install Python virtual environment"
   install_python_virtualenv

   echo ${separator}
   echo "Install all requirements"
   pip install --disable-pip-version-check --no-input ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl \
        --requirement ${SYNOPKG_PKGDEST}/share/requirements-crossenv.txt \
        --requirement ${SYNOPKG_PKGDEST}/share/requirements-pure.txt
    
   echo ${separator}
   echo "create special folders"
   mkdir -p ${DATA_PATH}
   mkdir -p ${OTA_PROVIDER_DIR}
}
