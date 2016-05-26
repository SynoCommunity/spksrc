#!/bin/sh

# Include in installer with:
# . `dirname $0`/common

PYTHON_DIR="/usr/local/python"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
SERVICETOOL="/usr/syno/bin/servicetool"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"

HTTPUSER="$([ "${BUILDNUMBER}" -ge "4418" ] && echo -n http || echo -n nobody)"

# Synology commands
MYSQL="$([ "${BUILDNUMBER}" -ge "7135" ] && echo -n /bin/mysql || echo -n /usr/syno/mysql/bin/mysql)"
MYSQLDUMP="$([ "${BUILDNUMBER}" -ge "7135" ] && echo -n /bin/mysqldump || echo -n /usr/syno/mysql/bin/mysqldump)"
PHP="$([ "${BUILDNUMBER}" -ge "7135" ] && echo -n /usr/local/bin/php56 || echo -n /usr/bin/php)"

check_dir_exist ()
{
    # Checks if directory exists. If not, halt installer and show an error.
    # Usage: check_dir_exist "${wizard_download_dir}"
    if [ -n "$1" -a ! -d "$1" ]; then
        echo "Directory $1 does not exist. Please create the directory."
        exit 1
    fi
}

install_wheels ()
{
    # Default function to install wheels into a virtualenv
    ${INSTALL_DIR}/env/bin/pip install --use-wheel --no-deps --no-index -U --force-reinstall \
                                      -f ${INSTALL_DIR}/share/wheelhouse \
                                      -r ${INSTALL_DIR}/share/wheelhouse/requirements.txt \
                                      > /dev/null 2>&1
}

create_legacy_user ()
{
    # Creates a user for DSM5 and lower
    # Usage: create_legacy_user ${USER} ${GROUP}
    if [ "${BUILDNUMBER}" -lt "7135" ]; then
        adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G $2 -s /bin/sh -S -D $1
    fi
}

remove_legacy_user ()
{
    # Removes user on DSM5 and lower
    # Usage: remove_legacy_user ${USER} ${GROUP}
    if [ "${BUILDNUMBER}" -lt "7135" ]; then
        delgroup $1 $2
        deluser $1
    fi
}

dsm6_remove_legacy_user ()
{
    # Removes legacy user when on DSM6
    # Usage: dsm6_remove_legacy_user ${USER} ${GROUP}
    # Prerequisite: DELUSER and DELGROUP must be defined in installer
    if [ "${BUILDNUMBER}" -ge "7135" ]; then
        ${DELGROUP} $1 $2
        ${DELUSER} $1
    fi
}

remove_syno_user ()
{
    # Removes DSM6 user
    # Usage: remove_syno_user ${USER}
    # Prerequisite: DELUSER location must be defined in installer
    if [ "${BUILDNUMBER}" -ge "7135" ]; then
        ${DELUSER} $1
        synouser --rebuild all
    fi
}

create_syno_group ()
{
    # Creates a group manageable via DSM GUI
    # Usage: create_syno_group "${SYNO_GROUP}" "${SYNO_GROUP_DESC}" "${USER}"
    # Create group and set description
    synogroup --add $1 $3 > /dev/null
    synogroup --descset $1 $2 > /dev/null
    # Adds user to group
    addgroup $3 $1
}

remove_syno_group ()
{
    # Removes a Synology group 
    # Usage: remove_syno_group "${USER}" "${GROUP}"
    # Remove user from group 
    delgroup "$1" "$2"
    # Remove SYNO_GROUP if empty
    if ! synogroup --get "$2" | grep -q "0:"; then
        synogroup --del "$2" > /dev/null
    fi
    # Force GUI update
    synogroup --rebuild all
}

set_syno_permissions ()
{
    # Sets recursive permissions for ${SYNO_GROUP} on specified directory
    # Usage: set_syno_permissions "${wizard_download_dir}"
    DIRNAME=$1
    VOLUME=`echo $1 | awk -F/ '{print "/"$2}'`
    # Set read/write permissions for SYNO_GROUP
    synoacltool -add "${DIRNAME}" "group:${SYNO_GROUP}:allow:rwxpdDaARWc--:fd--" > /dev/null
    while test "${DIRNAME}" != "${VOLUME}"; do
        # Walk up the tree and set traverse permissions up to SYNO_VOLUME
        DIRNAME="$(dirname \"${DIRNAME}\")"
        if [ ! "`synoacltool -get \"${DIRNAME}\"| grep \"group:${SYNO_GROUP}:allow:..x\"`" ]; then
            synoacltool -add "${DIRNAME}" "group:${SYNO_GROUP}:allow:--x----------:---n" > /dev/null
        fi
    done
}

set_legacy_permissions ()
{
    # Usage: set_legacy_permissions "${wizard_download_dir}"
    if [ "${BUILDNUMBER}" -ge "4418" ] && [ "${BUILDNUMBER}" -lt "7135" ]; then
        chgrp users $1
        chmod g+rwx $1
    fi
}
