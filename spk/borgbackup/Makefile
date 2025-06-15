SPK_NAME = borgbackup
SPK_VERS = 1.4.1
SPK_REV = 18
SPK_ICON = src/borgbackup.png

PYTHON_PACKAGE = python312
SPK_DEPENDS = "$(PYTHON_PACKAGE)"
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)

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

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

# Force building pure-python wheels (issue #5204)
WHEELS_PURE_PYTHON_PACKAGING_ENABLE = 1

MAINTAINER = SynoCommunity
DESCRIPTION = BorgBackup \(short: Borg\) is a deduplicating backup program. Optionally, it supports compression and authenticated encryption. This package includes emborg \(a Borg frontend\) and borgmatic \(simple, configuration-driven backup software for servers and workstations\).

DISPLAY_NAME = Borg
STARTABLE = no
CHANGELOG = "1. Update borg to v1.4.1.<br/>2. Update borgmatic to v2.0.3.<br/>3. Update emborg to v1.41.<br/>4. Migrate to Python 3.12."

HOMEPAGE = https://borgbackup.readthedocs.io
LICENSE  = 3-Clause BSD

SERVICE_SETUP = src/service-setup.sh

SPK_USR_LOCAL_LINKS = bin:env/bin/borg bin:env/bin/borgmatic bin:env/bin/emborg

include ../../mk/spksrc.python.mk

# [borgbackup]
# Use OpenSSL path as defined by either
# spksrc.wheel-env.mk or spksrc.python.mk
ENV += BORG_LIBACL_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBB2_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBLZ4_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBXXHASH_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBZSTD_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_OPENSSL_PREFIX="$(OPENSSL_STAGING_PREFIX)"
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [borgbackup] -std=c11
endif

# [llfuse]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [llfuse] -std=gnu11
endif

# [msgpack]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [msgpack] -std=c11
endif

# [ruamel.yaml.clib]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [ruamel.yaml.clib] -std=c11
endif
