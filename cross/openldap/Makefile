PKG_NAME = openldap
PKG_VERS = 2.6.3
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.openldap.org/software/download/OpenLDAP/openldap-release
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl

HOMEPAGE = https://www.openldap.org
COMMENT  = OpenLDAP Software is an open source implementation of the Lightweight Directory Access Protocol.
LICENSE  = OpenLDAP Public License

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --disable-slapd
CONFIGURE_ARGS += --without-yielding_select
CONFIGURE_ARGS += --without-systemd
# avoid NEED_MEMCMP_REPLACEMENT when cross compiling
CONFIGURE_ARGS += ac_cv_func_memcmp_working=yes

ifneq ($(strip $(OPENLDAP_INCLUDE_EXECUTABLES)),1)
PLIST_TRANSFORM = sed -e '/bin:bin/d' -e '/rsc:etc/d'
endif

include ../../mk/spksrc.cross-cc.mk
