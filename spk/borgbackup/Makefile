SPK_NAME = borgbackup
SPK_VERS = 1.2.2
SPK_REV = 13
SPK_ICON = src/$(SPK_NAME).png

BUILD_DEPENDS = cross/python310
DEPENDS = cross/attr cross/acl cross/openssl cross/lz4 cross/zstd cross/libb2 cross/fuse

SPK_DEPENDS = "python310"

# Requirements file generation
# - first create borgbackup wheel defined in src/requirements-crossenv.txt
# cd src
# /spksrc/native/python310/work-native/install/usr/local/bin/python3 -m venv borg-env
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
DESCRIPTION = Deduplicating backup program with compression and authenticated encryption.

DISPLAY_NAME = Borg
STARTABLE = no
CHANGELOG = "1. Update borg to v1.2.2<br/>2. Update borgmatic to v1.7.5.<br>/3. Include compiled version of msgpack for enhanced performance.<br/>4. Update emborg to v1.34."

HOMEPAGE = https://borgbackup.readthedocs.io
LICENSE  = 3-Clause BSD

SERVICE_SETUP = src/service-setup.sh

SPK_USR_LOCAL_LINKS = bin:env/bin/borg bin:env/bin/borgmatic bin:env/bin/emborg

ENV += BORG_OPENSSL_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBLZ4_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBZSTD_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBB2_PREFIX="$(STAGING_INSTALL_PREFIX)"

include ../../mk/spksrc.spk.mk
