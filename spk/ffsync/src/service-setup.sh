# Package
PACKAGE="ffsync"
DNAME="Firefox Sync Server 1.5"
INSTALL_DIR="/usr/local/${PACKAGE}"

# ffsync
PSERVE="${INSTALL_DIR}/env/bin/pserve"
INI_FILE="${INSTALL_DIR}/var/ffsync.ini"
PID_FILE="${INSTALL_DIR}/var/ffsync.pid"
LOG_FILE="${INSTALL_DIR}/var/pserve.log"

SERVICE_COMMAND="${PSERVE} ${INI_FILE} --daemon --pid-file=${PID_FILE} --log-file=${LOG_FILE}"

# Others
PYTHON_DIR="/usr/local/python"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
PATH="${INSTALL_DIR}/env/bin:${INSTALL_DIR}/bin:${PYTHON_DIR}/bin:${PATH}"

SERVICETOOL="/usr/syno/bin/servicetool"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

SC_USER="sc-ffsync"
LEGACY_USER="ffsync"
LEGACY_GROUP="nobody"
USER="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n ${SC_USER} || echo -n ${LEGACY_USER})"

# mock wizard vars which are used right now
wizard_mysql_root_password=""
wizard_password_ffsync="ffsync"
wizard_ffsync_public_url=""

# mysql vars
#@TODO: Will be filled from wizard
MYSQL_PORT="3306"
MYSQL_ROOT_USER="root"
MYSQL_ROOT_USER_PASSWORD=""
MYSQL_FFSYNC_DB="ffsync"
MYSQL_FFSYNC_USER="ffsync"
MYSQL_FFSYNC_USER_PASS="ffsync"


# specify password part for mysql command - if needed
PW_CMD=""
if [ -n "$MYSQL_ROOT_USER_PASSWORD" ]; then
	PW_CMD=" -p${MYSQL_ROOT_USER_PASSWORD}"
fi

# set mysql_bin
MYSQL_BIN_ERROR=""
MYSQL_BIN="$(which mysql)"
MYSQL_CMD=""
if [ -z "$MYSQL_BIN" ] || [ "${BUILDNUMBER}" -lt "7321" ]; then
	MYSQL_BIN_ERROR="The mysql binary could not be found."
else
	MYSQL_CMD="${MYSQL_BIN} -u ${MYSQL_ROOT_USER} ${PW_CMD} -P ${MYSQL_PORT} -B -N"
fi

# set mysqldump binary
MYSQLDUMP_BIN_ERROR=""
MYSQLDUMP_BIN="$(which mysqldump)"
if [ -z "$MYSQLDUMP_BIN" ] || [ "${BUILDNUMBER}" -lt "7321" ]; then
	MYSQLDUMP_BIN_ERROR="The mysqldump binary could not be found."
else
	MYSQLDUMP_CMD="${MYSQLDUMP_BIN} -u ${MYSQL_ROOT_USER} ${PW_CMD} -P ${MYSQL_PORT}"
fi

# old - unused
#SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
#TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
#DSM6_UPGRADE="${INSTALL_DIR}/var/.dsm6_upgrade"

service_preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
	
		# check if the mysql binary has been found
		if [ -z "$MYSQL_BIN" ]; then
			echo $MYSQL_BIN_ERROR
			exit 1
		fi

		# check if we can connect to the database as root
		CMD=$(($MYSQL_CMD -e "quit" ) 2>&1)
		if [ -n "${CMD}" ]; then
			echo "Can't connect to database: ${CMD}"
			exit 1
		fi
		
		# check if the user already exists
		CMD="$($MYSQL_CMD -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '$MYSQL_FFSYNC_USER')")"
		if [ "$CMD" = 1 ]; then
			echo "MySQL user ${MYSQL_FFSYNC_USER} already exists"
			exit 1
		fi
		
		# check if the database already exists
		CMD=$($MYSQL_CMD -e quit)
		if ${MYSQL_CMD} -e "SHOW DATABASES" | grep ^${MYSQL_FFSYNC_DB}$ > /dev/null 2>&1; then
			echo "MySQL database ${MYSQL_FFSYNC_DB} already exists"
			exit 1
		fi 
    fi
}

service_postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Create conf dir for 4.3 and add dependencies
    mkdir -p /var/packages/${PACKAGE}/conf && echo -e "[MariaDB]\ndsm_min_ver=5.0-4300\n\n[python]\npkg_min_ver=2.7.8-9" > /var/packages/${PACKAGE}/conf/PKG_DEPS

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Edit the configuration according to the wizard
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        ${MYSQL_BIN} -u root -p"${wizard_mysql_root_password}" -e "CREATE DATABASE ${PACKAGE}; GRANT ALL PRIVILEGES ON ${PACKAGE}.* TO '${USER}'@'localhost' IDENTIFIED BY '${wizard_password_ffsync:=ffsync}';"
        sed -i -e "s|@mysql_password@|${wizard_password_ffsync:=ffsync}|g" \
               -e "s|^#secret.*|secret = `openssl rand -base64 20`|g" \
               -e "s|http://0.0.0.0:8132|http://${wizard_ffsync_public_url}:8132|g" \
               ${INI_FILE}
    fi

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env > /dev/null

    # Install the wheels
    ${INSTALL_DIR}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${INSTALL_DIR}/share/wheelhouse ${INSTALL_DIR}/share/wheelhouse/*.whl > /dev/null 2>&1
    
    # Add port-forwarding config
    ${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null

    # Create legacy user
    if [ "${BUILDNUMBER}" -lt "7321" ]; then
        adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${LEGACY_GROUP} -s /bin/sh -S -D ${LEGACY_USER}
    fi

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

}

service_preuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
		# check if the mysql binary has been found
		if [ -z "$MYSQL_BIN" ]; then
			echo $MYSQL_BIN_ERROR
			exit 1
		fi

		# check if we can connect to the database as root
		CMD=$(($MYSQL_CMD -e "quit" ) 2>&1)
		if [ -n "${CMD}" ]; then
			echo "Can't connect to database: ${CMD}"
			exit 1
		fi
		
		# Check database export location
		if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" -a -n "${wizard_dbexport_path}" ]; then
			if [ -f "${wizard_dbexport_path}" -o -e "${wizard_dbexport_path}/${PACKAGE}.sql" ]; then
				echo "File ${wizard_dbexport_path}/${PACKAGE}.sql already exists. Please remove or choose a different location"
				exit 1
			fi
		fi
	fi

    # Stop the package
    ${SSS} stop > /dev/null

    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        # Remove the user (if not upgrading)
        delgroup ${LEGACY_USER} ${LEGACY_GROUP}
        deluser ${USER}

        # Remove firewall configuration
        ${SERVICETOOL} --remove-configure-file --package ${PACKAGE}.sc >> /dev/null
    fi

    exit 0
}

service_postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

    # Export and remove database
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        if [ -n "${wizard_dbexport_path}" ]; then
            mkdir -p ${wizard_dbexport_path}
            ${MYSQLDUMP_BIN} -u root -p"${wizard_mysql_root_password}" ${PACKAGE} > ${wizard_dbexport_path}/${PACKAGE}.sql
        fi
        ${MYSQL_BIN} -u root -p"${wizard_mysql_root_password}" -e "DROP DATABASE ${PACKAGE}; DROP LEGACY_USER '${LEGACY_USER}'@'localhost';"
    fi

    exit 0
}

