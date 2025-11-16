SPK_NAME = nushell
SPK_VERS = 0.108.0
SPK_REV = 1
SPK_ICON = src/nushell.png

DEPENDS = cross/nushell

REQUIRED_MIN_DSM = 7.0

MAINTAINER = SynoCommunity
DESCRIPTION = A new type of shell. This package includes the nushell plugins 'inc' 'polars' 'gstat' 'formats' and 'query'.
DISPLAY_NAME = nu
STARTABLE = no
CHANGELOG = "Initial package release"

HOMEPAGE = https://www.nushell.sh/
LICENSE = MIT

POST_STRIP_TARGET = nushell_extra_install

SPK_COMMANDS = bin/nu

include ../../mk/spksrc.spk.mk

.PHONY: nushell_extra_install
# some binaries need rpath to find shared libraries (of openssl) in the lib folder of the package
nushell_extra_install:
	@$(MSG) "Add library rpath to binaries."
	patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/*
