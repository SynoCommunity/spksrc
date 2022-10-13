SPK_NAME = rdiff-backup
SPK_VERS = 2.0.5
SPK_REV = 4
SPK_ICON = src/rdiff-backup.png

BUILD_DEPENDS = cross/python310
DEPENDS = cross/librsync cross/attr cross/acl

# [PyYAML]
DEPENDS += cross/libyaml

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

SPK_DEPENDS = "python310"

MAINTAINER = SynoCommunity
DESCRIPTION = Reverse differential backup tool, over a network or locally.
STARTABLE = no
DISPLAY_NAME = rdiff-backup
CHANGELOG = "Update to v2.0.5 and update dependencies for Python 3.10"

HOMEPAGE = https://rdiff-backup.net/
LICENSE  = GPLv2

SERVICE_SETUP = src/service-setup.sh

SPK_USR_LOCAL_LINKS = bin:env/bin/rdiff-backup bin:env/bin/rdiff-backup-statistics

include ../../mk/spksrc.spk.mk
