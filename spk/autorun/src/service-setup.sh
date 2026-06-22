# should be migrated to ${SYNOPKG_PKGTMP}
LOG="/var/tmp/${SYNOPKG_PKGNAME}.log"
DTFMT="+%Y-%m-%d %H:%M:%S"
CURRENT_USER=$(whoami)
SCRIPTPATHTHIS="$(cd -- "$(dirname "${0}")" >/dev/null 2>&1 ; pwd -P )"


# service_preinst is obsolete.
# the DSM package installer already prevents to install when DSM version is less than os_min_ver.


service_postinst ()
{
    echo "$(date "${DTFMT}"): postinst V${SYNOPKG_PKGVER} started as user '${CURRENT_USER}' ...<br/>" >> "${LOG}"
    
    # need to fetch values entered by user from environment and put to the strings file for each language
    # configFilePathName="$(dirname "$0")/initial_config.txt" is no more available!
    items="$(env | grep "^config_")"
    
    # keys="config_WAIT config_BEEP config_LED_COPY config_EJECT_TIMEOUT config_LOG_MAX_LINES config_NOTIFY_USERS config_LOGLEVEL"
    mapfile -t itemArray < <(/bin/printf '%s' "${items}")
    
    # echo "$(date "${DTFMT}"): Config-Items from ENV: '${itemArray[*]}'" >> "${LOG}"
    # config_LED, Status LED usage:
    #  0 = not used,
    #  1 = orange while script is running, green when done,
    #  2 = orange flashing if script result is neither 0 nor 100,
    #  3 = orange while running, flashing if neither 0 nor 100, else green

    # config_LED_COPY, Copy LED usage:
    #  0 = not used,
    #  1 = on while script is running, off after end,
    #  2 = flashing while script is running, off after the end,
    #  4 = flashing if script result is neither 0 nor 100,
    #  5 = on while running, flashing if script result is neither 0 nor 100, else off after end.

    # config_ADD_NEW_FINGERPRINTS, Security configuration:
    #  0 = unrestricted, no hash check
    #  1 = clear hash list now and register the hash of each newly executed script,
    #  2 = allow only previously registered hashes,
    #  3 = register the new onces
    echo "$(date "${DTFMT}"): postinst: SYNOPKG_OLD_PKGVER='${SYNOPKG_OLD_PKGVER}', SYNOPKG_PKGVER='${SYNOPKG_PKGVER}'" >> "${LOG}"
    rm -f "${SYNOPKG_PKGVAR}/config"
    echo "$(date "${DTFMT}"): file pathName: '${SYNOPKG_PKGVAR}/config' will be generated now ...<br/>" >> "${LOG}"

    # Messages (send to ${SYNOPKG_TEMP_LOGFILE}) are not shown up!? ==> Do the checks in start-stop-status
    # If terminated with "exit 1" then the old setting are lost. ==> Do the checks in start-stop-status 
    # 1) Is the ${config_SCRIPT_AFTER_EJECT} file available, and has it correct line break and UTF8-Coding?
    # 2) is user or group config_NOTIFY_USERS valid? Check for valid entry requires root access and is done in the start-stop-status script

    msg=""
    for item in "${itemArray[@]}"; do
        # eval "${item}" # e.g. ", config_NO_DSM_MESSAGE_RETURN_CODES='98'", the ";99" is lost!???
        key="${item%%=*}"
        # Some values with, some without quotes, remove them:
        val="$(sed -e 's/^\"//' -e 's/\"$//' <<<"${item#*=}")"
        key2=${key#*config_}
        if [[ -n "${key2}" ]]; then
            echo "${key2}=\"${val}\"" >> "${SYNOPKG_PKGVAR}/config"
        fi
        # echo "${item}:  ${key2}=\"${val}\"" >> "${LOG}"
        msg="${msg}  ${key2}='${val}'"
    done
    echo "$(date "${DTFMT}"): from ENV extracted: ${msg}" >> "${LOG}"
    if [[ "${config_ADD_NEW_FINGERPRINTS}" -eq "1" ]]; then
        KNOWNSCRIPTSFILEPATHNAME="${SYNOPKG_PKGVAR}/FINGERPRINTS"
        res=$(rm -f "${KNOWNSCRIPTSFILEPATHNAME}")
        ret=$?
        echo "$(date "${DTFMT}"): Deletion of old fingerprints: ${ret}, ${res}" >> "${LOG}"
    fi

    chmod 755 "${SYNOPKG_PKGVAR}/config"
    # Distinguish between a) new Installation, b) upgrade or c) change of settings
    action="Installation, upgrade or change of settings"
    if [[ -z "${SYNOPKG_OLD_PKGVER}" ]]; then
        action="Installation of V${SYNOPKG_PKGVER}"
    elif [[ "${SYNOPKG_OLD_PKGVER}" == "${SYNOPKG_PKGVER}" ]]; then
        action="Re-Installation (change of settings) of V${SYNOPKG_PKGVER}"
    else
        action="Upgrade from V${oldVers} to V${SYNOPKG_PKGVER}"
    fi

    if [[ "${config_ADD_NEW_FINGERPRINTS}" -eq "1" ]]; then
        echo "$(date "${DTFMT}"): ${action} done, previously registered script fingerprints deleted, not yet started" >> "${SYNOPKG_PKGVAR}/execLog"
    else
        echo "$(date "${DTFMT}"): ${action} done, not yet started" >> "${SYNOPKG_PKGVAR}/execLog"
    fi
    echo "$(date "${DTFMT}"): postinst done, not yet started, ${SYNOPKG_PKGNAME} installed<br/>" >> "${LOG}"
}

service_preupgrade ()
{
    echo -e "\n$(date "${DTFMT}"): $0 (${SYNOPKG_PKGVER}) started with account '${CURRENT_USER}' ..." >> "${LOG}"
    # preupgrade starts from an temporary folder like /volume1/@tmp/synopkg/install.XDdQUB/scripts/preupgrade
    # Attention: if in the WIZARD_UIFILES folder a script is used for a dynamic ..._uifile, then it's not allowed to write here somthing to ${SYNOPKG_TEMP_LOGFILE} !!!

    #Developer Guide 7, Page 54, Script Execution Order
    #            Upgrade                         Installation     Uninstall
    #  ------------------------------------------------------------------------------------------
    #  newScript upgrade_uifile.sh            install_uifile.sh   uninstall_uifile.sh  (if available)
    #  oldScript start-stop prestop (if running)                  start-stop prestop (if running)
    #  oldScript start-stop stop (if running)                     start-stop stop (if running)
    #  newScript preupgrade  
    #  oldScript preuninst                                        preuninst
    #  @appstore/<app> and @apptemp/<app> are deleted
    #  oldScript postuninst                                       postuninst
    #  newScript prereplace??                    prereplace??
    #  newScript preinst                         preinst
    #  newScript postinst                        postinst  
    #  newScript postreplace        
    #  newScript postupgrade 
    #  newScript start-stop prestart             start-stop prestart
    #  newScript start-stop start                start-stop start
      
    # tempStorageFolder="${SYNOPKG_TEMP_UPGRADE_FOLDER}/usersettings" # alternative temp folder (DemoUiSpk7)
    # /volumeX/@appdata/<app>	(= /var/packages/<app>/var) is preserved during upgrade!
    # So there is no need for an temporary stprage folder.

    echo "$(date "${DTFMT}"): ... preupgrade done<br/>" >> "${LOG}"
}

service_postupgrade ()
{
    echo "$(date "${DTFMT}"): postupgrade V${SYNOPKG_PKGVER} started ...<br/>" >> "${LOG}"
    if [[ ! -f "${SYNOPKG_PKGVAR}/config" ]]; then # not e.g. preserved from uninstall
        tempStorageFolder="/tmp/net.reidemeister.${SYNOPKG_PKGNAME}"
        if [ -d "${tempStorageFolder}" ]; then
            echo "$(date "${DTFMT}"): temp data folder $}tempStorageFolder} found<br/>" >> "${LOG}"
            # restore log
            if [ -f "${tempStorageFolder}/log" ]; then
                (cp -v "${tempStorageFolder}/log" "${SYNOPKG_PKGVAR}") 2>&1 >> "${LOG}"
                echo "$(date "${DTFMT}"): temp logfile copied<br/>" >> "${LOG}"
            fi
            # clean-up
            rm -r ${tempStorageFolder}
        fi
    fi
    echo "$(date "${DTFMT}"): ... postupgrade done<br/>" >> "${LOG}"
}

post_uninst ()
{
    echo "$(date "${DTFMT}"): postuninst V${SYNOPKG_PKGVER} started as ${CURRENT_USER}...<br/>" >> "${LOG}"
    # echo "$(date "${DTFMT}"): p0='$0'" >> "${LOG}" # ${app_name} is empty!!
    configFilePathName="${SYNOPKG_PKGVAR}/config"  # ${SYNOPKG_PKGVAR} is /volume1/@appdata/autorun and is o.k., still available
    # echo "$(date "${DTFMT}"): configFilePathName='${configFilePathName}'" >> "${LOG}"
    # after uninstall is /var/packages/${SYNOPKG_PKGNAME} no more available, only /volume1/@appdata/autorun !!!
    # Attention: If a new version is installed, then this file from the old version
    #   is executed before the preinst of the new version!
    if [[ "${pkgwizard_remove_settings}" == "true" ]] || [[ "${pkgwizard_remove_settings}" == "false" ]]; then
        # WIZZARD_UIFILES/uninstall_uifile_<lng> was done before! So it's a real uninstall, not an upgrade!
        if [[ "${bDebug}" -eq "0" ]]; then
            rm "${LOG}"
            rm "/var/tmp/resource.${SYNOPKG_PKGNAME}.*"
            rm "/var/log/packages/${SYNOPKG_PKGNAME}.log"
            rm "/var/log/packages/${SYNOPKG_PKGNAME}.log.*.xz"
            rm "${SYNOPKG_PKGVAR}/execLog"
            # echo "$(date "${DTFMT}"): Old logfiles removed" >> "${LOG}"
        else
            echo "$(date "${DTFMT}"): Logfiles preserved due to bDebug!=0" >> "${LOG}"
        fi
    fi
    if [[ "${pkgwizard_remove_settings}" == "true" ]]; then
        res=$(rm -r --interactive=never "${SYNOPKG_PKGVAR}") # remove folder
        ret=$?
        # if [[ "${bDebug}" -ne "0" ]]; then
            echo "$(date "${DTFMT}"): Result from 'rm -r \"${SYNOPKG_PKGVAR}\"': ${ret}, '${res}'" >> "${LOG}"
        # fi
    else
        if [[ -f "${SYNOPKG_PKGVAR}\config" ]]; then
            # put old version to config file, so that postinst can check whether its an upgrade or only settings change
            res=$(grep "VERSION=" "${SYNOPKG_PKGVAR}\config")
            if [[ -n "${res}" ]]; then
                res="$(sed -i "s|^VERSION=.*$|VERSION=\"${SYNOPKG_PKGVAR}\"|" "${SYNOPKG_PKGVAR}\config")"
            else
                echo "VERSION=\"${SYNOPKG_PKGVAR}\"" >> "${SYNOPKG_PKGVAR}\config"
            fi
        fi
    fi
    echo "$(date "${DTFMT}"): ... postuninst done<br/>" >> "${LOG}"
}
