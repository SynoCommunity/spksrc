
# Package
SC_DNAME="PHPMemcachedAdmin"
SC_PKG_PREFIX="com-synocommunity-packages-"
SC_PKG_NAME="${SC_PKG_PREFIX}${SYNOPKG_PKGNAME}"
SVC_KEEP_LOG=y
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# Others
if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
   WEB_DIR="/var/services/web_packages"
else
   WEB_DIR="/var/services/web"
   # DSM 6 file and process ownership
   WEB_USER="http"
   WEB_GROUP="http"
   # For owner of var folder
   GROUP="http"
fi
WEB_ROOT="${WEB_DIR}/${SYNOPKG_PKGNAME}"
CONFIG_DIR="${SYNOPKG_PKGVAR}/phpmemcachedadmin.config"
SYNOSVC="/usr/syno/sbin/synoservice"

validate_preinst ()
{
   # Check for modification to PHP template defaults on DSM 6
   if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
      WS_TMPL_DIR="/var/packages/WebStation/target/misc"
      WS_TMPL_FILE="php74_fpm.mustache"
      WS_TMPL_PATH="${WS_TMPL_DIR}/${WS_TMPL_FILE}"
      # Check for PHP template defaults
      if ! grep -q -E '^user = http$' "${WS_TMPL_PATH}" || ! grep -q -E '^listen\.owner = http$' "${WS_TMPL_PATH}"; then
            echo "PHP template defaults have been modified. Installation is not supported."
            exit 1
      fi
   fi
}

service_postinst ()
{
   # Create config file on demand
   if [ ! -e ${CONFIG_DIR}/Memcache.php ]; then
      echo "Create default config file Memcache.php"
      cp -f ${CONFIG_DIR}/Memcache.sample.php ${CONFIG_DIR}/Memcache.php
   fi

   # Web interface setup for DSM 6 -- used by INSTALL and UPGRADE
   if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
      # Install the web interface
      echo "Installing web interface"
      ${MKDIR} ${WEB_ROOT}
      rsync -aX ${SYNOPKG_PKGDEST}/share/${SYNOPKG_PKGNAME}/ ${WEB_ROOT} 2>&1

      # Install web configurations
      TEMPDIR="${SYNOPKG_PKGTMP}/web"
      ${MKDIR} ${TEMPDIR}
      WS_CFG_DIR="/usr/syno/etc/packages/WebStation"
      WS_CFG_FILE="WebStation.json"
      WS_CFG_PATH="${WS_CFG_DIR}/${WS_CFG_FILE}"
      TMP_WS_CFG_PATH="${TEMPDIR}/${WS_CFG_FILE}"
      PHP_CFG_FILE="PHPSettings.json"
      PHP_CFG_PATH="${WS_CFG_DIR}/${PHP_CFG_FILE}"
      TMP_PHP_CFG_PATH="${TEMPDIR}/${PHP_CFG_FILE}"
      PHP_PROF_NAME="Default PHP 7.4 Profile"
      WS_BACKEND="$(jq -r '.default.backend' ${WS_CFG_PATH})"
      WS_PHP="$(jq -r '.default.php' ${WS_CFG_PATH})"
      RESTART_APACHE="no"
      RSYNC_ARCH_ARGS="--backup --suffix=.bak --remove-source-files"
      # Check if Apache is the selected back-end
      if [ ! "$WS_BACKEND" = "2" ]; then
            echo "Set Apache as the back-end server"
            jq '.default.backend = 2' ${WS_CFG_PATH} > ${TMP_WS_CFG_PATH}
            rsync -aX ${RSYNC_ARCH_ARGS} ${TMP_WS_CFG_PATH} ${WS_CFG_DIR}/ 2>&1
            RESTART_APACHE="yes"
      fi
      # Check if default PHP profile is selected
      if [ -z "$WS_PHP" ] || [ "$WS_PHP" = "null" ]; then
            echo "Enable default PHP profile"
            # Locate default PHP profile
            PHP_PROF_ID="$(jq -r '. | to_entries[] | select(.value | type == "object" and .profile_desc == "'"$PHP_PROF_NAME"'") | .key' "${PHP_CFG_PATH}")"
            jq ".default.php = \"$PHP_PROF_ID\"" "${WS_CFG_PATH}" > ${TMP_WS_CFG_PATH}
            rsync -aX ${RSYNC_ARCH_ARGS} ${TMP_WS_CFG_PATH} ${WS_CFG_DIR}/ 2>&1
            RESTART_APACHE="yes"
      fi
      # Check for PHP profile
      if ! jq -e ".[\"${SC_PKG_NAME}\"]" "${PHP_CFG_PATH}" >/dev/null; then
            echo "Add PHP profile for ${SC_DNAME}"
            jq --slurpfile newProfile ${SYNOPKG_PKGDEST}/web/${SYNOPKG_PKGNAME}.json '.["'"${SC_PKG_NAME}"'"] = $newProfile[0]' ${PHP_CFG_PATH} > ${TMP_PHP_CFG_PATH}
            rsync -aX ${RSYNC_ARCH_ARGS} ${TMP_PHP_CFG_PATH} ${WS_CFG_DIR}/ 2>&1
            RESTART_APACHE="yes"
      fi
      # Check for Apache config
      if [ ! -f "/usr/local/etc/apache24/sites-enabled/${SYNOPKG_PKGNAME}.conf" ]; then
            echo "Add Apache config for ${SC_DNAME}"
            rsync -aX ${SYNOPKG_PKGDEST}/web/${SYNOPKG_PKGNAME}.conf /usr/local/etc/apache24/sites-enabled/ 2>&1
            RESTART_APACHE="yes"
      fi
      # Restart Apache if configs have changed
      if [ "$RESTART_APACHE" = "yes" ]; then
            if jq -e 'to_entries | map(select((.key | startswith("'"${SC_PKG_PREFIX}"'")) and .key != "'"${SC_PKG_NAME}"'")) | length > 0' "${PHP_CFG_PATH}" >/dev/null; then
               echo " [WARNING] Multiple PHP profiles detected, will require restart of DSM to load new configs"
            else
               echo "Restart Apache to load new configs"
               ${SYNOSVC} --restart pkgctl-Apache2.4
            fi
      fi
      # Clean-up temporary files
      ${RM} ${TEMPDIR}

      # Make config writable by http group
      chmod -R g+w ${CONFIG_DIR} 2>/dev/null

      # Make web folder writable by http group
      chown -R ${WEB_USER}:${WEB_GROUP} ${WEB_ROOT} 2>/dev/null
      chmod -R g+w ${WEB_ROOT} 2>/dev/null
   fi
}

service_postuninst ()
{
    # Web interface removal for DSM 6 -- used by UNINSTALL and UPGRADE
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        # Remove the web interface
        echo "Removing web interface"
        ${RM} ${WEB_ROOT}

        # Remove web configurations
        TEMPDIR="${SYNOPKG_PKGTMP}/web"
        ${MKDIR} ${TEMPDIR}
        WS_CFG_DIR="/usr/syno/etc/packages/WebStation"
        PHP_CFG_FILE="PHPSettings.json"
        PHP_CFG_PATH="${WS_CFG_DIR}/${PHP_CFG_FILE}"
        TMP_PHP_CFG_PATH="${TEMPDIR}/${PHP_CFG_FILE}"
        RESTART_APACHE="no"
        RSYNC_ARCH_ARGS="--backup --suffix=.bak --remove-source-files"
        # Check for PHP profile
        if jq -e ".[\"${SC_PKG_NAME}\"]" "${PHP_CFG_PATH}" >/dev/null; then
            echo "Removing PHP profile for ${SC_DNAME}"
            jq 'del(.["'"${SC_PKG_NAME}"'"])' ${PHP_CFG_PATH} > ${TMP_PHP_CFG_PATH}
            rsync -aX ${RSYNC_ARCH_ARGS} ${TMP_PHP_CFG_PATH} ${WS_CFG_DIR}/ 2>&1
            ${RM} "${WS_CFG_DIR}/php_profile/${SC_PKG_NAME}"
            RESTART_APACHE="yes"
        fi
        # Check for Apache config
        if [ -f "/usr/local/etc/apache24/sites-enabled/${SYNOPKG_PKGNAME}.conf" ]; then
            echo "Removing Apache config for ${SC_DNAME}"
            ${RM} /usr/local/etc/apache24/sites-enabled/${SYNOPKG_PKGNAME}.conf
            RESTART_APACHE="yes"
        fi
        # Restart Apache if configs have changed
        if [ "$RESTART_APACHE" = "yes" ]; then
            if jq -e 'to_entries | map(select((.key | startswith("'"${SC_PKG_PREFIX}"'")) and .key != "'"${SC_PKG_NAME}"'")) | length > 0' "${PHP_CFG_PATH}" >/dev/null; then
                echo " [WARNING] Multiple PHP profiles detected, will require restart of DSM to load new configs"
            else
                echo "Restart Apache to load new configs"
                ${SYNOSVC} --restart pkgctl-Apache2.4
            fi
        fi
        # Clean-up temporary files
        ${RM} ${TEMPDIR}
    fi
}
