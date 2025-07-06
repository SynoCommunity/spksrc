PKG_NAME = clinfo
PKG_VERS = 3.0.23.01.25
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Oblomov/clinfo/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/Oblomov/clinfo
COMMENT = clinfo is a simple command-line application that enumerates all possible (known) properties of the OpenCL platform and devices available on the system.
LICENSE = clinfo by Giuseppe Bilotta

DEPENDS = cross/ocl-icd

CONFIGURE_TARGET = nop
COMPILE_TARGET = clinfo_compile_target
INSTALL_TARGET = clinfo_install_target

include ../../mk/spksrc.cross-cc.mk

.PHONY: clinfo_compile_target
clinfo_compile_target:
	$(RUN) $(MAKE)

.PHONY: clinfo_install_target
clinfo_install_target:
	$(RUN) install -Dm755 clinfo -t $(STAGING_INSTALL_PREFIX)/bin
	$(RUN) install -Dm644 LICENSE -t $(STAGING_INSTALL_PREFIX)/share/licenses/$(PKG_NAME)
