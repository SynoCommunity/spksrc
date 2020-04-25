PKG_NAME = dav1d
PKG_VERS = 0.5.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://code.videolan.org/videolan/$(PKG_NAME)/-/archive/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://www.videolan.org/projects/dav1d.html
COMMENT  = dav1d is a new AV1 cross-platform decoder, open-source, and focused on speed and correctness.
LICENSE  = BSD 2

NASM_PATH = $(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin
ENV += NASM=$(NASM_PATH)/nasm
ENV += PATH=$(NASM_PATH):$$PATH
#PRE_CONFIGURE_TARGET = MyPreConf
CONFIGURE_TARGET = myConf
COMPILE_TARGET = myComp
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

MESON_ARGS = --prefix=$(INSTALL_PREFIX) --libdir=$(INSTALL_PREFIX)/lib -Dbuildtype=release -Denable_tools=false -Denable_tests=false

ifeq ($(strip $(PKG_LINK_TYPE)),static)
MESON_ARGS += -Ddefault_library=static
else
MESON_ARGS += -Ddefault_library=shared
endif

.PHONY: myPreConf
myPreConf:
	$(RUN) && mkdir build

.PHONY: myConf
myConf:
	$(RUN) && mkdir -p build && cd build && meson $(MESON_ARGS) ..

.PHONY: myComp
myComp:
	$(RUN) && cd build && ninja

.PHONY: myInstall
myInstall:
	$(RUN) && cd build && DESTDIR=$(INSTALL_DIR) meson install 
