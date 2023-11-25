GITEA="${SYNOPKG_PKGDEST}/bin/gitea"
CONF_FILE="${SYNOPKG_PKGVAR}/conf.ini"
PATH="/var/packages/git/target/bin:${PATH}"

if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
    SYNOPKG_PKGHOME="${SYNOPKG_PKGDEST}"
fi

if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 6 ]; then
    SYNOPKG_PKGHOME="${SYNOPKG_PKGVAR}"
fi

ENV="PATH=${PATH} HOME=${SYNOPKG_PKGHOME}"

SERVICE_COMMAND="env ${ENV} ${GITEA} web --port ${SERVICE_PORT} --pid ${PID_FILE}"
SVC_BACKGROUND=y

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        IP=$(ip route get 1 | awk '{print $(NF);exit}')
    fi
}

service_preupgrade ()
{
    #Backup existing config on DSM6
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 6 ]; then
        if [-f "${SYNOPKG_PKGHOME}/conf.ini" ]; then
            echo "Backup old config on DSM6"  
            mv ${SYNOPKG_PKGHOME}/conf.ini ${SYNOPKG_PKGHOME}/conf.ini.bck 2>&1
        fi
    fi
}

service_postupgrade ()
{
    #Restore existing config on DSM6
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 6 ]; then
        if [-f "${SYNOPKG_PKGHOME}/conf.ini.bkc" ]; then
            echo "Restore old config on DSM6" 
            rm -f ${SYNOPKG_PKGHOME}/conf.ini
            mv ${SYNOPKG_PKGHOME}/conf.ini.bck ${SYNOPKG_PKGHOME}/conf.ini 2>&1
        fi
    fi
}