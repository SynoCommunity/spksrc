PKG_NAME = par2cmdline-turbo
PKG_VERS = 1.2.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/animetosho/par2cmdline-turbo/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# A compiler with support for C++11 language features is required.
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = https://github.com/animetosho/par2cmdline-turbo
COMMENT  = This is a simple fork of par2cmdline which replaces core computation routines with ParPars processing backend, improving par2cmdlines performance on x86/ARM platforms. par2cmdline is a PAR 2.0 compatible file verification and repair tool.
LICENSE  = GPL

PRE_CONFIGURE_TARGET = par2cmdline-turbo_pre_configure

GNU_CONFIGURE = 1

ADDITIONAL_CPPFLAGS = -O2
# ignore some compiler warnings
ADDITIONAL_CPPFLAGS += -Wno-unused-variable -Wno-unused-function

include ../../mk/spksrc.cross-cc.mk

.PHONY: par2cmdline-turbo_pre_configure
par2cmdline-turbo_pre_configure:
	@$(RUN) ./automake.sh
