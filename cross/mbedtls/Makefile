PKG_NAME = mbedtls
PKG_VERS = 3.6.7
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Mbed-TLS/mbedtls/releases/download/$(PKG_NAME)-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.trustedfirmware.org/projects/mbed-tls/
COMMENT  = Mbed TLS implements cryptographic primitives, X.509 certificate manipulation and the SSL/TLS and DTLS protocols. Its small code footprint makes it suitable for embedded systems.
LICENSE  = Apache 2.0 or GPLv2+

CONFIGURE_ARGS  = -DUSE_SHARED_MBEDTLS_LIBRARY=ON
CONFIGURE_ARGS += -DUSE_STATIC_MBEDTLS_LIBRARY=OFF
CONFIGURE_ARGS += -DENABLE_TESTING=OFF
CONFIGURE_ARGS += -DENABLE_PROGRAMS=OFF

include ../../mk/spksrc.common.mk

# Avoid definition of MBEDTLS_AESCE_C for aarch64 with gcc < 6
ifeq ($(call version_lt, $(TC_GCC), 5),1)
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
POST_EXTRACT_TARGET = disable_mbedtls_target
MBEDTLS_DISABLE = MBEDTLS_AESCE_C
endif

# Disable ASM for x86 archs with gcc < 5
# Note: Only MBEDTLS_HAVE_ASM needs disabling with version 4.x
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
POST_EXTRACT_TARGET = disable_mbedtls_target
MBEDTLS_DISABLE  = MBEDTLS_HAVE_ASM
MBEDTLS_DISABLE += MBEDTLS_AESNI_C
MBEDTLS_DISABLE += MBEDTLS_PADLOCK_C
endif
endif

include ../../mk/spksrc.cross-cmake.mk

disable_mbedtls_target:
	@$(foreach var,$(MBEDTLS_DISABLE),$(RUN) find $(WORK_DIR) -type f -exec sed -i \
		's|^[[:space:]]*#define[[:space:]]\+$(var)|// #define $(var)|' {} +;)
