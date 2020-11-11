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
SPK_LINKS = /usr/local/bin/borg:env/bin/borg /usr/local/bin/borgmatic:env/bin/borgmatic

include ../../mk/spksrc.spk.mk
