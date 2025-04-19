SPK_NAME = duplicity
SPK_VERS = 3.0.4.0
SPK_REV = 11
SPK_ICON = src/duplicity.png

# protobuf: missing atomics support 
# /upb/port/atomic.h:35:23: fatal error: stdatomic.h: No such file or directory
UNSUPPORTED_ARCHS = $(ARMv7L_ARCHS) $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

PYTHON_PACKAGE = python312
SPK_DEPENDS = "$(PYTHON_PACKAGE):gnupg>=2.1.6"
WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

DEPENDS = cross/librsync cross/duply

MAINTAINER = SynoCommunity
DESCRIPTION = Encrypted bandwidth-efficient backup using the rsync algorithm. Also contains duply wrapper script (duply is supported only for DSM >= 6.0).
STARTABLE = no
DISPLAY_NAME = Duplicity
CHANGELOG = "1. Update duplicity to v3.0.4.0 and duply to v2.5.5.<br/>2. Migrate to Python 3.12."

HOMEPAGE = https://duplicity.gitlab.io/duplicity-web/
LICENSE  = GPLv2

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

# use alternate TMPDIR as /tmp might be too small.
USE_ALTERNATE_TMPDIR = 1

SPK_COMMANDS = bin/duply bin/duplicity

SPK_USR_LOCAL_LINKS  = bin:env/bin/duplicity
SPK_USR_LOCAL_LINKS += bin:bin/duply

# [cryptography]
DEPENDS += cross/openssl3

# [PyNaCl]
DEPENDS += cross/libsodium
ENV += SODIUM_INSTALL=system

# [PyYAML]
DEPENDS += cross/libyaml

include ../../mk/spksrc.python.mk

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [lxml] -std=c11
endif

# [protobuf]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CPPFLAGS = [protobuf] -std=c11
endif

# [duplicity]
#   - To be built last
DEPENDS += python/duplicity
