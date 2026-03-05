###############################################################################
# spksrc.spk-python.mk
#
# Shared Python reuse logic for SPK packages.
#
# Purpose:
#   Allows a package to either:
#     1) Build required Python and its dependencies locally (legacy mode), or
#     2) Reuse an existing Python SPK build (reuse mode).
#
# ─────────────────────────────────────────────────────────────────────────────
# Modes of Operation
#
# 1) Legacy Mode (default fallback)
#    - Triggered when no matching:
#          spk/<python>/work-<arch>-<tcversion>
#      directory exists.
#    - Injects required cross/* dependencies directly.
#    - Primarily relevant for x64 architectures.
#
# 2) Reuse Mode
#    - Triggered when a matching Python work directory exists.
#    - Reuses staged headers and shared libraries.
#    - Injects include/lib paths into ADDITIONAL_*FLAGS and Rust flags.
#    - Links pkg-config files into STAGING_INSTALL_PREFIX.
#    - Links dependency .*-*_done cookies into WORK_DIR.
#    - Avoids rebuilding the full Python and OpenSSL stack.
#    - Excludes wheel-based cross packages from reuse.
#
# ─────────────────────────────────────────────────────────────────────────────
#
# Architecture Constraints:
#   - Reuse is bound to:
#         work-<arch>-<tcversion>
#   - Ensures ABI compatibility with the active toolchain.
#
# Key Variables:
#   PYTHON_PACKAGE                 Default: python312
#   PYTHON_PACKAGE_WORK_DIR        Architecture-specific work dir
#   PYTHON_STAGING_INSTALL_PREFIX  Staged reuse prefix for Python
#   PYTHON_INSTALL_PREFIX          Installation prefix for Python
#   OPENSSL_STAGING_INSTALL_PREFIX Staged reuse prefix for OpenSSL
#   OPENSSL_INSTALL_PREFIX         Installation prefix for OpenSSL
#   PYTHON_LIBS                    Reused pkg-config libraries
#   PYTHON_STATUS_COOKIES          Reused build completion markers
#
# Failure Handling:
#   - If reuse mode is detected but required staging paths are missing,
#     the build aborts explicitly via $(error).
#
# Integration:
#   - Extends DEPENDS dynamically.
#   - Hooks into PRE_DEPEND_TARGET via python_pre_depend.
#   - Designed to be transparent to package Makefiles.
#
# TODO TODO TODO TODO
# Manage SPK_DEPEND
#
###############################################################################

# Set default python package name
ifeq ($(strip $(PYTHON_PACKAGE)),)
export PYTHON_PACKAGE = python312
endif

# set default spk/python* path to use
PYTHON_PACKAGE_DIR = $(realpath $(CURDIR)/../../spk/$(PYTHON_PACKAGE))
PYTHON_PACKAGE_WORK_DIR = $(PYTHON_PACKAGE_DIR)/work-$(ARCH)-$(TCVERSION)

include ../../mk/spksrc.common.mk

# Always export these variables - they use deferred expansion so
# they will resolve correctly at recipe execution time even when
# PYTHON_PACKAGE is set conditionally after include.
export PYTHON_PACKAGE
export PYTHON_PACKAGE_DIR
export PYTHON_PACKAGE_WORK_DIR
export SPK_NAME

ifeq ($(wildcard $(PYTHON_PACKAGE_WORK_DIR)),)

PYTHON_DEPENDS += cross/$(PYTHON_PACKAGE)

# PYTHON_PACKAGE_WORK_DIR exists
else

# Set Python installation prefix directory variables
ifeq ($(strip $(PYTHON_STAGING_INSTALL_PREFIX)),)
export PYTHON_INSTALL_PREFIX = /var/packages/$(PYTHON_PACKAGE)/target
export PYTHON_STAGING_INSTALL_PREFIX = $(realpath $(PYTHON_PACKAGE_WORK_DIR)/install/$(PYTHON_INSTALL_PREFIX))
endif

# Set OpenSSL installation prefix directory variables
ifeq ($(strip $(OPENSSL_STAGING_INSTALL_PREFIX)),)
export OPENSSL_INSTALL_PREFIX = $(PYTHON_INSTALL_PREFIX)
export OPENSSL_STAGING_INSTALL_PREFIX = $(PYTHON_STAGING_INSTALL_PREFIX)
endif

# set build flags including ld to rewrite for the library path
# used to access python package provide libraries at destination
ifneq ($(wildcard $(PYTHON_STAGING_INSTALL_PREFIX)),)

# Only apply flags if we are in build stage2 as
# usage of += will duplicate values per make calls
ifneq ($(filter spk-stage2,$(MAKECMDGOALS)),)
export ADDITIONAL_CFLAGS    += -I$(PYTHON_STAGING_INSTALL_PREFIX)/include
export ADDITIONAL_CPPFLAGS  += -I$(PYTHON_STAGING_INSTALL_PREFIX)/include
export ADDITIONAL_CXXFLAGS  += -I$(PYTHON_STAGING_INSTALL_PREFIX)/include
export ADDITIONAL_LDFLAGS   += -L$(PYTHON_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_LDFLAGS   += -Wl,--rpath-link,$(PYTHON_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_LDFLAGS   += -Wl,--rpath,$(PYTHON_INSTALL_PREFIX)/lib
export ADDITIONAL_RUSTFLAGS += -Clink-arg=-L$(PYTHON_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_RUSTFLAGS += -Clink-arg=-Wl,--rpath-link,$(PYTHON_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_RUSTFLAGS += -Clink-arg=-Wl,--rpath,$(PYTHON_INSTALL_PREFIX)/lib

# similarly, ld to rewrite OpenSSL library path if differs
ifneq ($(OPENSSL_STAGING_INSTALL_PREFIX),$(PYTHON_STAGING_INSTALL_PREFIX))
export ADDITIONAL_LDFLAGS   += -L$(OPENSSL_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_LDFLAGS   += -Wl,--rpath-link,$(OPENSSL_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_LDFLAGS   += -Wl,--rpath,$(OPENSSL_INSTALL_PREFIX)/lib
export ADDITIONAL_RUSTFLAGS += -Clink-arg=-L$(OPENSSL_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_RUSTFLAGS += -Clink-arg=-Wl,--rpath-link,$(OPENSSL_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_RUSTFLAGS += -Clink-arg=-Wl,--rpath,$(OPENSSL_INSTALL_PREFIX)/lib
endif
endif

# Re-use all default python mandatory libraries (with exception of bzip2, xz, zlib)
PYTHON_LIBS_EXCLUDE = %bzip2.pc %lzma.pc %zlib.pc
PYTHON_DEPENDS_EXCLUDE = bzip2 xz zlib
PYTHON_FILTERED_DEPENDS = $(addprefix cross/,$(PYTHON_DEPENDS_EXCLUDE))

# Re-use all default python library dependencies (with exception of excludes)
PYTHON_LIBS := $(filter-out $(PYTHON_LIBS_EXCLUDE),$(wildcard $(PYTHON_STAGING_INSTALL_PREFIX)/lib/pkgconfig/*.pc))

# Generate a list of all library dependencies status cookies (with exception of excludes)
PYTHON_STATUS_COOKIES := $(foreach cross,$(filter-out $(PYTHON_DEPENDS_EXCLUDE),$(foreach pkg_name,$(shell $(MAKE) dependency-list -C $(realpath $(PYTHON_PACKAGE_WORK_DIR)/../) 2>/dev/null | grep ^$(PYTHON_PACKAGE) | cut -f2 -d:),$(shell sed -n 's/^PKG_NAME = \(.*\)/\1/p' $(realpath $(CURDIR)/../../$(pkg_name)/Makefile)))),$(wildcard $(PYTHON_PACKAGE_WORK_DIR)/.$(cross)-*_done))

# call-up pre-depend to prepare the shared python build environment
PRE_DEPEND_TARGET += python_pre_depend

else
$(error PYTHON reuse detected but staging prefix not found: $(PYTHON_STAGING_INSTALL_PREFIX))

# end ifeq PYTHON_STAGING_INSTALL_PREFIX
endif

# end ifeq PYTHON_PACKAGE_WORK_DIR
endif


# re-inject either:
#    - python dependencies for inclusion in-app spk package; or
#    - filtered libraries to be processed first
ifneq ($(filter spk-stage2,$(MAKECMDGOALS)),)
DEPENDS := $(PYTHON_DEPENDS) $(PYTHON_FILTERED_DEPENDS) $(DEPENDS)
endif

ifneq ($(FFMPEG_PACKAGE),)
include ../../mk/spksrc.spk-ffmpeg.mk
else
include ../../mk/spksrc.spk.mk
endif

.PHONY: python_pre_depend
python_pre_depend:
	@$(MSG) "*****************************************************"
	@$(MSG) "*** Use existing shared objects from [$(PYTHON_PACKAGE)]"
	@$(MSG) "*** PATH: $(PYTHON_PACKAGE_WORK_DIR)"
	@$(MSG) "*****************************************************"
	@mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	@$(foreach lib,$(PYTHON_LIBS),ln -sf $(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)
	@$(foreach _done,$(PYTHON_STATUS_COOKIES),ln -sf $(_done) $(WORK_DIR) ;)
	@# EXCEPTION: Do not symlink cross/* wheel builds
	@make --no-print-directory dependency-flat | sort -u | grep cross/ | while read depend ; do \
	   makefile="../../$${depend}/Makefile" ; \
	   if grep -q spksrc.python-wheel.mk $${makefile} ; then \
	      pkgstr=$$(grep ^PKG_NAME $${makefile}) ; \
	      pkgname=$$(echo $${pkgstr#*=} | xargs) ; \
	      find $(WORK_DIR)/$${pkgname}* $(WORK_DIR)/.$${pkgname}* -maxdepth 0 -type l -exec rm -fr {} \; 2>/dev/null || true ; \
	   fi ; \
	done
