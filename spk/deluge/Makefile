SPK_NAME = deluge
SPK_VERS = 2.2.0
SPK_REV = 29
SPK_ICON = src/deluge.png

PYTHON_PACKAGE = python314

WHEELS  = src/requirements-crossenv.txt
WHEELS += src/requirements-pure.txt

MAINTAINER = SynoCommunity
DESCRIPTION = Deluge is a cross platform BitTorrent client, based on libtorrent rasterbar. This package integrates both the deluge deamon \(deluged\), as well as its web counterpart \(deluge-web\), which serves the deluge web UI.
DESCRIPTION_FRE = Deluge est un client BitTorrent multi-plateforme, basé sur libtorrent rasterbar. Ce paquet intègre à la fois le démon deluge \(deluged\) ainsi que son penchant web \(deluge-web\), desservant l\'interface utilisateur web deluge.
STARTABLE = yes
CHANGELOG += "1. Update libtorrent to 2.1.2"
DISPLAY_NAME = Deluge

HOMEPAGE = https://deluge-torrent.org
LICENSE  = GPL
HELPURL  = https://dev.deluge-torrent.org/wiki/UserGuide

# libtorrent-2.1.x requires c++20 > gcc-8.5
REQUIRED_MIN_DSM = 7.2
MIN_GCC_VERSION = 10

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_WIZARD_SHARE = wizard_download_dir
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8112
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

POST_SERVICE_TARGET = deluge_extra_install

include ../../mk/spksrc.common.mk

# [libtorrent]
DEPENDS += cross/openssl3
DEPENDS += cross/libiconv
DEPENDS += cross/boost-1.92
BOOST_BUILD_PATH=$(WORK_DIR)/boost_1_92_0
BOOST_LIBRARIES += system python chrono random
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"
ENV += BOOST_BUILD_PATH="$(BOOST_BUILD_PATH)"
ENV += PATH=$(BOOST_BUILD_PATH):$(PATH)
WHEELS_BUILD_ARGS += [libtorrent]
WHEELS_BUILD_ARGS += build_ext
WHEELS_BUILD_ARGS += --b2-args=libtorrent-python-pic=on
WHEELS_BUILD_ARGS += --b2-args=crypto=openssl
ifeq ($(findstring $(ARCH),$(32bit_ARCHS)),$(ARCH))
WHEELS_BUILD_ARGS += --b2-args=address-model=32 --no-autoconf=address-model
endif

# [Pillow]
DEPENDS += python/pillow

# [rencode]
DEPENDS += python/rencode

.NOTPARALLEL:
.PHONY: deluge_extra_install
deluge_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/logs
	install -m 644 src/core.conf $(STAGING_DIR)/var/core.conf
	install -m 644 src/autoadd.conf $(STAGING_DIR)/var/autoadd.conf
	@$(MSG) Substituting PYTHON_PACKAGE in service-setup
	@sed -i 's|@@PYTHON_PACKAGE@@|$(PYTHON_PACKAGE)|g' $(WORK_DIR)/scripts/service-setup

include ../../mk/spksrc.spk-meta.mk
