SPK_NAME = synocli-disk
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/synocli-disk.png

MAINTAINER = SynoCommunity

include ../../mk/spksrc.common.mk

DEPENDS = cross/e2fsprogs cross/fuse cross/testdisk cross/ncdu cross/davfs2 cross/lsscsi

ifneq ($(findstring $(ARCH),$(ARM5_ARCHES) hi3535 powerpc ppc824x ppc853x ppc854x),$(ARCH))
# DAR: archs without C++11 support are not supported
DEPENDS += cross/dar
DESCRIPTION = "SynoCli Disk Tools provides a set of small command-line utilities: e2fsprogs, fuse, testdisk, ncdu, davfs2, lsscsi, dar"
else
DESCRIPTION = "SynoCli Disk Tools provides a set of small command-line utilities: e2fsprogs, fuse, testdisk, ncdu, davfs2, lsscsi"
endif
DISPLAY_NAME = SynoCli Disk Tools
STARTABLE = no

CHANGELOG = "1. Initial release"

HOMEPAGE = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliDisk
LICENSE  = Each tool is licensed under its respective license.

SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.spk.mk
