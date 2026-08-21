PKG_NAME = lldpd
PKG_VERS = 1.0.18
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/lldpd/lldpd/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libcap cross/libxml2 cross/readline

# cross/libcap
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

HOMEPAGE = https://lldpd.github.io
COMMENT  = lldpd is a 802.1AB implementation (LLDP) to help you locate neighbors of all your equipments.
LICENSE  = ISC

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --disable-doxygen-doc --disable-doxygen-html --disable-doxygen-pdf
CONFIGURE_ARGS += --with-readline
# build service and cli tools into bin instead of sbin folder
CONFIGURE_ARGS += --sbindir=$(INSTALL_PREFIX)/bin
# Enable Privilege separation and specify user:group as sc-lldpd:synocommunity
CONFIGURE_ARGS += --enable-privsep --with-privsep-user=sc-lldpd --with-privsep-group=synocommunity
CONFIGURE_ARGS += --runstatedir=$(INSTALL_PREFIX_VAR)

ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk
