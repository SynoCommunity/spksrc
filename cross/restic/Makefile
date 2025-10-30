PKG_NAME = restic
PKG_VERS = 0.18.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/restic/restic/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS)

BUILD_DEPENDS = native/go

HOMEPAGE = https://restic.net/
COMMENT  = Restic is a fast, secure, efficient backup program written in Go.
LICENSE  = BSD-2-Clause

CGO_ENABLED = 1
COMPILE_TARGET = restic_compile_target
GO_BIN_DIR = $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME)

export EXTRA_GOFLAGS=-buildvcs=false

include ../../mk/spksrc.cross-go.mk

SYNOPKG_PKGVAR = /var/packages/$(PKG_NAME)/var

.PHONY: restic_compile_target
restic_compile_target:
	@$(RUN) $(MAKE) restic
