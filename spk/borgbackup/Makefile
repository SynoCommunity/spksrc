SPK_NAME = borgbackup
SPK_VERS = 1.1.17
SPK_REV = 9
SPK_ICON = src/$(SPK_NAME).png

BUILD_DEPENDS = cross/python38
DEPENDS = cross/$(SPK_NAME)

SPK_DEPENDS = "python38"

# Requirements file generation
# cd src
# /spksrc/native/python38/work-native/install/usr/local/bin/python3 -m venv borg-env
# . borg-env/bin/activate
# pip install  ../work-x64-6.1/install/var/packages/borgbackup/target/share/wheelhouse/borgbackup*.whl borgmatic
# pip freeze > requirements.txt
# deactivate
# adjust the first line in requirements.txt to "#borgbackup==1.1.17"
WHEELS = src/requirements.txt

MAINTAINER = SynoCommunity
DESCRIPTION = Deduplicating backup program with compression and authenticated encryption.

DISPLAY_NAME = Borg
STARTABLE = no
CHANGELOG = "1. Update borgbackup to v1.1.17 and borgmatic to v1.5.18.<br/>2. Update OpenSSL to v1.1.1l."

HOMEPAGE = https://borgbackup.readthedocs.io
LICENSE  = BSD-3-Clause
LICENSE_FILE = $(WORK_DIR)/$(SPK_NAME)-$(SPK_VERS)/LICENSE

SERVICE_SETUP = src/service-setup.sh

SPK_USR_LOCAL_LINKS = bin:env/bin/borg bin:env/bin/borgmatic

include ../../mk/spksrc.spk.mk
