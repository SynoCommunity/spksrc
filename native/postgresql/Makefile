PKG_NAME = postgresql
PKG_VERS = 17.4
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.postgresql.org/pub/source/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://www.postgresql.org/
COMMENT = PostgreSQL is a powerful, open source object-relational database system
LICENSE = PostgreSQL License

CONFIGURE_ARGS = --without-readline --without-zlib --without-icu

include ../../mk/spksrc.native-cc.mk

# PostgreSQL's build system only generates headers when MAKELEVEL=0
# Override compile target to set MAKELEVEL=0 for header generation
.PHONY: compile_target
compile_target:
	@$(MSG) "Compiling native $(PKG_NAME)"
	cd $(WORK_DIR)/$(PKG_DIR) && env MAKELEVEL=0 $(MAKE)
