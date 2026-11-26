PKG_NAME = curl-cffi
PKG_REAL_NAME = curl_cffi
PKG_VERS = 0.17.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_REAL_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/c/curl-cffi
PKG_DIR = $(PKG_REAL_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/lexiforest/curl_cffi
COMMENT  = Python binding to libcurl-impersonate with browser impersonation support.
LICENSE  = MIT

include ../../mk/spksrc.common.mk

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv7L_ARCHS)
UNSUPPORTED_ARCHS_REASON = no compatible libcurl-impersonate prebuild (PPC lacks one; hi3535 is soft-float)

# The prebuilt libcurl-impersonate archive is linked by the C extension.
# Use the shim already built for the Rust link when the vendor binutils is old.
ifneq ($(strip $(TC_OVERLAY_BINUTILS_SHIM)),)
ADDITIONAL_LDFLAGS += -B$(TC_OVERLAY_BINUTILS_SHIM)
endif

ifneq ($(findstring $(ARCH),$(x64_ARCHS)),)
CURL_CFFI_TARGET_MACHINE = x86_64
else ifneq ($(findstring $(ARCH),$(i686_ARCHS)),)
CURL_CFFI_TARGET_MACHINE = i686
else ifneq ($(findstring $(ARCH),$(ARMv7_ARCHS)),)
CURL_CFFI_TARGET_MACHINE = armv7l
else ifneq ($(findstring $(ARCH),$(ARMv8_ARCHS)),)
CURL_CFFI_TARGET_MACHINE = aarch64
endif
ENV += CURL_CFFI_TARGET_MACHINE=$(CURL_CFFI_TARGET_MACHINE)
ENV += CURL_CFFI_TARGET_POINTER_SIZE=$(if $(findstring $(ARCH),$(32bit_ARCHS)),32,64)

include ../../mk/spksrc.python-wheel.mk
