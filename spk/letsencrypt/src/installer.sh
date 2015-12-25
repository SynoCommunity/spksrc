#!/bin/sh

# Package
PACKAGE="letsencrypt"
DNAME="Lets Encrypt"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
GIT_DIR="/usr/local/git"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin:${PATH}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${GIT_DIR}/bin:${PATH}"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"

# Here are the letsencrypt files are stored. Certs, logs, usw.
letsencrypt_certs_directory="${INSTALL_DIR}/data"

preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env > /dev/null

	# Install synology compatible python-augeas module
	${INSTALL_DIR}/env/bin/pip install -r ${INSTALL_DIR}/share/python-augeas.req > /dev/null 2>&1
	
	# Install Letsencrypt & Letsencrypt-apache
	${INSTALL_DIR}/env/bin/pip install letsencrypt==0.1.1 > /dev/null 2>&1
	${INSTALL_DIR}/env/bin/pip install letsencrypt-apache==0.1.1 > /dev/null 2>&1
	
	sed -i -e "s|@MAIL_ADRESS@|${wizard_email_adress:=admin@example.com}|g" ${INSTALL_DIR}/bin/letsencrypt-synology.sh
	
	# Set cron job to autorenew certs
	if ! grep -q "${INSTALL_DIR}/bin/letsencrypt-synology.sh" "/etc/crontab"; then
		cat "/etc/crontab" > "/etc/crontab.$$"
		echo "0	0	5,15,25	*	*	root	${INSTALL_DIR}/bin/letsencrypt-synology.sh" >> "/etc/crontab.$$"
		mv "/etc/crontab.$$" "/etc/crontab"
		# Restart crond
		/bin/kill -HUP `/bin/cat "/var/run/crond.pid"`
	fi	
    exit 0
}

preuninst ()
{
	# Remove cron job
	if grep -q "${INSTALL_DIR}/bin/letsencrypt-synology.sh" "/etc/crontab"; then
		grep -v "letsencrypt-synology.sh" "/etc/crontab" > "/etc/crontab.$$"
		mv "/etc/crontab.$$" "/etc/crontab"
		# Restart crond
		/bin/kill -HUP `/bin/cat "/var/run/crond.pid"`
	fi
	
	# Save data directory before uninstalling
	tar -cf /volume1/public/letsencrypt.tar.gz $letsencrypt_certs_directory
	
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
    exit 0
}

postupgrade ()
{
    exit 0
}
