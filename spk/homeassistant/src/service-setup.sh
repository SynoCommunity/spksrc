
# service setup: content is included by following scripts
# - installer
# - start-stop-status

PYTHON_DIR="/var/packages/python38/target/bin"
VIRTUALENV="${PYTHON_DIR}/python3 -m venv"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"

CONFIG_DIR="${SYNOPKG_PKGVAR}/config"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/env/bin/hass -v --config ${CONFIG_DIR} --pid-file ${PID_FILE} --log-file ${LOG_FILE} --daemon"
SVC_CWD="${SYNOPKG_PKGVAR}"
HOME="${SYNOPKG_PKGVAR}"


rename_file ()
{
    _from=$1
    _to=$2
    if [ ! "${_from}" -ef "${_to}" ]; then
        echo "- rename ${_from##*/}  to  ${_to##*/}"
        mv -f ${_from} ${_to}
    fi
}


service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env
    
    # ensure current pip (>= 20.3)
    # older versions with old dependency resolver will complain about double dependencies while
    # install is done with local *.whl files and requirements from the index.
    ${SYNOPKG_PKGDEST}/env/bin/python3 -m pip install --upgrade pip
    
    separator="===================================================="
    wheelhouse=${SYNOPKG_PKGDEST}/share/wheelhouse

    echo ${separator}
    echo "Rename arch specific wheels"
    uname_m=$(uname -m)
    for wheel_file in ${wheelhouse}/pycryptodome*-none-any.whl ; do
        new_wheel_file=$(echo ${wheel_file} | sed "s|cp35-none-any|cp35-abi3-linux_${uname_m}|g")
        rename_file "${wheel_file}" "${new_wheel_file}"
    done
    none_name="-cp38-none-any.whl"
    arch_name="-cp38-cp38-linux_${uname_m}.whl"
    for wheel_file in ${wheelhouse}/*${none_name} ; do
        rename_file "${wheel_file}" "${wheel_file%${none_name}}${arch_name}"
    done

    echo ${separator}
    echo "Install packages from wheels"
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-input --no-index ${wheelhouse}/*.whl

    echo ${separator}
    echo "Install packages for default_config from index"
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-input --requirement ${SYNOPKG_PKGDEST}/share/postinst_default_config_requirements.txt

    echo ${separator}
    echo "Install packages for homeassistant.components from index"
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-input --requirement ${SYNOPKG_PKGDEST}/share/postinst_components_requirements.txt

    mkdir -p "${CONFIG_DIR}"
}
