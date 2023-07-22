SPK_NAME = rdiff-backup
SPK_VERS = 2.0.5
SPK_REV = 5
SPK_ICON = src/rdiff-backup.png

BUILD_DEPENDS = cross/python311
DEPENDS = cross/librsync cross/attr cross/acl

# [PyYAML]
DEPENDS += cross/libyaml

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

SPK_DEPENDS = "python311"

MAINTAINER = SynoCommunity
DESCRIPTION = Reverse differential backup tool, over a network or locally.
STARTABLE = no
DISPLAY_NAME = rdiff-backup
CHANGELOG = "1. Update to v2.0.5<br/>2. Migrate to Python 3.11"

HOMEPAGE = https://rdiff-backup.net/
LICENSE  = GPLv2

SERVICE_SETUP = src/service-setup.sh

SPK_USR_LOCAL_LINKS = bin:env/bin/rdiff-backup bin:env/bin/rdiff-backup-statistics

include ../../mk/spksrc.spk.mk
