SPK_NAME = borgbackup
SPK_VERS = 1.4.0
SPK_REV = 15
SPK_ICON = src/borgbackup.png

PYTHON_PACKAGE = python311
SPK_DEPENDS = "python311>=3.11.5-8"
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

DEPENDS = cross/attr cross/acl cross/openssl3 cross/lz4 cross/zstd cross/libb2 cross/fuse cross/xxhash

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
CHANGELOG = "1. Update borgmatic to v1.9.5. <br/>2. Update emborg to v1.41."

HOMEPAGE = https://borgbackup.readthedocs.io
LICENSE  = 3-Clause BSD

SERVICE_SETUP = src/service-setup.sh

SPK_USR_LOCAL_LINKS = bin:env/bin/borg bin:env/bin/borgmatic bin:env/bin/emborg

# Use OpenSSL path as defined by either
# spksrc.wheel-env.mk or spksrc.python.mk
ENV += BORG_OPENSSL_PREFIX="$(OPENSSL_STAGING_PREFIX)"
ENV += BORG_LIBLZ4_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBZSTD_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBB2_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBXXHASH_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBACL_PREFIX="$(STAGING_INSTALL_PREFIX)"

include ../../mk/spksrc.common.mk

# [rpds-py]
# Requires path to maturin from crossenv
ENV += PATH=$(WORK_DIR)/crossenv/build/bin:$(PATH)

include ../../mk/spksrc.python.mk
