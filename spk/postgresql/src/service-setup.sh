DAEMON_USER=${EFF_USER}
DATABASE_DIR="${SYNOPKG_PKGDEST}/share/data"
CFG_FILE="${DATABASE_DIR}/postgresql.conf"
PATH="${SYNOPKG_PKGDEST}:${PATH}"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${DATABASE_DIR} -l ${DATABASE_DIR}/logfile start"

PG_USERNAME=${wizard_pg_username:=pgadmin}
PG_PASSWORD=${wizard_pg_password:=changepassword}
PG_PORT=${wizard_pg_port:=5433}

PG_BACKUP="/tmp/postgresql"
PG_BACKUP_CONF_DIR="${PG_BACKUP}_conf_`date +\"%d_%b\"`"
PG_BACKUP_DUMP_FILE_PREFIX="${PG_BACKUP}"
PG_BACKUP_DUMP_FILE_SUFFIX="`date +\"%d_%b\"`.dump"

SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{

   # Init database
   su - ${DAEMON_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/initdb -D ${DATABASE_DIR}"

   # Change default port
   su - ${DAEMON_USER} -s /bin/sh -c "sed -i -e 's/#port = 5432/port=${PG_PORT}/g' ${CFG_FILE}"

   # Change listen addresses
   su - ${DAEMON_USER} -s /bin/sh -c "sed -i -e \"s/#listen_addresses = 'localhost'/listen_addresses = '*'/g\" ${CFG_FILE}"

   # Start server
   su - ${DAEMON_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${DATABASE_DIR} -l ${DATABASE_DIR}/logfile start"

   # Update existing role
   su - ${DAEMON_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/psql -p ${PG_PORT} -d postgres -c \"ALTER ROLE \\\"${DAEMON_USER}\\\" WITH ENCRYPTED PASSWORD '${PG_PASSWORD}'; \""

   # Create new role 
   su - ${DAEMON_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/psql -p ${PG_PORT} -d postgres -c \"CREATE ROLE ${PG_USERNAME} ENCRYPTED PASSWORD '${PG_PASSWORD}' SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN REPLICATION BYPASSRLS; \""

   # Stop server
   su - ${DAEMON_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${DATABASE_DIR} stop"

}


service_preuninst ()
{

  # Backup only on user's request
  if [ "$pkgwizard_dump_database" = "true" ]; then

    # Create backup conf dir
    if [ ! -d ${PG_BACKUP_CONF_DIR} ]; then
      mkdir -p ${PG_BACKUP_CONF_DIR}
    fi
    # Backup config files
    cp ${DATABASE_DIR}/pg_hba.conf ${PG_BACKUP_CONF_DIR}/
    cp ${DATABASE_DIR}/pg_ident.conf ${PG_BACKUP_CONF_DIR}/
    cp ${DATABASE_DIR}/postgresql.auto.conf ${PG_BACKUP_CONF_DIR}/
    cp ${DATABASE_DIR}/postgresql.conf ${PG_BACKUP_CONF_DIR}/

    # Backup all databases before uninstalling
    #su - ${DAEMON_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/pg_dumpall -p ${PG_PORT} -U ${PG_USERNAME} >${PG_BACKUP_DUMP_FILE}"

    for database in `su - ${DAEMON_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/psql -A -t -p ${PG_PORT} -U ${PG_USERNAME} -d postgres -c \"select datname from pg_database\""`;
    do
   	    echo "Dumping database ${database}";
	    su - ${DAEMON_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/pg_dump -p ${PG_PORT} -U ${PG_USERNAME} -Fc ${database} >${PG_BACKUP_DUMP_FILE_PREFIX}_${database}_${PG_BACKUP_DUMP_FILE_SUFFIX}"
    done


  fi
}



