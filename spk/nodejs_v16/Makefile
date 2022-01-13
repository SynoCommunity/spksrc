SPK_NAME = nodejs_v16
SPK_VERS = 16.13.2
SPK_REV = 2
SPK_ICON = src/node.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Node.js® is a JavaScript runtime built on Chrome's V8 JavaScript engine.
CHANGELOG = "Update Node.js to v16.13.2 and fix runtime for models with ARMv7 CPU. This security update is addressing CVE-2021-44531, CVE-2021-44532, CVE-2021-44533 and CVE-2022-21824."
DISPLAY_NAME = Node.js® v16

HOMEPAGE = https://nodejs.org
LICENSE  = https://github.com/nodejs/node/raw/master/LICENSE

STARTABLE = no

SPK_COMMANDS = bin/node bin/npm bin/npx

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
POST_STRIP_TARGET = include_atomic_library
endif

include ../../mk/spksrc.spk.mk

TC_LIBRARY_PATH = $(realpath $(TC_PATH)..)/$(TC_LIBRARY)
# As long as there is only one DSM 7 toolchain version available, we do not need
# to care about different versions of libatomic.so
TC_LIBATOMIC_FILE = libatomic.so.1.2.0

.PHONY: include_atomic_library
include_atomic_library:
	@$(MSG) Install atomic library from $(TC_LIBRARY_PATH)
	@install -m 644 $(TC_LIBRARY_PATH)/$(TC_LIBATOMIC_FILE) $(STAGING_DIR)/lib/
	@cd $(STAGING_DIR)/lib/ && ln -sf $(TC_LIBATOMIC_FILE) libatomic.so.1
	@cd $(STAGING_DIR)/lib/ && ln -sf $(TC_LIBATOMIC_FILE) libatomic.so	
