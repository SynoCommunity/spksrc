SPK_NAME = synocli-file
SPK_VERS = 1.1
SPK_REV = 2
SPK_ICON = src/synocli-file.png

include ../../mk/spksrc.common.mk

DEPENDS = cross/less cross/tree cross/ncdu cross/jdupes cross/rhash cross/mc cross/nano cross/file
DEPENDS += cross/detox

MAINTAINER = SynoCommunity
DISPLAY_NAME = SynoCli File Tools

OPTIONAL_DESC =

# PPC_ARCHES except QorIQ
ifneq ($(findstring $(ARCH), powerpc ppc824x ppc853x ppc854x),$(ARCH))
DEPENDS += cross/rmlint
OPTIONAL_DESC += , rmlint
endif

ifneq ($(findstring $(ARCH), powerpc ppc824x ppc853x ppc854x $(ARM5_ARCHES)),$(ARCH))
# to build rnm, GCC >= 4.8 is required, but not contained in older toolchains.
DEPENDS += cross/rnm
OPTIONAL_DESC += , rnm
endif

DESCRIPTION = "SynoCli File Tools provides a set of small command-line utilities: less, tree, ncdu, jdupes, rhash, mc \(midnight commander\), nano, file, detox$(OPTIONAL_DESC)."
STARTABLE = no
CHANGELOG = "Midnight-Commander: add sftp support;  Fix subshell; fix mouse handling; fix mcedit, mcview and mcdiff"

HOMEPAGE = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliFile
LICENSE  = Each tool is licensed under it\'s respective license.

SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.spk.mk

