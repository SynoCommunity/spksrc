SPK_NAME = synocli-file
SPK_VERS = 1.0
SPK_REV = 2
SPK_ICON = src/synocli-file.png

include ../../mk/spksrc.common.mk

DEPENDS = cross/less cross/tree cross/ncdu cross/jdupes cross/rhash cross/mc cross/nano cross/file
DEPENDS += cross/detox cross/rmlint

MAINTAINER = SynoCommunity
DISPLAY_NAME = SynoCli File Tools
ifneq ($(findstring $(ARCH), powerpc ppc824x ppc853x ppc854x $(ARM5_ARCHES)),$(ARCH))
# to build rnm, GCC >= 4.8 is required, but not contained in older toolchains.
DEPENDS += cross/rnm
DESCRIPTION = "SynoCli File Tools provides a set of small command-line utilities: less, tree, ncdu, jdupes, rhash, mc \(midnight commander\), nano, file, detox, rmlint, rnm."
else
DESCRIPTION = "SynoCli File Tools provides a set of small command-line utilities: less, tree, ncdu, jdupes, rhash, mc \(midnight commander\), nano, file, detox, rmlint."
endif

STARTABLE = no
CHANGELOG = "Midnight-Commander: add sftp support;  Fix subshell; fix mouse handling; fix mcedit, mcview and mcdiff"

HOMEPAGE = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliFile
LICENSE  = Each tool is licensed under it\'s respective license.

SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.spk.mk

