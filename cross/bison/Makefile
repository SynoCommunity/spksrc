PKG_NAME = bison
PKG_VERS = 3.0.4
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.gnu.org/s/bison/
COMMENT  = General-purpose parser generator
LICENSE  = GPLv3

GNU_CONFIGURE = 1

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(OLD_PCC_ARCHS)),$(ARCH))
CONFIGURE_ARGS = gl_cv_func_signbit_gcc=no
endif

PRE_CONFIGURE_TARGET = bison_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: bison_pre_configure
bison_pre_configure:
	$(RUN) aclocal
	$(RUN) automake
