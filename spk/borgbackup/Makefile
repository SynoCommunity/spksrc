SPK_NAME = borgbackup
SPK_VERS = 1.1.13
SPK_REV = 7
SPK_ICON = src/$(SPK_NAME).png

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
BUILD_DEPENDS += cross/$(SPK_NAME)
DEPENDS = cross/bash cross/acl cross/attr
SPK_DEPENDS = "python3>=3.7"

# Requirements file generation
# virtualenv --python=python3 borg-env
# source borg-env/bin/activate
# pip install borgbackup borgmatic
# pip freeze | sed -r 's/^(borgbackup=|ruamel\.yaml=)/#\1/' > requirements.txt
WHEELS = src/requirements.txt

MAINTAINER = SynoCommunity
DESCRIPTION = Deduplicating backup program with compression and authenticated encryption.
RELOAD_UI = no
DISPLAY_NAME = Borg
STARTABLE = no
CHANGELOG = "Update openssl to 1.1."


HOMEPAGE = https://borgbackup.readthedocs.io
LICENSE  = BSD-3-Clause

SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.common.mk
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
SPK_USR_LOCAL_LINKS = bin:env/bin/borg bin:env/bin/borgmatic
else
SPK_LINKS = /usr/local/bin/borg:env/bin/borg /usr/local/bin/borgmatic:env/bin/borgmatic
endif

include ../../mk/spksrc.spk.mk
