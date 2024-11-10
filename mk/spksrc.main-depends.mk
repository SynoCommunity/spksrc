# include this file for dummy modules that evaluate dependent packages only
#

# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# Configure the included makefiles
NAME          = $(PKG_NAME)
COOKIE_PREFIX = $(PKG_NAME)-

ifneq ($(ARCH),)
ifneq ($(ARCH),noarch)
ARCH_SUFFIX = -$(ARCH)-$(TCVERSION)
TC = syno$(ARCH_SUFFIX)
endif
endif

#####

ifneq ($(REQUIRE_KERNEL),)
  @$(error main-depends cannot be used when REQUIRE_KERNEL is set)
endif

#####

# to check for supported archs and DSM versions
include ../../mk/spksrc.pre-check.mk

# for common env variables
include ../../mk/spksrc.cross-env.mk

# for dependency evaluation
include ../../mk/spksrc.depend.mk


install: depend
include ../../mk/spksrc.install.mk

plist: install
include ../../mk/spksrc.plist.mk

all: install plist


### For managing make all-<supported|latest>
include ../../mk/spksrc.supported.mk

####
