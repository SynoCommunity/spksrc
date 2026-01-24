
if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
WEB_ROOT=/var/services/web
GROUP=http
else
WEB_ROOT=/var/services/web_packages
fi

WEB_DIR=${WEB_ROOT}/${SYNOPKG_PKGNAME}

service_postinst ()
{
    echo "Install the web app (${WEB_DIR})"

    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        # Install the web interface
        # only DSM 7+ installs the web service based on the "webservice" resource.
        cp -rp "${SYNOPKG_PKGDEST}/web/${SYNOPKG_PKGNAME}" ${WEB_ROOT}/
    fi
    
    if [ -d "${WEB_DIR}" ]; then
        if [ -n "${SHARE_NAME}" ]; then
            sed -e "s|@@shared_folder_name@@|${SHARE_NAME}|g" \
                -e "s|@@shared_folder_fullname@@|${SHARE_PATH}|g" \
                -i ${WEB_DIR}/index.php
        else
            echo "ERROR: SHARE_PATH is not defined"
        fi
    else
        echo "ERROR: ${WEB_DIR} does not exist"
    fi
}

service_postuninst ()
{
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        if [ -d "${WEB_DIR}" ]; then
            echo "Remove the web app (${WEB_DIR})"
            rm -rf ${WEB_DIR}
        fi
    fi
}
