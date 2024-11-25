PKG_NAME = ser2net
PKG_VERS = 4.6.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/cminyard/ser2net/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libyaml

OPTIONAL_DEPENDS = cross/gensio cross/gensio_2.6.8

# cross/gensio
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://sourceforge.net/projects/ser2net/
COMMENT  = Serial to network interface, allows TCP/UDP to serial port connections.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = ser2net_pre_configure
POST_INSTALL_TARGET = ser2net_post_install

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
DEPENDS += cross/gensio_2.6.8
else ifeq ($(call version_lt, ${TCVERSION}, 6.0)$(call version_ge, ${TCVERSION}, 3.0),11)
DEPENDS += cross/gensio_2.6.8
else
DEPENDS += cross/gensio
endif

.PHONY: ser2net_pre_configure
ser2net_pre_configure:
	$(RUN) ; ./reconf

.PHONY: ser2net_post_install
ser2net_post_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/etc
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/ser2net.yaml $(STAGING_INSTALL_PREFIX)/etc/ser2net.yaml
