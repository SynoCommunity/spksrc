#! /bin/sh

AA_SETTINGS="/var/packages/${SYNOPKG_PKGNAME}/etc/aa_settings"

AA_PARSER_BIN=${SYNOPKG_PKGDEST}/sbin/apparmor_parser
AA_PARSER="${AA_PARSER_BIN} --config-file ${SYNOPKG_PKGDEST}/etc/apparmor/parser.conf"

AA_PROFILE_LXC_START="${SYNOPKG_PKGDEST}/etc/apparmor.d/usr.bin.lxc-start"

aa_log_old_parser ()
{
    echo "ERROR: We do not have an up-to-date AppArmor parser"
    echo "       LXC containers will have to run unconfined"
}

aa_save_wizard_settings ()
{
    if [ -e "${AA_SETTINGS}" ]; then
        rm "${AA_SETTINGS}"
    fi

    if [ "${wizard_aa_enforce}" = "true" ]; then
        echo "AA_MODE=ENFORCE" >> "${AA_SETTINGS}"
    elif [ "${wizard_aa_complain}" = "true" ]; then
        echo "AA_MODE=COMPLAIN" >> "${AA_SETTINGS}"
    elif [ "${wizard_aa_disable}" = "true" ]; then
        echo "AA_MODE=DISABLE" >> "${AA_SETTINGS}"
    else
        echo "Something has gone wrong saving AppArmor setting: The wizard provided no AppArmor mode."
    fi
}

aa_profiles_activate ()
{
    if [ -r "${AA_SETTINGS}" ]; then
        . "${AA_SETTINGS}"
    fi

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
