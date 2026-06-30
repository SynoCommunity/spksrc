PKG_NAME = postgresql
PKG_VERS = 17.10
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.postgresql.org/pub/source/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://www.postgresql.org/
COMMENT = PostgreSQL is a powerful, open source object-relational database system
LICENSE = PostgreSQL License

CONFIGURE_ARGS = --without-readline --without-zlib --without-icu

# PostgreSQL's build system only generates headers when MAKELEVEL=0
# Hook the compile target (COMPILE_TARGET) to set MAKELEVEL=0 for header generation
COMPILE_TARGET = postgresql_compile_target

include ../../mk/spksrc.native-cc.mk

.PHONY: postgresql_compile_target
postgresql_compile_target:
	@$(MSG) "Compiling native $(PKG_NAME)"
	cd $(WORK_DIR)/$(PKG_DIR) && env MAKELEVEL=0 $(MAKE)
