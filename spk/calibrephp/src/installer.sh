#!/bin/sh

# Package
PACKAGE="calibrephp"
DNAME="CalibrePHP"
PACKAGE_NAME="com.synocommunity.packages.${PACKAGE}"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web"
DB_FILE="${WEB_DIR}/${PACKAGE}/app/Config/database.php"
USER="$([ $(grep buildnumber /etc.defaults/VERSION | cut -d"\"" -f2) -ge 4418 ] && echo -n http || echo -n nobody)"

preinst ()
{
	exit 0
}

postinst ()
{
	# Link
	ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

	# Install the web interface
	cp -pR ${INSTALL_DIR}/share/${PACKAGE} ${WEB_DIR}

	# Set permissions
	chmod -R ga+w ${WEB_DIR}/${PACKAGE}/app

	if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
		# Configure open_basedir
		if [ "${USER}" == "nobody" ]; then
			echo -e "<Directory \"${WEB_DIR}/${PACKAGE}\">\nphp_admin_value open_basedir ${WEB_DIR}/${PACKAGE}:${wizard_calibre_dir:=/volume1/calibre/} \n</Directory>" > /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf
		else
			echo -e "[PATH=${WEB_DIR}/${PACKAGE}]\nopen_basedir = ${WEB_DIR}/${PACKAGE}:${wizard_calibre_dir:=/volume1/calibre/}" > /etc/php/conf.d/${PACKAGE_NAME}.ini
		fi

		# Set metadata path
		if [ -f "${wizard_calibre_dir:=../}metadata.db" ]; then
			sed -i -e "s|../metadata.db|${wizard_calibre_dir:=../}metadata.db|g" ${DB_FILE}
			chmod ga+w ${DB_FILE}

			# Set permissions
			chmod ga+w ${wizard_calibre_dir:=/volume1/calibre/}
			chmod ga+w ${wizard_calibre_dir:=/volume1/calibre/}metadata.db
		fi
	fi

	exit 0
}

preuninst ()
{
	exit 0
}

postuninst ()
{
	# Remove link
	rm -f ${INSTALL_DIR}

	# Remove open_basedir configuration
	rm -f /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf
	rm -f /etc/php/conf.d/${PACKAGE_NAME}.ini

	# Remove the web interface
	rm -fr ${WEB_DIR}/${PACKAGE}

	exit 0
}

preupgrade ()
{
	# Save some stuff
	rm -fr ${TMP_DIR}/${PACKAGE}
	mkdir -p ${TMP_DIR}/${PACKAGE}
	mv ${DB_FILE} ${TMP_DIR}/${PACKAGE}/

	if [ "${USER}" == "nobody" ]; then
		mv /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf ${TMP_DIR}/${PACKAGE}/
	else
		mv /etc/php/conf.d/${PACKAGE_NAME}.ini ${TMP_DIR}/${PACKAGE}/
	fi

	exit 0
}

postupgrade ()
{
	# Restore some stuff
	rm -f ${DB_FILE}
	mv ${TMP_DIR}/${PACKAGE}/database.php ${DB_FILE}
	mv ${TMP_DIR}/${PACKAGE}/${PACKAGE}.conf /usr/syno/etc/sites-enabled-user
	mv ${TMP_DIR}/${PACKAGE}/${PACKAGE_NAME}.ini /etc/php/conf.d/
	rm -fr ${TMP_DIR}/${PACKAGE}

	exit 0
}
