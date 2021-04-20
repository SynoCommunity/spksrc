#! /bin/sh

AA_PARSER_BIN=${SYNOPKG_PKGDEST}/sbin/apparmor_parser
AA_PARSER="${AA_PARSER_BIN} --config-file ${SYNOPKG_PKGDEST}/etc/apparmor/parser.conf"

AA_PROFILE_LXC_START="${SYNOPKG_PKGDEST}/etc/apparmor.d/usr.bin.lxc-start"

aa_log_old_parser ()
{
    echo "ERROR: We do not have an up-to-date AppArmor parser"
    echo "       LXC containers will have to run unconfined"
}

aa_profile_lxc_start_enforce ()
{
    echo "Setting AppArmor profile to [Enforce]"
    if [ -x "${AA_PARSER_BIN}" ]; then
        ${AA_PARSER} -r "${AA_PROFILE_LXC_START}"
    else
        aa_log_old_parser
    fi
}

aa_profile_lxc_start_complain ()
{
    echo "Setting AppArmor profile to [Complain]"
    if [ -x "${AA_PARSER_BIN}" ]; then
        
        ${AA_PARSER} -r -C "${AA_PROFILE_LXC_START}"
    else
        aa_log_old_parser
    fi
}

aa_profile_lxc_start_remove ()
{
    echo "Removing AppArmor profile"
    if [ -x "${AA_PARSER_BIN}" ]; then
        ${AA_PARSER} -R "${AA_PROFILE_LXC_START}"
    else
        echo "There is no AppArmor profile to remove"
    fi
}
