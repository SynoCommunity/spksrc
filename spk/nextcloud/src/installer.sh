#!/bin/sh

# Package
PACKAGE="nextcloud"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"

# New role for embedded PostgreSQL
PG_USERNAME=${wizard_pg_username:=pgadmin}
PG_PASSWORD=${wizard_pg_password:=changepassword}

preinst ()
{
    
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Embedded PostgreSQL local access
    echo "host    all             all             127.0.0.1/24            md5" >>/etc/postgresql/pg_hba.conf

    # Embedded PostgreSQL new role to have enough access rights for NextCloud
    su - postgres -s /bin/sh -c "/usr/bin/psql -d postgres -c \"CREATE ROLE ${PG_USERNAME} ENCRYPTED PASSWORD '${PG_PASSWORD}' SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN REPLICATION; \""

    # Web directory
    cp -R ${INSTALL_DIR}/share/nextcloud/ /var/services/web/${PACKAGE}/
    chown -R http:http /var/services/web/${PACKAGE}/
    chmod -R 0770 /var/services/web/${PACKAGE}/

    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{

    # Web directory
    rm -rf /var/services/web/${PACKAGE}/

    # Remove embedded PostgreSQL local access
    sed -i '/host    all             all             127.0.0.1\/24            md5/d'  /etc/postgresql/pg_hba.conf

    # Drop embedded PostgreSQL new role 
    su - postgres -s /bin/sh -c "/usr/bin/psql -d postgres -c \"DROP ROLE ${PG_USERNAME}; \""

    # Link
    rm -f ${INSTALL_DIR}

    exit 0
}

preupgrade ()
{
    exit 0
}

postupgrade ()
{
    exit 0
}
