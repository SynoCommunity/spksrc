PKG_NAME = cryptsetup
PKG_VERS = 2.6.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.kernel.org/pub/linux/utils/cryptsetup/v$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/device-mapper cross/json-c cross/libblkid cross/libuuid cross/openssl3 cross/popt

HOMEPAGE = https://gitlab.com/cryptsetup/cryptsetup
COMMENT  = Open-source utility used to conveniently set up disk encryption based on the dm-crypt kernel module.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-asciidoc
CONFIGURE_ARGS += --disable-external-tokens
CONFIGURE_ARGS += --disable-ssh-token
CONFIGURE_ARGS += --disable-veritysetup
CONFIGURE_ARGS += --disable-integritysetup
CONFIGURE_ARGS += --disable-selinux

include ../../mk/spksrc.archs.mk
ifneq ($(filter $(ARCH),$(i686_ARCHS) $(x64_ARCHS)),)
# external argon2 is recommended for CPUs with SSE/AVX
DEPENDS += cross/argon2
CONFIGURE_ARGS += --enable-libargon2
endif

include ../../mk/spksrc.cross-cc.mk
