SPK_NAME = borgbackup
SPK_VERS = 1.4.5
SPK_REV = 23
SPK_ICON = src/borgbackup.png

# Include common.mk first to get ARCH definitions
include ../../mk/spksrc.common.mk

# python314 needs gcc >= 4.8 (its MIN_GCC_VERSION); older toolchains use 3.11.
# Must be set before spksrc.spk-meta.mk, which would otherwise gate the arch out.
ifeq ($(call version_lt,$(TC_GCC),4.8),1)
PYTHON_PACKAGE = python311
else
PYTHON_PACKAGE = python314
endif

# borg's setup.py hardcodes -Wno-unreachable-code-fallthrough; gcc ignores an
# unknown -Wno- option only from 4.6 on, and errors out in cc1 before that.
MIN_GCC_VERSION = 4.6

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
# ./generate_requirements.sh "borgbackup[llfuse] borgmatic emborg rpds-py==0.21.0" 311
# ./generate_requirements.sh "borgbackup[llfuse] borgmatic emborg" 314
# 
# # 5. Post-generation
# # The script will create three files (pure, cross, and combined) for the Borg deployment
# # with Python 3.14. Use the pure and cross requirement files as the base for your PR.

# Wheels: Python requirements vary by architecture
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
WHEELS += src/requirements-pure-armv5.txt src/requirements-crossenv-armv5.txt
else
WHEELS += src/requirements-pure.txt src/requirements-crossenv.txt
endif

# Force building pure-python wheels (issue #5204)
WHEELS_PURE_PYTHON_PACKAGING_ENABLE = 1

MAINTAINER = SynoCommunity
DESCRIPTION = BorgBackup \(short: Borg\) is a deduplicating backup program. Optionally, it supports compression and authenticated encryption. This package includes emborg \(a Borg frontend\) and borgmatic \(simple, configuration-driven backup software for servers and workstations\).

DISPLAY_NAME = Borg
STARTABLE = no
CHANGELOG = "1. Update Borg to v1.4.5. <br/>2. Update borgmatic to v2.1.6. <br/>3. Fix jsonschema/rpds-py dependency conflict."

HOMEPAGE = https://borgbackup.readthedocs.io
LICENSE  = 3-Clause BSD

SERVICE_SETUP = src/service-setup.sh
POST_SERVICE_TARGET = borgbackup_extra_install

SPK_USR_LOCAL_LINKS = bin:env/bin/borg bin:env/bin/borgmatic bin:env/bin/emborg

# [borgbackup]
# Use the OpenSSL path from the single source of truth:
# spksrc.cross/env-default.mk (included via spksrc.cross-cc.mk).
ENV += BORG_LIBACL_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBB2_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBXXHASH_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBZSTD_PREFIX="$(STAGING_INSTALL_PREFIX)"
# BORG_LIBLZ4_PREFIX: prefer the Python install prefix (where lz4 was
# installed during stage-1), fall back to own staging prefix.
_prefixed := $(abspath $(WORK_DIR)/../../../spk/$(PYTHON_PACKAGE)/work-$(ARCH)-$(TCVERSION)/install/var/packages/$(PYTHON_PACKAGE)/target)
ENV += BORG_LIBLZ4_PREFIX=$(or $(wildcard $(_prefixed)),$(STAGING_INSTALL_PREFIX))
ENV += PKG_CONFIG_PATH=$(or $(wildcard $(_prefixed)/lib/pkgconfig),$(STAGING_INSTALL_PREFIX)/lib/pkgconfig)
ENV += BORG_OPENSSL_PREFIX="$(OPENSSL_STAGING_INSTALL_PREFIX)"

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

# rpds-py >= 0.25 pulls Rust edition 2024 crates (rustc >= 1.85), and jsonschema
# >= 4.26 requires rpds-py >= 0.25; below that floor both pin back one release.
ifeq ($(call version_ge,$(TC_RUSTC),1.85),1)
WHEELS += rpds_py==0.30.0
WHEELS += jsonschema==4.26.0
else
export PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1
WHEELS += rpds_py==0.24.0
WHEELS += jsonschema==4.25.1
endif

include ../../mk/spksrc.spk-meta.mk

.PHONY: borgbackup_extra_install
borgbackup_extra_install:
	@$(MSG) Substituting PYTHON_PACKAGE in service-setup
	@sed -i 's|@@PYTHON_PACKAGE@@|$(PYTHON_PACKAGE)|g' $(WORK_DIR)/scripts/service-setup
