SPK_NAME = nzbhydra2
SPK_VERS = 2.0.9
SPK_REV = 1
SPK_ICON = src/nzbhydra2.png
BETA = 1

DEPENDS = cross/$(SPK_NAME)
SPK_DEPENDS = "Java8>8.0.151"
UNSUPPORTED_ARCHS = $ARM_ARCHES $PPC_ARCHES $x86_ARCHES

MAINTAINER = SynoCommunity
DESCRIPTION = NZBHydra 2 is a meta search for NZB indexers. It provides easy access to a number of raw and newznab based indexers. You can search all your indexers from one place and use it as indexer source for tools like Sonarr or CouchPotato. It's a complete rewrite of NZBHydra (1). It's currently in Beta. It works mostly fine but some functions might not be completely done and incompatibilities with some tools might still exist.
RELOAD_UI = yes
DISPLAY_NAME = NZBHydra2
CHANGELOG = "Initial NZBHydra 2 package"

HOMEPAGE   = https://github.com/theotherp/nzbhydra2
LICENSE    = ApacheV2
STARTABLE  = yes

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 5076
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = nzbhydra2_extra_install

# Pure Java package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: nzbhydra2_extra_install
nzbhydra2_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
