SPK_NAME = borgbackup
SPK_VERS = 1.4.0
SPK_REV = 17
SPK_ICON = src/borgbackup.png

PYTHON_PACKAGE = python312
SPK_DEPENDS = "$(PYTHON_PACKAGE)"
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)

DEPENDS = cross/attr cross/acl cross/openssl3 cross/lz4 cross/libb2 cross/fuse cross/xxhash cross/zstd

# Requirements file generation
# - first create borgbackup wheel defined in src/requirements-crossenv.txt
# cd src
# /spksrc/native/python311/work-native/install/usr/local/bin/python3 -m venv borg-env
# . borg-env/bin/activate
# pip install ../work-x64-6.1/install/var/packages/borgbackup/target/share/wheelhouse/borgbackup*.whl borgmatic emborg llfuse
# pip freeze > requirements.txt
# deactivate
# # evaluate which dependencies are cross wheels:
# find env/lib/python3.10/site-packages/ -name WHEEL -exec grep -iH pure {} \; | grep false
# # finally divide requirements into *-crossenv.txt and *-pure.txt
WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

# Force building pure-python wheels (issue #5204)
WHEELS_PURE_PYTHON_PACKAGING_ENABLE = 1

MAINTAINER = SynoCommunity
DESCRIPTION = BorgBackup \(short: Borg\) is a deduplicating backup program. Optionally, it supports compression and authenticated encryption. This package includes emborg \(a Borg frontend\) and borgmatic \(simple, configuration-driven backup software for servers and workstations\).

DISPLAY_NAME = Borg
STARTABLE = no
CHANGELOG = "1. Update borgmatic to v1.9.8. <br/>2. Update emborg to v1.41. <br/>3. Migrate to Python 3.12."

HOMEPAGE = https://borgbackup.readthedocs.io
LICENSE  = 3-Clause BSD

SERVICE_SETUP = src/service-setup.sh

SPK_USR_LOCAL_LINKS = bin:env/bin/borg bin:env/bin/borgmatic bin:env/bin/emborg

include ../../mk/spksrc.python.mk

# [borgbackup]
# Use OpenSSL path as defined by either
# spksrc.wheel-env.mk or spksrc.python.mk
ENV += BORG_OPENSSL_PREFIX="$(OPENSSL_STAGING_PREFIX)"
ENV += BORG_LIBACL_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBB2_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBLZ4_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBXXHASH_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBZSTD_PREFIX="$(STAGING_INSTALL_PREFIX)"
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
