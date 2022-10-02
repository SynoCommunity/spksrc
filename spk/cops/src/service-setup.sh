#!/bin/sh

# Package
PACKAGE_NAME="com.synocommunity.packages.${SYNOPKG_PKGNAME}"

# Others
CFG_FILE_NAME="config_local.php"
DEFAULT_CFG_FILE="${SYNOPKG_PKGDEST}/${CFG_FILE_NAME}.synology"
DSM6_WEB_DIR="/var/services/web"
if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
   WEB_DIR="/var/services/web_packages"
else
   WEB_DIR="${DSM6_WEB_DIR}"
fi
CFG_FILE="${WEB_DIR}/${SYNOPKG_PKGNAME}/${CFG_FILE_NAME}"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"

USER="http"
GROUP="http"
PHP_CONFIG_LOCATION="$([ "${BUILDNUMBER}" -ge "7135" ] && echo -n /usr/local/etc/php56/conf.d || echo -n /etc/php/conf.d)"

service_preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        if [ ! -f "${wizard_calibre_dir}/metadata.db" ]; then
            echo "Metadata.db cannot be found. Please verify that the Calibre directory was entered correctly."
            exit 1
        fi
    fi
}

service_postinst ()
{
      if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
    
        # Install the web interface
        cp -pR "${SYNOPKG_PKGDEST}/share/${SYNOPKG_PKGNAME}" "${WEB_DIR}"
    
        # Configure open_basedir
        echo -e "[PATH=${WEB_DIR}/${SYNOPKG_PKGNAME}]\nopen_basedir = Null" > "${PHP_CONFIG_LOCATION}/${PACKAGE_NAME}.ini"
      fi

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Create a default configuration file
        if [ ! -f "${CFG_FILE}" ]; then
          cp "${DEFAULT_CFG_FILE}" "${CFG_FILE}"
          url_rewriting=$([ "${wizard_use_url_rewriting}" == "true" ] && echo "1" || echo "0")
          sed -i -e "s|@calibre_dir@|${wizard_calibre_dir:=/volume1/calibre/}|g" ${CFG_FILE}
          sed -i -e "s|@cops_title@|${wizard_cops_title:=COPS}|g" ${CFG_FILE}
          sed -i -e "s|@use_url_rewriting@|${url_rewriting:=0}|g" ${CFG_FILE}
          chmod ga+w "${CFG_FILE}"
        fi

      if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then

        # Set permissions on directory structure (DSM 5+)
        set_syno_permissions "${wizard_calibre_dir}" "${GROUP}"
        # Set permissions on metadata.db
        if [ ! "`synoacltool -get "${wizard_calibre_dir}/metadata.db"| grep "group:${GROUP}:allow:rwxpdDaARWc."`" ]; then
            synoacltool -add "${wizard_calibre_dir}/metadata.db" "group:${GROUP}:allow:rwxpdDaARWc:----" > /dev/null 2>&1
        fi
      fi
    fi
}

service_postuninst ()
{
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then

      # Remove link
      rm -f "${SYNOPKG_PKGDEST}"
  
      # Remove open_basedir configuration
      rm -f "${PHP_CONFIG_LOCATION}/${PACKAGE_NAME}.ini"
  
      # Remove the web interface
      rm -fr "${WEB_DIR:?}/${SYNOPKG_PKGNAME}"
    
    fi
}

service_preupgrade ()
{
    # Save some stuff
    rm -fr "${TMP_DIR:?}/${SYNOPKG_PKGNAME}"
    mkdir -p "${TMP_DIR}/${SYNOPKG_PKGNAME}"
    mv "${CFG_FILE}" "${TMP_DIR}/${SYNOPKG_PKGNAME}/"
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
      mv "${PHP_CONFIG_LOCATION}/${PACKAGE_NAME}.ini" "${TMP_DIR}/${SYNOPKG_PKGNAME}/"
    fi
}

service_postupgrade ()
{
      # Restore some stuff
      rm -f "${CFG_FILE}"
      mv "${TMP_DIR}/${SYNOPKG_PKGNAME}/${CFG_FILE_NAME}" "${CFG_FILE}"
      if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        mv "${TMP_DIR}/${SYNOPKG_PKGNAME}/${PACKAGE_NAME}.ini" "${PHP_CONFIG_LOCATION}/"
      fi
      rm -fr "${TMP_DIR:?}/${SYNOPKG_PKGNAME}"
}
