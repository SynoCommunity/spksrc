

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        sed -i -e "s#{hosts, \[\"localhost\"\]}.#{hosts, \[\"${wizard_ejabberd_hostname}\"\]}.#g" \
               -e "s#\%\%{acl, admin, {user, \"ermine\", \"example.org\"}}.#{acl, admin, {user, \"${wizard_ejabberd_admin_username}\", \"${wizard_ejabberd_hostname}\"}}.#g" \
               -e "s#{access_createnode, pubsub_createnode},#{access_createnode, pubsub_createnode},\n\t\t  {max_items_node, 1000000},#g" \
               ${SYNOPKG_PKGDEST}/var/ejabberd.cfg
        ${SYNOPKG_PKGDEST}/sbin/ejabberdctl start > /dev/null
        ${SYNOPKG_PKGDEST}/sbin/ejabberdctl register ${wizard_ejabberd_admin_username} ${wizard_ejabberd_hostname} ${wizard_ejabberd_admin_password}
        ${SYNOPKG_PKGDEST}/sbin/ejabberdctl stop > /dev/null
    fi
}


###   service_preupgrade ()
###   {
###       # Save the configuration file
###       rm -fr ${TMP_DIR}/${PACKAGE}
###       mkdir -p ${TMP_DIR}/${PACKAGE}/etc/ejabberd
###       mkdir -p ${TMP_DIR}/${PACKAGE}/var/lib/ejabberd
###       mv ${SYNOPKG_PKGDEST}/etc/ejabberd/* ${TMP_DIR}/${PACKAGE}/etc/ejabberd
###       mv ${SYNOPKG_PKGDEST}/var/lib/ejabberd/* ${TMP_DIR}/${PACKAGE}/var/lib/ejabberd
###   }
###   
###   service_postupgrade ()
###   {
###       # Restore the configuration file
###       mv ${TMP_DIR}/${PACKAGE}/etc/ejabberd/* ${SYNOPKG_PKGDEST}/etc/ejabberd
###       mv ${TMP_DIR}/${PACKAGE}/var/lib/ejabberd/* ${SYNOPKG_PKGDEST}/var/lib/ejabberd
###       rm -fr ${TMP_DIR}/${PACKAGE}
###   }
