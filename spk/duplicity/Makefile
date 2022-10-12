SPK_NAME = duplicity
SPK_VERS = 1.0.1
SPK_REV = 9
SPK_ICON = src/duplicity.png

BUILD_DEPENDS = cross/python310
DEPENDS = cross/librsync cross/duply

# [cryptography]
DEPENDS += cross/cryptography

# [bcrypt]
ENV += PYO3_CROSS_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib/
ENV += PYO3_CROSS_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt

# [PyYAML]
DEPENDS += cross/libyaml

# [PyNaCl]
DEPENDS += cross/libsodium
ENV += SODIUM_INSTALL=system

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

SPK_DEPENDS = "python310:gnupg>=2.1.6"

MAINTAINER = SynoCommunity
DESCRIPTION = Encrypted bandwidth-efficient backup using the rsync algorithm. Also contains duply wrapper script (duply is supported only for DSM >= 6.0).
STARTABLE = no
DISPLAY_NAME = Duplicity
CHANGELOG = "1. Update duplicity to v1.0.1 and duply to v2.4.1"

HOMEPAGE = https://duplicity.gitlab.io/duplicity-web/
LICENSE  = GPLv2

SERVICE_SETUP = src/service-setup.sh

# use alternate TMPDIR as /tmp might be too small.
USE_ALTERNATE_TMPDIR = 1

SPK_COMMANDS = bin/duply bin/duplicity

SPK_USR_LOCAL_LINKS  = bin:env/bin/duplicity
SPK_USR_LOCAL_LINKS += bin:bin/duply

include ../../mk/spksrc.spk.mk
