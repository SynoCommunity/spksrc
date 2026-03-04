SPK_NAME = borgbackup
SPK_VERS = 1.4.3
SPK_REV = 21
SPK_ICON = src/borgbackup.png

# Include common.mk first to get ARCH definitions
include ../../mk/spksrc.common.mk

# Build for ARMv5 and ARMv7L using Python 3.11; all others use Python 3.12
# This must be set BEFORE including spksrc.spk-python.mk to avoid adding
# ARMv5 to UNSUPPORTED_ARCHS when using python312
ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7L_ARCHS)),)
PYTHON_PACKAGE = python311
else
PYTHON_PACKAGE = python312
endif

SPK_DEPENDS = $(PYTHON_PACKAGE)
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

DEPENDS = cross/acl cross/attr cross/fuse cross/libb2 cross/lz4 cross/openssl3 cross/xxhash cross/zstd

# # Generate Requirements File
# 
# # 1. Set up the development environment
# # If you don't have an spksrc environment set up, run the following in your target folder:
# git clone https://github.com/SynoCommunity/spksrc.git
# 
# # 2. Install required dependencies for Borg
# sudo apt-get update
# sudo apt-get install acl-dev build-essential libfuse-dev liblz4-dev libxxhash-dev libzstd-dev
# 
# # 3. Prepare the requirements generation script
# cd spksrc/spk/borgbackup/
# curl -O https://gist.githubusercontent.com/hgy59/6676a55ea8b0b0264af7f23850f5e7c8/raw/8d0a3912069c746d1a1fb1d23ca9d650e2ec331d/generate_requirements.sh
# sudo chmod +x generate_requirements.sh
# 
# # 4. Generate the requirements file, restricting version of rpds-py for compatibility
# # rpds-py >= 0.22.3 requires rustc >= 1.80
# ./generate_requirements.sh "borgbackup[llfuse] borgmatic emborg rpds-py==0.22.3" 312
# 
# # 5. Post-generation
# # The script will create three files (pure, cross, and combined) for the Borg deployment
# # with Python 3.12. Use the pure and cross requirement files as the base for your PR.

# Wheels: pure-python requirements (all architectures)
WHEELS = src/requirements-pure.txt

# Cross-compiled requirements vary by architecture
# ARMv5 uses rpds_py pinned to 0.21.0 for Cargo.lock v3 compatibility with Rust 1.77.2
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
WHEELS += src/requirements-crossenv-armv5.txt
else
WHEELS += src/requirements-crossenv.txt
endif

# Force building pure-python wheels (issue #5204)
WHEELS_PURE_PYTHON_PACKAGING_ENABLE = 1

MAINTAINER = SynoCommunity
DESCRIPTION = BorgBackup \(short: Borg\) is a deduplicating backup program. Optionally, it supports compression and authenticated encryption. This package includes emborg \(a Borg frontend\) and borgmatic \(simple, configuration-driven backup software for servers and workstations\).

DISPLAY_NAME = Borg
STARTABLE = no
CHANGELOG = "1. Update borgmatic to v2.1.2.<br/>2. Refresh Python dependencies."

HOMEPAGE = https://borgbackup.readthedocs.io
LICENSE  = 3-Clause BSD

SERVICE_SETUP = src/service-setup.sh
POST_SERVICE_TARGET = borgbackup_extra_install

SPK_USR_LOCAL_LINKS = bin:env/bin/borg bin:env/bin/borgmatic bin:env/bin/emborg

include ../../mk/spksrc.spk-python.mk

# [borgbackup]
# Use OpenSSL path as defined by either
# spksrc.wheel-env.mk or spksrc.spk-python.mk
ENV += BORG_LIBACL_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBB2_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBLZ4_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBXXHASH_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBZSTD_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_OPENSSL_PREFIX="$(OPENSSL_STAGING_PREFIX)"

# [borgbackup]
# GCC < 5.0 (DSM 6.2.4) requires gnu99 for Cython-generated code.
# C11 (the original setting) is not fully supported by GCC 4.9.x, and Cython
# uses GNU extensions (e.g., typeof, statement expressions) in its fallback paths.
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [borgbackup] -std=gnu99
endif

# [llfuse]
# GCC < 5.0 requires gnu99 for Cython-generated code (see borgbackup above).
# Requires CYTHON_ATOMICS=0 because ATOMIC_INT_LOCK_FREE is not a
# preprocessor constant in GCC < 5.0.
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [llfuse] -std=gnu99 -DCYTHON_ATOMICS=0
endif

# [msgpack]
# GCC < 5.0 requires gnu99 for Cython-generated code (see borgbackup above).
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [msgpack] -std=gnu99
endif

# [ruamel_yaml_clib]
# GCC < 5.0 requires gnu99 for Cython-generated code (see borgbackup above).
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [ruamel_yaml_clib] -std=gnu99
endif

.PHONY: borgbackup_extra_install
borgbackup_extra_install:
	@$(MSG) Substituting PYTHON_PACKAGE in service-setup
	@sed -i 's|@@PYTHON_PACKAGE@@|$(PYTHON_PACKAGE)|g' $(WORK_DIR)/scripts/service-setup
