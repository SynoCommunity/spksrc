PKG_NAME = gogs
PKG_VERS = 0.9.13
PKG_EXT = zip
PKG_DIST_SITE = https://dl.gogs.io
PKG_DIR = $(PKG_NAME)

DEPENDS = 

HOMEPAGE = https://gogs.io
COMMENT  = A painless self-hosted Git service.
LICENSE  = MIT

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall


# Arch: arm/386/amd64
ifeq ($(findstring $(ARCH),88f5281 88f6281 alpine armada370 armada375 armada38x armadaxp comcerto2k monaco),$(ARCH))
GOGS_ARCH = arm
endif
ifeq ($(findstring $(ARCH),evansport),$(ARCH))
GOGS_ARCH = 386
endif
ifeq ($(findstring $(ARCH),avoton braswell bromolow cedarview x86 x64),$(ARCH))
GOGS_ARCH = amd64
endif
ifeq ($(GOGS_ARCH),)
$(error Unsupported ARCH $(ARCH))
endif


PKG_DIST_NAME = $(PKG_NAME)_v$(PKG_VERS)_linux_$(GOGS_ARCH).$(PKG_EXT)



include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/$(PKG_DIR)
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/$(PKG_DIR)
