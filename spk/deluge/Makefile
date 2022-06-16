SPK_NAME = deluge
SPK_VERS = 2.0.5
SPK_REV = 15
SPK_ICON = src/deluge.png

BUILD_DEPENDS = cross/python310

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

SPK_DEPENDS = "python310"

MAINTAINER = Strangelovian
DESCRIPTION = "Deluge is a cross platform BitTorrent client, based on libtorrent rasterbar. This syno community package runs the deluge deamon \(deluged\), as well as the deluge web daemon \(deluge-web\), which serves the deluge web UI."
STARTABLE = yes
CHANGELOG = "1. Update to v2.0.5<br/>2. Update to libtorrent 1.2.16<br/>3. Update to Python 3.10<br/>4. Update to OpenSSL 1.1.1o"
DISPLAY_NAME = Deluge

HOMEPAGE = https://deluge-torrent.org
LICENSE  = GPL
HELPURL  = https://dev.deluge-torrent.org/wiki/UserGuide

# Custom start-stop script needed due to double-daemon
SSS_SCRIPT= src/dsm-control.sh

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_WIZARD_SHARE = wizard_download_dir
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8112
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = deluge_extra_install

include ../../mk/spksrc.common.mk

# [libtorrent] 2.0.6
# # archs lacking C++14 (and c++1y) compiler (88f6281, hi3535 and ppc archs except QorIQ)
# UNSUPPORTED_ARCHS += $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)
# DEPENDS += cross/openssl cross/boost_1.78 cross/geoip
# BOOST_LIBRARIES += system python chrono random
# BOOST_BUILD_PATH=$(WORK_DIR)/boost_1_78_0
# ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"
# ENV += BOOST_BUILD_PATH="$(BOOST_BUILD_PATH)"
# ENV += PATH=$(BOOST_BUILD_PATH):$(PATH)
# WHEELS_BUILD_ARGS += [libtorrent]
# WHEELS_BUILD_ARGS += build_ext
# WHEELS_BUILD_ARGS += --b2-args=libtorrent-python-pic=on
# ifeq ($(findstring $(ARCH),$(32bit_ARCHS)),$(ARCH))
# WHEELS_BUILD_ARGS += --b2-args=address-model=32 --no-autoconf=address-model
# endif
# # libtorrent > 2.x are DSM 7 only due to c++14 minimal requirement
# # Unless c++1y is fixed: https://github.com/arvidn/libtorrent/issues/6868
# REQUIRED_MIN_DSM = 7.0
# UNSUPPORTED_ARCHS += comcerto2k
# # ifeq ($(call version_lt, $(call version_gcc), 5.0),1)
# # WHEELS_BUILD_ARGS += --b2-args=cxxstd=1y
# # endif

# [libtorrent] 1.2.16
# archs lacking C++11 compiler (88f6281, hi3535 and ppc archs except QorIQ)
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)
DEPENDS += cross/openssl cross/boost_1.70 cross/geoip cross/libiconv
BOOST_LIBRARIES += system python chrono random
BOOST_BUILD_PATH=$(WORK_DIR)/boost_1_70_0
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"
ENV += BOOST_BUILD_PATH="$(BOOST_BUILD_PATH)"
ENV += PATH=$(BOOST_BUILD_PATH):$(PATH)
WHEELS_BUILD_ARGS += [libtorrent]
WHEELS_BUILD_ARGS += build_ext
WHEELS_BUILD_ARGS += --b2-args=libtorrent-python-pic=on
ifeq ($(findstring $(ARCH),$(32bit_ARCHS)),$(ARCH))
WHEELS_BUILD_ARGS += --b2-args=address-model=32 --no-autoconf=address-model
endif
ifeq ($(call version_lt, $(call version_gcc), 5.0),1)
WHEELS_BUILD_ARGS += --b2-args=cxxstd=11
endif

include ../../mk/spksrc.spk.mk

.PHONY: deluge_extra_install
deluge_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/core.conf $(STAGING_DIR)/var/core.conf
	install -m 644 src/autoadd.conf $(STAGING_DIR)/var/autoadd.conf
