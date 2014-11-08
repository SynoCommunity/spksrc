PKG_NAME = libdvbcsa
PKG_VERS = 1.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://download.videolan.org/pub/videolan/$(PKG_NAME)/$(PKG_VERS)/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)


DEPENDS =
GNU_CONFIGURE = 1
HOMEPAGE = http://www.videolan.org/developers/libdvbcsa.html
COMMENT  = libdvbcsa is a free implementation of the DVB Common Scrambling Algorithm - DVB/CSA - with encryption and decryption capabilities.
LICENSE  =

CONFIGURE_ARGS = --enable-shared --enable-static --prefix=$(INSTALL_PREFIX)

#ifeq ($(findstring $(ARCH), 88f6281),$(ARCH))
#ADDITIONAL_CFLAGS = -O0
#endif

include ../../mk/spksrc.cross-cc.mk
