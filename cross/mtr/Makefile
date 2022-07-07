PKG_NAME = mtr
PKG_VERS = 0.94
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/traviscross/mtr/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw

OPTIONAL_DEPENDS = cross/libcap
include ../../mk/spksrc.archs.mk
ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/libcap
endif

HOMEPAGE = https://www.bitwizard.nl/mtr/
COMMENT  = My traceroute combines the functionality of the 'traceroute' and 'ping' programs in a single network diagnostic tool.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = mtr_pre_configure

# avoid creation of exec hooks
INSTALL_MAKE_OPTIONS = install-sbinPROGRAMS DESTDIR=$(INSTALL_DIR)

include ../../mk/spksrc.cross-cc.mk

.PHONY: mtr_pre_configure
mtr_pre_configure:
	$(RUN) ./bootstrap.sh
