#! /bin/sh

SETTINGS_FILE="/var/packages/${SYNOPKG_PKGNAME}/etc/lxc_install_settings"

AA_PARSER_BIN=${SYNOPKG_PKGDEST}/sbin/apparmor_parser
AA_PARSER="${AA_PARSER_BIN} --config-file ${SYNOPKG_PKGDEST}/etc/apparmor/parser.conf"

AA_PROFILE_LXC_START="${SYNOPKG_PKGDEST}/etc/apparmor.d/usr.bin.lxc-start"

save_wizard_settings ()
{
    if [ -e "${SETTINGS_FILE}" ]; then
        rm "${SETTINGS_FILE}"
    fi

    if [ "${wizard_aa_enforce}" = "true" ]; then
        echo "AA_MODE=ENFORCE" >> "${SETTINGS_FILE}"
    elif [ "${wizard_aa_complain}" = "true" ]; then
        echo "AA_MODE=COMPLAIN" >> "${SETTINGS_FILE}"
    elif [ "${wizard_aa_disable}" = "true" ]; then
        echo "AA_MODE=DISABLE" >> "${SETTINGS_FILE}"
    else
        echo "Something has gone wrong saving the AppArmor mode setting: The wizard provided no AppArmor mode."
        exit 1
    fi

    if [ -n "${wizard_lxc_volume}" ]; then
        echo "LXC_VOLUME=\"${wizard_lxc_volume}\"" >> "${SETTINGS_FILE}"
    else
        echo "Something went wrong saving the LXC volume setting: The wizard provided no LXC volume."
        exit 1
    fi

    if [ -n "${wizard_lxc_share_name}" ]; then
        echo "LXC_SHARE_NAME=\"${wizard_lxc_share_name}\"" >> "${SETTINGS_FILE}"
    else
        echo "Something went wrong saving the LXC share setting: The wizard provided no LXC share."
        exit 1
    fi
}

load_settings ()
{
    if [ -r "${SETTINGS_FILE}" ]; then
        . "${SETTINGS_FILE}"

        LXC_SHARE_PATH="${LXC_VOLUME}/${LXC_SHARE_NAME}"
    else
        echo "Could not open the settings file."
        exit 1
    fi
}

aa_log_old_parser ()
{
    echo "ERROR: We do not have an up-to-date AppArmor parser"
    echo "       LXC containers will have to run unconfined"
}

aa_profiles_activate ()
{
    load_settings

    if [ "${AA_MODE}" = "ENFORCE" ]; then
        aa_profiles_mode_enforce
    elif [ "${AA_MODE}" = "COMPLAIN" ]; then
        aa_profiles_mode_complain
    elif [ "${AA_MODE}" = "DISABLE" ]; then
        aa_profiles_mode_disable
    else
        echo "Something has gone wrong setting AppArmor mode: No AppArmor mode provided."
    fi
}

aa_profiles_deactivate ()
{
    aa_profiles_mode_disable
}

aa_profiles_mode_enforce ()
{
    echo "Setting AppArmor profile to [Enforce]"
    if [ -x "${AA_PARSER_BIN}" ]; then
        ${AA_PARSER} -r "${AA_PROFILE_LXC_START}"
    else
        aa_log_old_parser
    fi
}

aa_profiles_mode_complain ()
{
    echo "Setting AppArmor profile to [Complain]"
    if [ -x "${AA_PARSER_BIN}" ]; then
        
        ${AA_PARSER} -r -C "${AA_PROFILE_LXC_START}"
    else
        aa_log_old_parser
    fi
}

aa_profiles_mode_disable ()
{
    echo "Setting AppArmor profile to [Disabled]"
    if [ -x "${AA_PARSER_BIN}" ]; then
        ${AA_PARSER} -R "${AA_PROFILE_LXC_START}"
    else
        echo "There is no AppArmor profile to remove"
    fi
}
