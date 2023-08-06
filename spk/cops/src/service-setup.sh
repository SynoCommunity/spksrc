#!/bin/sh

# Package
PACKAGE_NAME="com.synocommunity.packages.${SYNOPKG_PKGNAME}"

# Others
CFG_FILE_NAME="config_local.php"
SECURITY_SETTINGS_FILE_NAME=".htaccess"
DEFAULT_CFG_FILE="${SYNOPKG_PKGDEST}/${CFG_FILE_NAME}.synology"

WEB_DIR="/var/services/web_packages"
SECURITY_SETTINGS_FILE="${WEB_DIR}/${SYNOPKG_PKGNAME}/${SECURITY_SETTINGS_FILE_NAME}"
CFG_FILE="${WEB_DIR}/${SYNOPKG_PKGNAME}/${CFG_FILE_NAME}"

USER="http"
GROUP="http"

validate_preinst ()
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
    fi
}

service_save ()
{
    # Save some stuff
    rm -fr "${TMP_DIR:?}/${SYNOPKG_PKGNAME}"
    mkdir -p "${TMP_DIR}/${SYNOPKG_PKGNAME}"
    # Save cops configuration file
    mv -v "${CFG_FILE}" "${TMP_DIR}/${SYNOPKG_PKGNAME}/"
    # Save .htaccess file
    mv -v "${SECURITY_SETTINGS_FILE}" "${TMP_DIR}/${SYNOPKG_PKGNAME}/"
}

service_restore ()
{
      # Restore some stuff
      rm -f "${CFG_FILE}"
      # Restore cops configuration file
      mv -v "${TMP_DIR}/${SYNOPKG_PKGNAME}/${CFG_FILE_NAME}" "${CFG_FILE}"
      # Restore .htaccess file
      mv -v "${TMP_DIR}/${SYNOPKG_PKGNAME}/${SECURITY_SETTINGS_FILE_NAME}" "${SECURITY_SETTINGS_FILE}"
      
      rm -d "${TMP_DIR}/${SYNOPKG_PKGNAME}" "${TMP_DIR}"
}
