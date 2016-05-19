PKG_NAME = soxr
PKG_VERS = 0.1.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-Source.$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/soxr/files
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)-Source
DEPENDS =

HOMEPAGE = https://sourceforge.net/projects/soxr/
COMMENT  = The SoX Resampler library 'libsoxr' performs one-dimensional sample-rate conversion—it may be used, for example, to resample PCM-encoded audio.
LICENSE  = GPL & LGPL

CONFIGURE_TARGET = myConf

include ../../mk/spksrc.cross-cc.mk


CMAKE=cmake \
	-DCMAKE_INSTALL_PREFIX=$(STAGING_INSTALL_PREFIX) \
	-DEXTRA_LINK_FLAGS="-ldl" \
	-DBUILD_TESTS=OFF \

ifeq ($(findstring $(ARCH), $(PPC_ARCHES)),$(ARCH))
	CMAKE += -DVISIBILITY_HIDDEN=OFF
endif

myConf:
	$(RUN) $(CMAKE) .

