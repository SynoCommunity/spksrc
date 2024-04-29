
# service ctl file
EJABBERD_CTL="${SYNOPKG_PKGDEST}/bin/ejabberdctl"
# HOME to place the erlang cookie into
export HOME=${SYNOPKG_PKGDEST}

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        ${EJABBERD_CTL} start
        ${EJABBERD_CTL} started
        
        ${EJABBERD_CTL} register ${wizard_ejabberd_admin_username} ${wizard_ejabberd_hostname} ${wizard_ejabberd_admin_password}
        
        ${EJABBERD_CTL} stop
        ${EJABBERD_CTL} stopped
    fi
}

