PKG_NAME = c-ares
PKG_VERS = 1.34.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/c-ares/c-ares/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# ares_event_configchg.c:140: error: 'IN_NONBLOCK' undeclared (first use in this function)
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://c-ares.org/
COMMENT  = c-ares is a C library for asynchronous DNS requests (including name resolves).
LICENSE  = MIT

POST_CONFIGURE_TARGET = cares_post_configure

CMAKE_ARGS += -DCARES_BUILD_TOOLS=OFF

include ../../mk/spksrc.cross-cmake.mk

.PHONY: cares_post_configure
cares_post_configure:
	@$(MSG) Create target include folder to suppress ignorable error logs
	@$(RUN) install -d $(INSTALL_DIR)$(INSTALL_PREFIX)/include
