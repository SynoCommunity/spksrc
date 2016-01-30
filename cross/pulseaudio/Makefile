PKG_NAME = pulseaudio
PKG_VERS = 8.0
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://www.freedesktop.org/software/$(PKG_NAME)/releases

# 1. Mandatory
DEPENDS  = cross/libtool cross/json-c cross/libsndfile 
## 2. Recommended
#DEPENDS += cross/alsa-lib cross/dbus cross/glib cross/openssl cross/speex cross/speexdsp
##DEPENDS += cross/libcap2 
## 3. Optional
#DEPENDS += cross/libsamplerate cross/jack

HOMEPAGE = http://www.pulseaudio.org
COMMENT  = PulseAudio is a sound system for POSIX OSes, meaning that it is a proxy for your sound applications. It allows you to do advanced operations on your sound data as it passes between your application and your hardware. Things like transferring the audio to a different machine, changing the sample format or channel count and mixing several sounds into one are easily achieved using a sound server. PulseAudio is designed for Linux systems. It has also been ported to and tested on Solaris, FreeBSD, NetBSD, MacOS X, Windows 2000 and Windows XP. PulseAudio is an integral part of all relevant modern Linux distributions and used in various mobile devices by multiple vendors.
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-bluez4 --disable-rpath --disable-static --without-caps
ifeq ($(findstring $(ARCH),88f5281 88f6281 alpine armada370 armada375 armadaxp comcerto2k monaco),$(ARCH))
  ADDITIONAL_CFLAGS += -fomit-frame-pointer
  ADDITIONAL_CFLAGS += -O2
endif
PATCH_TARGET = patch_target
ifeq ($(findstring $(ARCH),qoriq),$(ARCH))
#  PATCH_TARGET += myPatch
endif

INSTALL_TARGET = install_target myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPatch
myPatch:
	sed -ie "s/\(AM_CONDITIONAL(HAVE_SYS_EVENTFD_H, \).*$$/\1no)/g" $(WORK_DIR)/$(PKG_DIR)/configure.ac

.PHONY: myInstall
myInstall:
	ln -fvs $(STAGING_INSTALL_PREFIX)/lib/pulseaudio/libpulsecommon-$(PKG_VERS).so $(STAGING_INSTALL_PREFIX)/lib/libpulsecommon-$(PKG_VERS).so
