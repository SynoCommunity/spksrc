

# service ctl file
EJABBERD_CTL="${SYNOPKG_PKGDEST}/sbin/ejabberdctl"


service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        ${EJABBERD_CTL} start       >> ${INST_LOG} 2>&1
        ${EJABBERD_CTL} started     >> ${INST_LOG} 2>&1
        
        ${EJABBERD_CTL} register ${wizard_ejabberd_admin_username} ${wizard_ejabberd_hostname} ${wizard_ejabberd_admin_password}  >> ${INST_LOG} 2>&1
        
        ${EJABBERD_CTL} stop        >> ${INST_LOG} 2>&1
        ${EJABBERD_CTL} stopped     >> ${INST_LOG} 2>&1
    fi
}
