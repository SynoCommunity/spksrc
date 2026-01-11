
# service ctl file
EJABBERD_CTL="${SYNOPKG_PKGDEST}/bin/ejabberdctl"
# HOME to place the erlang cookie into
export HOME=${SYNOPKG_PKGVAR}

service_preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "UPGRADE" ]; then
        if [ "$SYNOPKG_DSM_VERSION_MAJOR" -lt 7 ]; then
            # provide a copy of the new config files 
            # copy to TMP_DIR that will be restored into var, to 
            # prevent final overwriting by previous versions of *.new files
            for config_file in ejabberdctl.cfg ejabberd.yml inetrc; do
                if [ -f ${SYNOPKG_PKGINST_TEMP_DIR}/var/${config_file} ]; then
                    echo "install new config file as: ${config_file}.new"
                    $CP ${SYNOPKG_PKGINST_TEMP_DIR}/var/${config_file} ${TMP_DIR}/${config_file}.new
                fi
            done
        fi
    fi
}

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # patch ejabberd.yml to grant access for admin
        sed -e "s#@@adminuser@@#${wizard_ejabberd_admin_username}@${wizard_ejabberd_hostname}#g" -i ${SYNOPKG_PKGVAR}/ejabberd.yml

        ${EJABBERD_CTL} start
        ${EJABBERD_CTL} started
        
        ${EJABBERD_CTL} register ${wizard_ejabberd_admin_username} ${wizard_ejabberd_hostname} ${wizard_ejabberd_admin_password}
        
        ${EJABBERD_CTL} stop
        ${EJABBERD_CTL} stopped
    fi
}
