SPK_NAME = rdiff-backup
SPK_VERS = 2.2.6
SPK_REV = 6
SPK_ICON = src/rdiff-backup.png

PYTHON_PACKAGE = python311
SPK_DEPENDS = "python311>=3.11.5-8"
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

DEPENDS = cross/librsync cross/attr cross/acl

# [PyYAML]
DEPENDS += cross/libyaml

MAINTAINER = SynoCommunity
DESCRIPTION = Reverse differential backup tool, over a network or locally.
STARTABLE = no
DISPLAY_NAME = rdiff-backup
CHANGELOG = "1. Update to v2.2.6.<br/>2. Bring back support for ARMv5.<br/>3. Use alternate tmp dir."

HOMEPAGE = https://rdiff-backup.net/
LICENSE  = GPLv2

SERVICE_SETUP = src/service-setup.sh

# https://github.com/SynoCommunity/spksrc/issues/4427
USE_ALTERNATE_TMPDIR = 1

SPK_USR_LOCAL_LINKS = bin:env/bin/rdiff-backup bin:env/bin/rdiff-backup-statistics

include ../../mk/spksrc.python.mk
