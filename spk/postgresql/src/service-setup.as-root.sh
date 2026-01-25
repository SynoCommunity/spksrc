
# package user is defined in conf/privilege and must not contain '-'.
EFF_USER=sc_postgres

DATABASE_DIR="${SYNOPKG_PKGVAR}/data"
CFG_FILE="${DATABASE_DIR}/postgresql.conf"
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"

PG_USERNAME=${wizard_pg_username:=pgadmin}
PG_PASSWORD=${wizard_pg_password:=changepassword}
PG_PORT=${wizard_pg_port:=5433}

PG_BACKUP=${wizard_pg_dump_directory}
PG_BACKUP_CONF_DIR="${PG_BACKUP}/conf_`date +\"%d_%b\"`"
PG_BACKUP_DUMP_DIR="${PG_BACKUP}/databases_`date +\"%d_%b\"`"


service_postinst ()
{
  # EFF_USER running initdb is not allowd to create this folder
  mkdir -p ${DATABASE_DIR}
  chown -R ${EFF_USER}:sc-postgresql ${SYNOPKG_PKGVAR}

  # Init database and create default config file with UTF8 default encoding
  su - ${EFF_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/initdb -D ${DATABASE_DIR} --encoding=UTF8 --locale=en_US.UTF8"

  # update default config file
  # - Change port according to the wizard
  su - ${EFF_USER} -s /bin/sh -c "sed -e 's/^#port = 5432/port=${PG_PORT}/g' -i ${CFG_FILE}"

  # Change listen addresses
  su - ${EFF_USER} -s /bin/sh -c "sed -e \"s/^#listen_addresses = 'localhost'/listen_addresses = '*'/g\" -i ${CFG_FILE}"

  # Start server
  su - ${EFF_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${DATABASE_DIR} -l ${LOG_FILE} start"

  # Update existing role
  su - ${EFF_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/psql -p ${PG_PORT} -d postgres -c \"ALTER ROLE \\\"${EFF_USER}\\\" WITH PASSWORD '${PG_PASSWORD}'; \""

  # Create new role
  su - ${EFF_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/psql -p ${PG_PORT} -d postgres -c \"CREATE ROLE ${PG_USERNAME} PASSWORD '${PG_PASSWORD}' SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN REPLICATION BYPASSRLS; \""

  # Stop server
  su - ${EFF_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${DATABASE_DIR} stop"

  echo "SAVE_PG_USERNAME=${wizard_pg_username}" > ${INST_VARIABLES}
  echo "SAVE_PG_PASSWORD=${wizard_pg_password}" >> ${INST_VARIABLES}
  echo "SAVE_PG_PORT=${wizard_pg_port}" >> ${INST_VARIABLES}
}


service_preuninst ()
{
  # Backup on user's request
  if [ "$wizard_pg_dump_database" = "true" ]; then

    # Start server again
    su - ${EFF_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${DATABASE_DIR} -l ${LOG_FILE} start"

    # Create backup conf dir
    if [ ! -d ${PG_BACKUP_CONF_DIR} ]; then
        mkdir -p ${PG_BACKUP_CONF_DIR}
        chmod 755 ${PG_BACKUP_CONF_DIR}
    fi

    # Backup config files
    cp ${DATABASE_DIR}/pg_hba.conf ${PG_BACKUP_CONF_DIR}/
    cp ${DATABASE_DIR}/pg_ident.conf ${PG_BACKUP_CONF_DIR}/
    cp ${DATABASE_DIR}/postgresql.auto.conf ${PG_BACKUP_CONF_DIR}/
    cp ${DATABASE_DIR}/postgresql.conf ${PG_BACKUP_CONF_DIR}/

    # Create backup dump dir
    if [ ! -d ${PG_BACKUP_DUMP_DIR} ]; then
        mkdir -p ${PG_BACKUP_DUMP_DIR}
        chmod 777 ${PG_BACKUP_DUMP_DIR}
    fi

    # Backup all databases before uninstalling
    for database in $(su - ${EFF_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/psql -A -t -p ${PG_PORT} -U ${PG_USERNAME} -d postgres -c \"select datname from pg_database\"");
    do
        # Dump each database
        su - ${EFF_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/pg_dump -p ${PG_PORT} -U ${PG_USERNAME} -Fc ${database} >${PG_BACKUP_DUMP_DIR}/${database}.dump"
    done

    # Stop server
    su - ${EFF_USER} -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${DATABASE_DIR} stop"
  fi
}
