#!/bin/sh

# Package
PACKAGE="letsencrypt"
DNAME="Lets Encrypt"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PACKAGE_LOG="${INSTALL_DIR}/var/package.log"
GIT_DIR="/usr/local/git"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin:${PATH}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${GIT_DIR}/bin:${PATH}"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"

pkg_def_intall_vol=$(/usr/syno/bin/servicetool --get-alive-volume)

# Here are the letsencrypt files are stored. Certs, logs, usw.
share_path=$pkg_def_intall_vol/$PACKAGE
letsencrypt_certs_directory="${share_path}/data"

# Function to send messages to logfile and stdout
# Usage:
# msg "your message"
msg ()
{
        DATE=`date "+%d.%m.%y %H:%M:%S"`
        message="$DATE: $1"

        echo $message >> ${PACKAGE_LOG}
}



preinst ()
{
	exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

	# Create var dir for LOG-file
    	mkdir -p ${INSTALL_DIR}/var

	# Create a Python virtualenv
	msg " Create a Python virtualenv"
	${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env > /dev/null

	# Log install
	msg "[ Installing package $(grep "version" /var/packages/${PACKAGE}/INFO) ]"

	# Install synology compatible python-augeas module
	msg "Install synology compatible python-augeas module"
	${INSTALL_DIR}/env/bin/pip install -r ${INSTALL_DIR}/share/python-augeas.req > /dev/null 2>&1

	# Install Letsencrypt & Letsencrypt-apache
	msg "Install Letsencrypt & Letsencrypt-apache"
	${INSTALL_DIR}/env/bin/pip install letsencrypt==0.1.1 > /dev/null 2>&1
	${INSTALL_DIR}/env/bin/pip install letsencrypt-apache==0.1.1 > /dev/null 2>&1

	if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
		/usr/syno/sbin/synoshare --get $PACKAGE > /dev/null 2>&1
		if [ $? != 0 ]; then
			# share doesn't exist we create it
			# synoshare --add sharename desc path Denylist rwlist rolist browsable{0|1} adv_privilege{0~7}
			# share only accessible for admin users, totally blocked for guest
			msg "Create share folder: $PACKAGE"
			/usr/syno/sbin/synoshare --add $PACKAGE "Let's Encrypt Datas" ${share_path} "guest" "admin" "" 1 0
		fi
		mkdir -p $letsencrypt_certs_directory
		echo ${wizard_email_adress:=admin@example.com} > $share_path/email.conf
		#sed -i -e "s|@MAIL_ADRESS@|${wizard_email_adress:=admin@example.com}|g" ${INSTALL_DIR}/bin/letsencrypt-synology.sh

	fi

	language=$(/bin/get_key_value /etc/synoinfo.conf language)
	# Verify if notifications messages are present in files notification_category
	cp /usr/syno/synoman/webman/texts/$language/notification_category $share_path/.

	if ! grep -q "LeaNoExtIp" "/usr/syno/synoman/webman/texts/$language/notification_category"; then
		echo 'LeaNoExtIp="mail,mobile,cms"' >> /usr/syno/synoman/webman/texts/$language/notification_category
	fi
	if ! grep -q "LeaNoExtAccess" "/usr/syno/synoman/webman/texts/$language/notification_category"; then
		echo 'LeaNoExtAccess="mail,mobile,cms"' >> /usr/syno/synoman/webman/texts/$language/notification_category
	fi
	if ! grep -q "LeaCmdFail" "/usr/syno/synoman/webman/texts/$language/notification_category"; then
		echo 'LeaCmdFail="mail,mobile,cms"' >> /usr/syno/synoman/webman/texts/$language/notification_category
	fi
	if ! grep -q "LeaCmdOk" "/usr/syno/synoman/webman/texts/$language/notification_category"; then
		echo 'LeaCmdOk="mail,mobile,cms"' >> /usr/syno/synoman/webman/texts/$language/notification_category
	fi
	if ! grep -q "LeaNoShare" "/usr/syno/synoman/webman/texts/$language/notification_category"; then
		echo 'LeaNoShare="mail,mobile,cms"' >> /usr/syno/synoman/webman/texts/$language/notification_category
	fi
	if ! grep -q "LeaNoEmail" "/usr/syno/synoman/webman/texts/$language/notification_category"; then
		echo 'LeaNoEmail="mail,mobile,cms"' >> /usr/syno/synoman/webman/texts/$language/notification_category
	fi

	cp /usr/syno/synoman/webman/texts/$language/mails $share_path/.
	# Verify if notifications messages are present in files mails
	if ! grep -q "LeaNoExtIp" "/usr/syno/synoman/webman/texts/$language/mails"; then
		cat ${INSTALL_DIR}/share/LeaNoExtIp.mails >> /usr/syno/synoman/webman/texts/$language/mails
	fi
	if ! grep -q "LeaNoExtAccess" "/usr/syno/synoman/webman/texts/$language/mails"; then
		cat ${INSTALL_DIR}/share/LeaNoExtAccess.mails >> /usr/syno/synoman/webman/texts/$language/mails
	fi
	if ! grep -q "LeaCmdFail" "/usr/syno/synoman/webman/texts/$language/mails"; then
		cat ${INSTALL_DIR}/share/LeaCmdFail.mails >> /usr/syno/synoman/webman/texts/$language/mails
	fi
	if ! grep -q "LeaCmdOk" "/usr/syno/synoman/webman/texts/$language/mails"; then
		cat ${INSTALL_DIR}/share/LeaCmdOk.mails >> /usr/syno/synoman/webman/texts/$language/mails
	fi
	if ! grep -q "LeaNoShare" "/usr/syno/synoman/webman/texts/$language/mails"; then
		cat ${INSTALL_DIR}/share/LeaNoShare.mails >> /usr/syno/synoman/webman/texts/$language/mails
	fi
	if ! grep -q "LeaNoEmail" "/usr/syno/synoman/webman/texts/$language/mails"; then
		cat ${INSTALL_DIR}/share/LeaNoEmail.mails >> /usr/syno/synoman/webman/texts/$language/mails
	fi
	# Set cron job to autorenew certs
	if ! grep -q "${INSTALL_DIR}/bin/letsencrypt-synology.sh" "/etc/crontab"; then
		msg "Set cron job to autorenew certs"
		cat "/etc/crontab" > "/etc/crontab.$$"
		echo "0	0	15	*	*	root	${INSTALL_DIR}/bin/letsencrypt-synology.sh" >> "/etc/crontab.$$"
		mv "/etc/crontab.$$" "/etc/crontab"
		# Restart crond
		/bin/kill -HUP `/bin/cat "/var/run/crond.pid"`
	fi

	# Log install done
    	msg "[ Package Install Completed ]"

	exit 0
}

preuninst ()
{
	# Remove cron job
	msg "Remove cron job"
	if grep -q "${INSTALL_DIR}/bin/letsencrypt-synology.sh" "/etc/crontab"; then
		grep -v "letsencrypt-synology.sh" "/etc/crontab" > "/etc/crontab.$$"
		mv "/etc/crontab.$$" "/etc/crontab"
		# Restart crond
		/bin/kill -HUP `/bin/cat "/var/run/crond.pid"`
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
    exit 0
}

postupgrade ()
{
    exit 0
}
