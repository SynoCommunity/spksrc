PKG_NAME = mono
PKG_VERS = 3.4.0
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://download.mono-project.com/sources/mono
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = native/$(PKG_NAME)

HOMEPAGE = http://www.mono-project.com/
COMMENT  = Cross platform, open source .NET development framework
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = 

PRE_CONFIGURE_TARGET = myPreConfigure

# Notify of unsupported architectures 
ifneq ($(findstring $(ARCH),bromolow cedarview evansport x86 armada370 88f6281 armadaxp),$(ARCH))
$(error $(ARCH) is not a supported architecture)
endif

POST_INSTALL_TARGET = myPostInstall

include ../../mk/spksrc.cross-cc.mk

MONO_NATIVE_INSTALL = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) autoreconf

.PHONY: myPostInstall
myPostInstall:
	install -m 755 -d $(STAGING_DIR)/lib
	tar -cpf - -C $(MONO_NATIVE_INSTALL)/usr/local/lib . | tar -xpkf - -C $(STAGING_DIR)/lib
	install -m 755 -d $(STAGING_DIR)/etc/mono
	tar -cpf - -C $(MONO_NATIVE_INSTALL)/usr/local/etc/mono . | tar -xpkf - -C $(STAGING_DIR)/etc/mono
