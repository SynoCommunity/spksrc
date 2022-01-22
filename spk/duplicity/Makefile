SPK_NAME = duplicity
SPK_VERS = 0.8.21
SPK_REV = 8
SPK_ICON = src/duplicity.png

BUILD_DEPENDS = cross/python310
DEPENDS = cross/librsync cross/duply

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
CHANGELOG = "1. Update duplicity to v0.8.21 and duply to v2.3.1<br/>2. Update to Python 3.10<br/>3. Update supported backend libraries"

HOMEPAGE = https://duplicity.gitlab.io/duplicity-web/
LICENSE  = GPLv2

SERVICE_SETUP = src/service-setup.sh

# use alternate TMPDIR as /tmp might be too small.
USE_ALTERNATE_TMPDIR = 1

SPK_COMMANDS = bin/duply bin/duplicity

SPK_USR_LOCAL_LINKS  = bin:env/bin/duplicity
SPK_USR_LOCAL_LINKS += bin:bin/duply

include ../../mk/spksrc.spk.mk
