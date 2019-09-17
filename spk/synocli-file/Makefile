include ../../mk/spksrc.common.mk

SPK_NAME = synocli-file
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/synocli-file.png

DEPENDS = cross/jdupes cross/less cross/tree cross/rhash cross/mc cross/nano cross/ncdu

MAINTAINER = m4tt075
DESCRIPTION = "SynoCli File Tools provides a set of small command-line utilities: jdupes, less, tree, rhash, mc \(midnight commander\), nano, ncdu. Credits to Sebastian Schmidt \(publicarray\) for icons"
DISPLAY_NAME = SynoCli File Tools
STARTABLE = no
CHANGELOG = "1. Initial release"

HOMEPAGE   = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliFile
LICENSE    = Mixed

SERVICE_SETUP = src/service-setup.sh

POST_STRIP_TARGET = synoclifile_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: synoclifile_extra_install
synoclifile_extra_install:
	install -m 755 src/mc-utf8 $(STAGING_DIR)/bin/mc-utf8
