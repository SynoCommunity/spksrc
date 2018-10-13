SPK_NAME = nzbhydra
SPK_VERS = 0.2.233
SPK_REV = 2
SPK_ICON = src/nzbhydra.png

DEPENDS =
SPK_DEPENDS = "python>2.7.9:git"

MAINTAINER = adchevrier
DESCRIPTION = NZBHydra is a meta search for NZB indexers and the \"spiritual successor\" to NZBmegasearcH. It provides easy access to a number of raw and newznab based indexers.
DESCRIPTION_FRE = NZBHydra est un moteur de recherche global pour indexeurs NZB et le \"successeur spirituel\" de NZBmegasearcH. Il fournit un accès facile à un certain nombre de fournisseurs bruts ou basés sur newznab.
RELOAD_UI = yes
DISPLAY_NAME = NZBHydra
CHANGELOG = "1.Integrate with DSM5+6 Generic Service support 2.Update to version 0.2.233"

HOMEPAGE   = https://github.com/theotherp/nzbhydra
LICENSE    = ApacheV2
STARTABLE  = yes

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 5075
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

COPY_TARGET = nop
POST_STRIP_TARGET = nzbhydra_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: nzbhydra_extra_install
nzbhydra_extra_install: $(STAGING_DIR)/share/NZBHydra
	install -m 755 -d $(STAGING_DIR)/var

$(STAGING_DIR)/share/NZBHydra:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/theotherp/nzbhydra.git && cd nzbhydra && git checkout 5ee0233afa930acfcdeac06ae5ca3d921bd266c3
