# Setup environment
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
GROUP="sc-minio"

INST_ETC="/var/packages/${SYNOPKG_PKGNAME}/etc"
INST_VARIABLES="${INST_ETC}/installer-variables"

service_postinst ()
{
    echo "WIZARD_DATA_DIRECTORY=${wizard_data_directory}" >> ${INST_VARIABLES}
    echo "WIZARD_ACCESS_KEY=${wizard_access_key}" >> ${INST_VARIABLES}
    echo "WIZARD_SECRET_KEY=${wizard_secret_key}" >> ${INST_VARIABLES}

    echo "Install busybox binaries"
    BIN=${SYNOPKG_PKGDEST}/bin
    $BIN/busybox --install $BIN
}

service_prestart ()
{
    if [ -f ${INST_VARIABLES} ]; then
      . ${INST_VARIABLES}
    fi

    SERVICE_OPTIONS="server --quiet --anonymous ${WIZARD_DATA_DIRECTORY}"
    
    export MINIO_ACCESS_KEY=$WIZARD_ACCESS_KEY
    export MINIO_SECRET_KEY=$WIZARD_SECRET_KEY

    # Required: start-stop-daemon do not set environment variables
    export HOME=${SYNOPKG_PKGVAR}
}
