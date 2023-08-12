SPK_NAME = duplicity
SPK_VERS = 1.2.3
SPK_REV = 10
SPK_ICON = src/duplicity.png

PYTHON_PACKAGE = python311
SPK_DEPENDS = "python311>=3.11.4-7:gnupg>=2.1.6"
WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

DEPENDS = cross/librsync cross/duply

# protobuf: missing atomics support 
# /upb/port/atomic.h:35:23: fatal error: stdatomic.h: No such file or directory
UNSUPPORTED_ARCHS = $(ARMv7L_ARCHS) $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

# [cryptography]
DEPENDS += cross/cryptography

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt

# [PyYAML]
DEPENDS += cross/libyaml

# [PyNaCl]
DEPENDS += cross/libsodium
ENV += SODIUM_INSTALL=system

# [protobuf]
WHEELS_CPPFLAGS = [protobuf] -std=c99

MAINTAINER = SynoCommunity
DESCRIPTION = Encrypted bandwidth-efficient backup using the rsync algorithm. Also contains duply wrapper script (duply is supported only for DSM >= 6.0).
STARTABLE = no
DISPLAY_NAME = Duplicity
CHANGELOG = "1. Update duplicity to v1.2.3 and duply to v2.4.3<br/>2. Update to OpenSSL 3.1.2<br/>3. Migrate to python 3.11.<br/>4. Drop support for ARMv5 and ARMv7L archs."

HOMEPAGE = https://duplicity.gitlab.io/duplicity-web/
LICENSE  = GPLv2

SERVICE_SETUP = src/service-setup.sh

# use alternate TMPDIR as /tmp might be too small.
USE_ALTERNATE_TMPDIR = 1

SPK_COMMANDS = bin/duply bin/duplicity

SPK_USR_LOCAL_LINKS  = bin:env/bin/duplicity
SPK_USR_LOCAL_LINKS += bin:bin/duply

include ../../mk/spksrc.python.mk
