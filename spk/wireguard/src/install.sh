### Package specific variables and functions
if [ -z "${SYNOPKG_PKGNAME}" ] || [ -z "${SYNOPKG_DSM_VERSION_MAJOR}" ]; then
  echo "Error: Environment variables are not set." 1>&2;
  echo "Please run me using synopkg instead. Example: \"synopkg start [packagename]\"" 1>&2;
exit 1; fi
# start-stop-status script redirect stdout/stderr to LOG_FILE
LOG_FILE="${SYNOPKG_PKGDEST}/var/${SYNOPKG_PKGNAME}.log"
# Service command has to deliver its pid into PID_FILE
PID_FILE="${SYNOPKG_PKGDEST}/var/${SYNOPKG_PKGNAME}.pid"

# List of commands to create links for
SPK_COMMANDS="/bin/wg /bin/wg-quick"
SPK_LINKS=""

# Create links for cli binaries
service_create_links ()
{
    for cmd in ${SPK_COMMANDS}
    do
        if [ -e "${SYNOPKG_PKGDEST}/${cmd}" ]; then
            mkdir -p "$(dirname /usr/local/${cmd})"  >> "${INST_LOG}" 2>&1
            echo "create link: /usr/local/${cmd} -> ${SYNOPKG_PKGDEST}/${cmd}"  >> "${INST_LOG}"
            ln -s "${SYNOPKG_PKGDEST}/${cmd}" "/usr/local/${cmd}"  >> "${INST_LOG}" 2>&1
        fi
    done

    for item in ${SPK_LINKS}
    do
        _link=$(echo ${item} | sed "s/:.*//g")
        _target=$(echo ${item} | sed "s/.*://g")
        if [ -e "${SYNOPKG_PKGDEST}/${_target}" ]; then
            mkdir -p "$(dirname ${_link})"  >> "${INST_LOG}" 2>&1
            echo "create link: ${_link} -> ${SYNOPKG_PKGDEST}/${_target}"  >> "${INST_LOG}"
            ln -s "${SYNOPKG_PKGDEST}/${_target}" "${_link}"  >> "${INST_LOG}" 2>&1
        fi
    done
}

# Remove links created for cli binaries
service_remove_links ()
{
    for cmd in ${SPK_COMMANDS}
    do
        if [ -L "/usr/local/${cmd}" ]; then
            if [ "$(readlink /usr/local/${cmd})" == "${SYNOPKG_PKGDEST}/${cmd}" ]; then
                echo "remove link: /usr/local/${cmd} -> ${SYNOPKG_PKGDEST}/${cmd}"  >> "${INST_LOG}"
                rm -f "/usr/local/${cmd}"  >> "${INST_LOG}" 2>&1
            else
                echo "skip remove link: /usr/local/${cmd} -> $(readlink /usr/local/${cmd})"  >> "${INST_LOG}"
            fi
        else
           echo "link to remove not found: /usr/local/${cmd}"  >> "${INST_LOG}"
        fi
    done

    for item in ${SPK_LINKS}
    do
        _link=$(echo ${item} | sed "s/:.*//g")
        _target=$(echo ${item} | sed "s/.*://g")
        if [ -L "${_link}" ]; then
            if [ "$(readlink ${_link})" == "${SYNOPKG_PKGDEST}/${_target}" ]; then
                echo "remove link: ${_link} -> ${SYNOPKG_PKGDEST}/${_target}"  >> "${INST_LOG}"
                rm -f "${_link}"  >> "${INST_LOG}" 2>&1
            else
                echo "skip remove link: ${_link} -> $(readlink ${_link})"  >> "${INST_LOG}"
            fi
        else
           echo "link to remove not found: ${_link}"  >> "${INST_LOG}"
        fi
    done
}


# Tools shortcuts
MV="/bin/mv -f"
RM="/bin/rm -rf"
CP="/bin/cp -rfp"
MKDIR="/bin/mkdir -p"
LN="/bin/ln -nsf"
TEE="/usr/bin/tee -a"

preinst()
{
    exit 0
}

postinst()
{
    sed -i 's/package/root/g' /var/packages/${SYNOPKG_PKGNAME}/conf/privilege
    mkdir -p "${SYNOPKG_PKGDEST}/var/"
    if [ -x "/bin/bash" ]; then
        # change shebang to packaged bash
        sed -i 's/#!\/bin\/bash/#!\/var\/packages\/wireguard\/target\/bin\/bash/' /usr/local/bin/wg-quick
    fi

    if [ -r "${FWPORTS_FILE}" ]; then
        echo "Installing service configuration ${FWPORTS_FILE}" >> ${INST_LOG}
        servicetool --install-configure-file --package "${FWPORTS_FILE}" >> ${INST_LOG} 2>&1
    fi
    service_create_links
}

preuninst ()
{
    log_step "preuninst"

    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        # Remove firewall config
        if [ -r "${FWPORTS_FILE}" ]; then
            echo "Removing service configuration ${SYNOPKG_PKGNAME}.sc" >> ${INST_LOG}
            servicetool --remove-configure-file --package "${SYNOPKG_PKGNAME}.sc" >> ${INST_LOG} 2>&1
        fi
    fi
    service_remove_links
    exit 0
}
postuninst()
{

}

preupgrade()
{
    exit 0
}

postupgrade()
{
    exit 0
}
