###############################################################################
# spksrc.cross-virtual.mk
#
# Source-less "virtual" cross package: builds and packages a set of DEPENDS
# without any source of its own - e.g. to select one versioned variant among
# cross/<pkg>-<version>. Part of the cross-* entry-point family.
#
# Packages using this only declare DEPENDS (and optionally OPTIONAL_DEPENDS);
# there is no download / checksum / configure / compile step. By convention
# their PKG_NAME carries a "-virtual" suffix so it stays distinct from the real
# package(s) it aggregates.
###############################################################################

# No own source and no build environment (avoids variable leakage).
DEFAULT_ENV   = none
NAME          = $(PKG_NAME)
COOKIE_PREFIX = $(PKG_NAME)-

# Nothing to fetch or verify.
download:
checksum:

ifneq ($(ARCH),)
ifneq ($(ARCH),noarch)
TC = syno-$(ARCH)-$(TCVERSION)
endif
endif

include ../../mk/spksrc.common.mk

ifneq ($(REQUIRE_KERNEL),)
$(error cross-virtual cannot be used when REQUIRE_KERNEL is set)
endif

# Arch/version gating, the common cross environment, then resolve DEPENDS.
include ../../mk/spksrc.rules/pre-check.mk
include ../../mk/spksrc.cross/env-default.mk
include ../../mk/spksrc.rules/depend.mk

# Package whatever the dependencies staged.
install: depend
include ../../mk/spksrc.build/install.mk

plist: install
include ../../mk/spksrc.build/plist.mk

all: install plist

# make all-<supported|latest>
include ../../mk/spksrc.rules/supported.mk
