PKG_NAME = monit
PKG_VERS = 5.27.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://mmonit.com/monit/dist
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl

HOMEPAGE = https://mmonit.com/monit/
COMMENT  = Monit is a small Open Source utility for managing and monitoring Unix systems. Monit conducts automatic maintenance and repair and can execute meaningful causal actions in error situations.
LICENSE  = AGPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS += --with-ssl-incl-dir=$(STAGING_INSTALL_PREFIX)/include
CONFIGURE_ARGS += --with-zlib=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS = --without-pam 
#CONFIGURE_ARGS += --enable-optimized
CONFIGURE_ARGS += libmonit_cv_setjmp_available=yes libmonit_cv_vsnprintf_c99_conformant=yes 

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
CONFIGURE_ARGS += ac_cv_c_bigendian=yes
else
CONFIGURE_ARGS += ac_cv_c_bigendian=no
endif

include ../../mk/spksrc.cross-cc.mk
