PKG_NAME = bison
PKG_VERS = 3.0.4
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/$(PKG_NAME)

DEPENDS =

HOMEPAGE = http://www.gnu.org/s/bison/
COMMENT  = General-purpose parser generator
LICENSE  = GNU GPL

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH), $(PPC_ARCHES)),$(ARCH))
CONFIGURE_ARGS = gl_cv_func_signbit_gcc=no
endif

PRE_CONFIGURE_TARGET = myPreConfigure

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) aclocal
	$(RUN) automake

