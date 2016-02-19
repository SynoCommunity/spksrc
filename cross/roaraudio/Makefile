PKG_NAME = roaraudio
PKG_VERS = 1.0beta12-pr0
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://roaraudio.keep-cool.org/dl

# Optional packages. Can be removed
DEPENDS  = cross/libao cross/libogg cross/libvorbis cross/speex cross/speexdsp cross/libsndfile
DEPENDS += cross/flac cross/libsamplerate cross/icecast cross/pulseaudio
DEPENDS += cross/alsa-lib cross/zlib

HOMEPAGE = http://roaraudio.keep-cool.org
COMMENT  = Modern, multi-OS, networked Sound System
LICENSE  = 

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --cross-compile --prefix=$(STAGING_INSTALL_PREFIX)
PATCH_TARGET = patch_target myPatch
INSTALL_TARGET = myInstall

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPatch
myTarget:
	sed 's/^\(PATH=\)/#\1/g' $(WORK_DIR)/$(PKG_DIR)/configure
	sed '/^BETA=/s/true/false/g' $(WORK_DIR)/$(PKG_DIR)/build-system/configure.vars

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install

