PKG_NAME = bitlbee
PKG_VERS = 3.4.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://get.bitlbee.org/src
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/glib cross/gnutls cross/libgcrypt

HOMEPAGE = http://www.bitlbee.org/
COMMENT  = BitlBee brings IM (instant messaging) to IRC clients. It\'s a great solution for people who have an IRC client running all the time and don\'t want to run an additional MSN/AIM/whatever client
LICENSE  = GPLv2

CONFIGURE_TARGET = myConfigure
INSTALL_TARGET = myInstall

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --ssl=gnutls --prefix=$(INSTALL_PREFIX) --pidfile=$(INSTALL_PREFIX)/var/bitlbee.pid
CONFIGURE_ARGS += --config=$(INSTALL_PREFIX)/var/
ifeq ($(findstring $(ARCH),powerpc ppc824x),$(ARCH))
CONFIGURE_ARGS += --pie=0
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:
	$(RUN) PATH=$(STAGING_INSTALL_PREFIX)/bin:$$PATH ./configure $(REAL_CONFIGURE_ARGS)
	@echo "LDFLAGS_BITLBEE+=\$$(LDFLAGS)" >> $(WORK_DIR)/$(PKG_DIR)/Makefile.settings

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
