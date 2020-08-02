SPK_NAME = rdiff-backup
SPK_VERS = 2.0.3
SPK_REV = 3
SPK_ICON = src/rdiff-backup.png

BUILD_DEPENDS = cross/python3
DEPENDS = cross/librsync cross/attr cross/acl

WHEELS = src/requirements.txt

SPK_DEPENDS = "python3>=3.7"

MAINTAINER = SynoCommunity
DESCRIPTION = Reverse differential backup tool, over a network or locally.
STARTABLE = no
DISPLAY_NAME = rdiff-backup
CHANGELOG = "Update to v2.0.3 and update dependencies for python3."

HOMEPAGE = https://rdiff-backup.net/
LICENSE  = GPLv2

SERVICE_SETUP = src/service-setup.sh


include ../../mk/spksrc.spk.mk
