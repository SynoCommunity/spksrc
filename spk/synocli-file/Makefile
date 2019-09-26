SPK_NAME = synocli-file
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/synocli-file.png

include ../../mk/spksrc.common.mk

DEPENDS = cross/less cross/tree cross/ncdu cross/jdupes cross/rhash cross/mc cross/nano cross/file
DEPENDS += cross/detox cross/rmlint
ifneq ($(findstring $(ARCH), powerpc ppc824x ppc853x ppc854x $(ARM5_ARCHES)),$(ARCH))
# to build rnm, GCC >= 4.8 is required, but not contained in older toolchains.
DEPENDS += cross/rnm
endif

MAINTAINER = SynoCommunity
DISPLAY_NAME = SynoCli File Tools
ifneq ($(findstring $(ARCH), powerpc ppc824x ppc853x ppc854x $(ARM5_ARCHES)),$(ARCH))
DESCRIPTION = "SynoCli File Tools provides a set of small command-line utilities: less, tree, ncdu, jdupes, rhash, mc \(midnight commander\), nano, file, detox, rmlint, rnm."
else
DESCRIPTION = "SynoCli File Tools provides a set of small command-line utilities: less, tree, ncdu, jdupes, rhash, mc \(midnight commander\), nano, file, detox, rmlint."
endif

STARTABLE = no
CHANGELOG = "1. Initial release"

HOMEPAGE   = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliFile
LICENSE    = Each tool is licensed by it\'s own.

SERVICE_SETUP = src/service-setup.sh

POST_STRIP_TARGET = synoclifile_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: synoclifile_extra_install
synoclifile_extra_install:
	install -m 755 src/mc-utf8 $(STAGING_DIR)/bin/mc-utf8
