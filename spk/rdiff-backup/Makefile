SPK_NAME = rdiff-backup
SPK_VERS = 2.2.6
SPK_REV = 7
SPK_ICON = src/rdiff-backup.png

PYTHON_PACKAGE = python312
SPK_DEPENDS = "${PYTHON_PACKAGE}"
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) ${ARMv5_ARCHS}

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

DEPENDS = cross/librsync cross/attr cross/acl

# [PyYAML]
DEPENDS += cross/libyaml

MAINTAINER = SynoCommunity
DESCRIPTION = Reverse differential backup tool, over a network or locally.
STARTABLE = no
DISPLAY_NAME = rdiff-backup
CHANGELOG = "1. Migrate to Python 3.12."

HOMEPAGE = https://rdiff-backup.net/
LICENSE  = GPLv2

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

# https://github.com/SynoCommunity/spksrc/issues/4427
USE_ALTERNATE_TMPDIR = 1

SPK_USR_LOCAL_LINKS = bin:env/bin/rdiff-backup bin:env/bin/rdiff-backup-statistics

include ../../mk/spksrc.python.mk
