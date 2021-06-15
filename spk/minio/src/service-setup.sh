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
}

if [ -f ${INST_VARIABLES} ]; then
  . ${INST_VARIABLES}
fi

export MINIO_ROOT_USER=$WIZARD_ACCESS_KEY
export MINIO_ROOT_PASSWORD=$WIZARD_SECRET_KEY
export HOME=${SYNOPKG_PKGVAR}

MINIO="${SYNOPKG_PKGDEST}/bin/minio"
SERVICE_COMMAND="${MINIO} server --quiet --anonymous ${WIZARD_DATA_DIRECTORY}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y
