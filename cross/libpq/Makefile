PKG_NAME = libpq
PKG_VERS = 11.16
PKG_EXT = tar.bz2
PKG_DIST_NAME = postgresql-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.postgresql.org/pub/source/v$(PKG_VERS)/
PKG_DIR = postgresql-$(PKG_VERS)

# libpq is available within the full postgresql source tree only:
# https://stackoverflow.com/questions/29803847/how-to-download-compile-install-only-the-libpq-source-on-a-server-that-does-n

DEPENDS = cross/openssl

HOMEPAGE = https://www.postgresql.org
COMMENT  = PostgreSQL is a powerful, open source object-relational database system with over 30 years of active development that has earned it a strong reputation for reliability, feature robustness, and performance

LICENSE  = PostgreSQL Licence

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --with-template=linux --with-openssl
CONFIGURE_ARGS += --with-system-tzdata=/usr/share/zoneinfo
CONFIGURE_ARGS += --without-readline

COMPILE_TARGET = libpq_compile
INSTALL_TARGET = libpq_install

ADDITIONAL_CFLAGS = -O

# If you want to invoke the build from another makefile rather than manually,
# you must unset MAKELEVEL or set it to zero.
# see: INSTALL file
#ENV += MAKELEVEL=

include ../../mk/spksrc.cross-cc.mk

.PHONY: libpq_compile
libpq_compile:
	@$(RUN) ; cd src/interfaces && $(MAKE) -C libpq all

.PHONY: libpq_install
libpq_install:
	@$(RUN) ; cd src/interfaces && $(MAKE) -C libpq DESTDIR=$(INSTALL_DIR) install prefix=$(INSTALL_PREFIX)
	@$(RUN) ; cd src/backend && $(MAKE) generated-headers
