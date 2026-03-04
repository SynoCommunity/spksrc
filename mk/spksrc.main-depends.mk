# include this file for dummy modules that evaluate dependent packages only
#

# Do not initialize any environment to avoid variable leakage.
DEFAULT_ENV = none

# Common makefiles
include ../../mk/spksrc.common.mk

# nothing to download
download:
checksum:

# Configure the included makefiles
NAME          = $(PKG_NAME)
COOKIE_PREFIX = $(PKG_NAME)-

ifneq ($(ARCH),)
ARCH_SUFFIX = -$(ARCH)-$(TCVERSION)
ifneq ($(ARCH),noarch)
TC = syno$(ARCH_SUFFIX)
endif
endif

# Common directories (must be set after ARCH_SUFFIX)
include ../../mk/spksrc.common/directories.mk

#####

ifneq ($(REQUIRE_KERNEL),)
  @$(error main-depends cannot be used when REQUIRE_KERNEL is set)
endif

#####

# to check for supported archs and DSM versions
include ../../mk/spksrc.rules/pre-check.mk

# for common env variables
include ../../mk/spksrc.cross/env-default.mk

# for dependency evaluation
include ../../mk/spksrc.rules/depend.mk

install: depend
include ../../mk/spksrc.build/install.mk

plist: install
include ../../mk/spksrc.build/plist.mk

all: install plist


### For managing make all-<supported|latest>
include ../../mk/spksrc.rules/supported.mk

####
