SPK_NAME = deluge
SPK_VERS = 2.1.1.127
SPK_REV = 24
SPK_ICON = src/deluge.png

PYTHON_PACKAGE = python311

WHEELS  = src/requirements-crossenv.txt
WHEELS += src/requirements-pure.txt
WHEELS += src/requirements-abi3.txt

SPK_DEPENDS = "python311>=3.11.5-8"

MAINTAINER = SynoCommunity
DESCRIPTION = Deluge is a cross platform BitTorrent client, based on libtorrent rasterbar. This package integrates both the deluge deamon \(deluged\), as well as its web counterpart \(deluge-web\), which serves the deluge web UI.
DESCRIPTION_FRE = Deluge est un client BitTorrent multi-plateforme, basé sur libtorrent rasterbar. Ce paquet intègre à la fois le démon deluge \(deluged\) ainsi que son penchant web \(deluge-web\), desservant l\'interface utilisateur web deluge.
STARTABLE = yes
CHANGELOG = "1. Update to latest github development commit<br/>2. Update to libtorrent 2.0.10<br/>3. Update all other wheels"
DISPLAY_NAME = Deluge

HOMEPAGE = https://deluge-torrent.org
LICENSE  = GPL
HELPURL  = https://dev.deluge-torrent.org/wiki/UserGuide

REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_WIZARD_SHARE = wizard_download_dir
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8112
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = deluge_extra_install

include ../../mk/spksrc.python.mk

# [libtorrent]
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)
DEPENDS += cross/openssl3
DEPENDS += cross/geoip
DEPENDS += cross/libiconv
DEPENDS += cross/boost_1.82
BOOST_BUILD_PATH=$(WORK_DIR)/boost_1_82_0
BOOST_LIBRARIES += system python chrono random
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"
ENV += BOOST_BUILD_PATH="$(BOOST_BUILD_PATH)"
ENV += PATH=$(BOOST_BUILD_PATH):$(PATH)
WHEELS_BUILD_ARGS += [libtorrent]
WHEELS_BUILD_ARGS += build_ext
WHEELS_BUILD_ARGS += --b2-args=libtorrent-python-pic=on
ifeq ($(findstring $(ARCH),$(32bit_ARCHS)),$(ARCH))
WHEELS_BUILD_ARGS += --b2-args=address-model=32 --no-autoconf=address-model
endif

.NOTPARALLEL:
.PHONY: deluge_extra_install
deluge_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/logs
	install -m 644 src/core.conf $(STAGING_DIR)/var/core.conf
	install -m 644 src/autoadd.conf $(STAGING_DIR)/var/autoadd.conf
