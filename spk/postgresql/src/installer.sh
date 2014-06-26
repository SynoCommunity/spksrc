#!/bin/sh

# Package
PACKAGE="postgresql"
DNAME="PostgreSQL"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/usr/bin:${PATH}"
USER="root"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
PGDATA="${INSTALL_DIR}/var/pgsqldata"
PGBACKUP="/volume1/homes/admin/PostgresBackup"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        dbinited=0
        if [ -d ${PGDATA} ]; then
            echo The ${PGDATA} directory already exists
        else
            echo "Initialize database & Super User ... "

            su - postgres -c "${INSTALL_DIR}/bin/pg_ctl -s -D ${PGDATA} initdb"

            cp -pR ${INSTALL_DIR}/etc/*.conf ${PGDATA}

            su - ${USER} -c "${SSS} start"

            sleep 5

            ${INSTALL_DIR}/bin/psql -U postgres -p5433 -d postgres -c "create user ${wizard_superuser_name} with createrole superuser password '${wizard_superuser_password}';"

            sleep 5

            su - ${USER} -c "${SSS} stop"


        [ -f ${PGDATA}/PG_VERSION ] && echo "... database initialization done"

        dbinited=1
        fi
    fi

    fi

    # Set pg_hba.conf allowed ip's to local network only
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" -a "${wizard_useownip_postgres}" == "true" ]; then
        echo "">> ${PGDATA}/pg_hba.conf
        echo "# IPv4 settings from installer :">> ${PGDATA}/pg_hba.conf
        echo "host    all             all             ${wizard_myip_postgres}             md5"  >> ${PGDATA}/pg_hba.conf
    else
        echo "">> ${PGDATA}/pg_hba.conf
        echo "# IPv4 settings from installer :">> ${PGDATA}/pg_hba.conf
        echo "host    all             all             `hostname -i`        md5" | sed -r "s/([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)[0-9]{1,3}/\10\\/24/"  >> ${PGDATA}/pg_hba.conf
    fi

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Backup Files
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" -a "${wizard_backup_postgres}" == "true" ]; then
        mkdir -p ${PGBACKUP}
        cp -pR ${INSTALL_DIR}/var ${PGBACKUP}
    fi

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${INSTALL_DIR}/var ${TMP_DIR}/${PACKAGE}

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/var
    mv ${TMP_DIR}/${PACKAGE}/var ${INSTALL_DIR}
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
