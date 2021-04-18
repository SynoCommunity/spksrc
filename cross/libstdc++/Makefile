PKG_NAME = libstdc++6
PKG_VERS = 6.3.0-18+deb9u1
PKG_EXT = deb
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS)_$(PKG_ARCH).$(PKG_EXT)
PKG_DIST_SITE = http://http.us.debian.org/debian/pool/main/g/gcc-6/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)

DEPENDS =

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

HOMEPAGE = https://gcc.gnu.org/
COMMENT  = The GNU Compiler Collection includes front ends for C, C++, Objective-C, Fortran, Ada, Go, and D, as well as libraries for these languages (libstdc++,...). GCC was originally written as the compiler for the GNU operating system. The GNU system was developed to be 100% free software, free in the sense that it respects the user\'s freedom.
LICENSE  = GPLv3

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = libstdc++6_install

include ../../mk/spksrc.archs.mk

PKG_ARCH = amd64
LIB_DIR = x86_64-linux-gnu
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv5_ARCHS)),$(ARCH))
PKG_ARCH = armhf
LIB_DIR = arm-linux-gnueabihf
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_ARCH = arm64
LIB_DIR = aarch64-linux-gnu
else ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
PKG_ARCH = armel
LIB_DIR = arm-linux-gnueabi
else ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
PKG_ARCH = i386
LIB_DIR = i386-linux-gnu
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: libstdc++6_install
libstdc++6_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/lib
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/usr/lib/$(LIB_DIR)/libstdc++.so.6.0.22 $(STAGING_INSTALL_PREFIX)/lib
	ln -s libstdc++.so.6.0.22 $(STAGING_INSTALL_PREFIX)/lib/libstdc++.so.6


# digests file contains check sums for all PKG_ARCH specific source files.
# Use 'make update-digests' to update digests file once for new PKG_VERS
# This will download the sources and create the cumulated digests file.
# ARCH mappings: 
# - amd64: GENERIC_x64_ARCH
# - armhf: GENERIC_ARMv7_ARCH
# - arm64: GENERIC_ARMv8_ARCH
# - armel: hi3535
# - i386:  evansport
.PHONY: update-digests
update-digests:
	@echo "=== Create digests file ==="; \
	export TCVERSION=6.1 ; \
	tmp_digests=digests.tmp ; \
	>$$tmp_digests ; \
	for _arch in $(GENERIC_x64_ARCH) $(GENERIC_ARMv7_ARCH) $(GENERIC_ARMv8_ARCH) hi3535 evansport ; do \
	  echo "add digests for $$_arch" ; \
	  $(MAKE) -C . digests ARCH=$$_arch > /dev/null ; \
	  cat digests >> $$tmp_digests ; \
	done ; \
	rm -f digests ; \
	mv $$tmp_digests digests ; \
	echo ""=== Please verify checksums with original sources. "===" ; \
	cat digests ; \
	exit 0

