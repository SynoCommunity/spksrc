#!/bin/sh

# Adjust user specific configuration for byobu-config to work
# 1. Prerequisites: byobu must have been called initially by the user
#    to create configuration in the users home folder
# 2. link python-newt specific files to user site-packages
# 3. define BYOBU_PYTHON

BYOBU_RC=~/.byoburc

[ -e ${BYOBU_RC} ] || (echo "ERROR: ${BYOBU_RC} does not exist" && exit -1)
[ -w ${BYOBU_RC} ] || (echo "ERROR: ${BYOBU_RC} is not writeable" && exit -1)

# link site packages
BYOBU_SITE_PACKAGES=~/.local/lib/python3.12/site-packages
mkdir -p ${BYOBU_SITE_PACKAGES}
ln -sf /var/packages/byobu/target/lib/python3.12/site-packages/_snack.so ${BYOBU_SITE_PACKAGES}/_snack.so
ln -sf /var/packages/byobu/target/lib/python3.12/site-packages/snack.py  ${BYOBU_SITE_PACKAGES}/snack.py

# define python3 executable
sed -e '/export BYOBU_PYTHON/d' -i ${BYOBU_RC}
echo  "export BYOBU_PYTHON='/var/packages/python312/target/bin/python3'" >> ${BYOBU_RC}
