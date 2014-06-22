#!/bin/sh

# Package
PACKAGE="postgresql"
DNAME="PostgreSQL"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
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
    ln -s /usr/bin/postgres ${INSTALL_DIR}/bin/postgres
    ln -s /usr/bin/clusterdb ${INSTALL_DIR}/bin/clusterdb
    ln -s /usr/bin/createdb ${INSTALL_DIR}/bin/createdb
    ln -s /usr/bin/createuser ${INSTALL_DIR}/bin/createuser
    ln -s /usr/bin/dropdb ${INSTALL_DIR}/bin/dropdb
    ln -s /usr/bin/dropuser ${INSTALL_DIR}/bin/dropuser
    ln -s /usr/bin/initdb ${INSTALL_DIR}/bin/initdb
    ln -s /usr/bin/pg_basebackup ${INSTALL_DIR}/bin/pg_basebackup
    ln -s /usr/bin/pg_controldata ${INSTALL_DIR}/bin/pg_controldata
    ln -s /usr/bin/pg_ctl ${INSTALL_DIR}/bin/pg_ctl
    ln -s /usr/bin/pg_dump ${INSTALL_DIR}/bin/pg_dump
    ln -s /usr/bin/pg_dumpall ${INSTALL_DIR}/bin/pg_dumpall
    ln -s /usr/bin/pg_isready ${INSTALL_DIR}/bin/pg_isready
    ln -s /usr/bin/pg_receivexlog ${INSTALL_DIR}/bin/pg_receivexlog
    ln -s /usr/bin/pg_resetxlog ${INSTALL_DIR}/bin/pg_resetxlog
    ln -s /usr/bin/pg_restore ${INSTALL_DIR}/bin/pg_restore
    ln -s /usr/bin/postgres ${INSTALL_DIR}/bin/postgres
    ln -s /usr/bin/postmaster ${INSTALL_DIR}/bin/postmaster
    ln -s /usr/bin/psql ${INSTALL_DIR}/bin/psql
    ln -s /usr/bin/reindexdb ${INSTALL_DIR}/bin/reindexdb
    ln -s /usr/bin/vacuumdb ${INSTALL_DIR}/bin/vacuumdb

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

            psql -U postgres -p5433 -d postgres -c "create user ${wizard_superuser_name} with createrole superuser password '${wizard_superuser_password}';"

            sleep 5

            su - ${USER} -c "${SSS} stop"


        [ -f ${PGDATA}/PG_VERSION ] && echo "... database initialization done"

        dbinited=1
        fi
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
