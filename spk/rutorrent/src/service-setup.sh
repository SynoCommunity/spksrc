WEB_DIR="/var/services/web"
PKG_WEB_DIR="${WEB_DIR}/${SYNOPKG_PKGNAME}"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/usr/bin:${PATH}"
PHP_CONFIG_LOCATION="$([ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 6 ] && echo -n /usr/local/etc/php56/conf.d || echo -n /etc/php/conf.d)"
APACHE_USER="http"

CFG_FILE="${SYNOPKG_PKGDEST}/var/.rtorrent.rc"

SC_GROUP="sc-download"

##
## All the paths are wrong on DSM6!!
## https://github.com/SynoCommunity/spksrc/issues/2215
## No idea where to start.
## Additionally it seems the package-user needs to be added to the HTTP group (I think)
##

service_preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        if [ ! -d "${wizard_download_dir}" ]; then
            echo "Download directory ${wizard_download_dir} does not exist."
            exit 1
        fi
        if [ -n "${wizard_watch_dir}" -a ! -d "${wizard_watch_dir}" ]; then
            echo "Watch directory ${wizard_watch_dir} does not exist."
            exit 1
        fi
    fi

    exit 0
}

service_postinst ()
{
    # Install the web interface
    cp -pR ${SYNOPKG_PKGDEST}/share/${SYNOPKG_PKGNAME} ${WEB_DIR}

    # Configure open_basedir
    echo -e "[PATH=${PKG_WEB_DIR}]\nopen_basedir = Null" > ${PHP_CONFIG_LOCATION}/${SYNOPKG_PKGNAME_NAME}.ini

    # Configure files
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        TOP_DIR=`echo "${wizard_download_dir:=/volume1/downloads}" | cut -d "/" -f 2`
        MAX_MEMORY=`awk '/MemTotal/{memory=$2*1024*0.25; if (memory > 512*1024*1024) memory=512*1024*1024; printf "%0.f", memory}' /proc/meminfo`

        sed -i -e "s|scgi_port = 5000;|scgi_port = 8050;|g" \
               -e "s|topDirectory = '/';|topDirectory = '/${TOP_DIR}/';|g" \
               -e "s|tempDirectory = null;|tempDirectory = '${SYNOPKG_PKGDEST}/tmp';|g" \
               ${PKG_WEB_DIR}/conf/config.php

        sed -i -e "s|@download_dir@|${wizard_download_dir:=/volume1/downloads}|g" \
               -e "s|@max_memory@|$MAX_MEMORY|g" \
               -e "s|@port_range@|${wizard_port_range:=6881-6999}|g" \
               ${CFG_FILE}

        if [ -d "${wizard_watch_dir}" ]; then
            sed -i -e "s|@watch_dir@|${wizard_watch_dir}|g" ${CFG_FILE}
        else
            sed -i -e "/@watch_dir@/d" ${CFG_FILE}
        fi

        if [ "${wizard_disable_openbasedir}" == "true" ] && [ "${APACHE_USER}" == "http" ]; then
            sed -i -e "s|^open_basedir.*|open_basedir = none|g" /etc/php/conf.d/user-settings.ini
            initctl restart php-fpm > /dev/null 2>&1
        fi

    fi

    # Correct the files ownership
    chown -R ${EFF_USER}:${APACHE_USER} ${SYNOPKG_PKGDEST}/tmp
    set_unix_permissions "${PKG_WEB_DIR}"

    # Discard legacy obsolete busybox user account
    BIN=${SYNOPKG_PKGDEST}/bin
    $BIN/busybox --install $BIN >> ${INST_LOG}
    $BIN/delgroup "${USER}" "users" >> ${INST_LOG}
    $BIN/deluser "${USER}" >> ${INST_LOG}
}


service_postuninst ()
{
    # Remove open_basedir configuration
    rm -f /usr/syno/etc/sites-enabled-user/${SYNOPKG_PKGNAME}.conf
    rm -f /etc/php/conf.d/${SYNOPKG_PKGNAME_NAME}.ini

    # Remove the web interface
    rm -fr ${PKG_WEB_DIR}
}

service_preupgrade ()
{
    # Revision 8 introduces backward incompatible changes
    if [ `echo ${SYNOPKG_OLD_PKGVER} | sed -r "s/^.*-([0-9]+)$/\1/"` -le 8 ]; then
        sed -i -e "s|http_cacert = .*|http_cacert = ${SYNOPKG_PKGDEST}/cert.pem|g" ${CFG_FILE}
    fi

    # Save the configuration file
    mv ${PKG_WEB_DIR}/conf/config.php ${TMP_DIR}/
    cp -pr ${PKG_WEB_DIR}/share/ ${TMP_DIR}/
}

service_postupgrade ()
{
    # Restore the configuration file
    mv ${TMP_DIR}/config.php ${PKG_WEB_DIR}/conf/
    cp -pr ${TMP_DIR}/share/*/ ${PKG_WEB_DIR}/share/
    set_unix_permissions "${PKG_WEB_DIR}"

    # Needed to force correct permissions, during update
    # Extract the right paths from config file
    if [ -r "${CFG_FILE}" ]; then
        COMPLETE_FOLDER= `sed -n 's/^topDirectory[ ]*=[ ]*//p' ${CFG_FILE}`
        WATCHED_FOLDER=`sed -n 's/^watch_dir[ ]*=[ ]*//p' ${CFG_FILE}`

        # Apply synology permissions
        if [ -n "${COMPLETE_FOLDER}" ] && [ -d "${COMPLETE_FOLDER}" ]; then
            set_syno_permissions "${COMPLETE_FOLDER}" "${GROUP}"
        fi
        if [ -n "${WATCHED_FOLDER}" ] && [ -d "${WATCHED_FOLDER}" ]; then
            set_syno_permissions "${WATCHED_FOLDER}" "${GROUP}"
        fi

        # Apply linux permissions to temp-dir
        INCOMPLETE_FOLDER=`sed -n 's/^tempDirectory[ ]*=[ ]*//p' ${CFG_FILE}`
        if [ -n "${INCOMPLETE_FOLDER}" ] && [ -d "${INCOMPLETE_FOLDER}" ]; then
            set_unix_permissions "${INCOMPLETE_FOLDER}" "${GROUP}"
        fi
    fi
}
