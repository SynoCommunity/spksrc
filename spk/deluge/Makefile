SPK_NAME = deluge
SPK_VERS = 2.1.1
SPK_REV = 17
SPK_ICON = src/deluge.png

BUILD_DEPENDS = cross/python310

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt src/requirements-abi3.txt

SPK_DEPENDS = "python310"

MAINTAINER = SynoCommunity
DESCRIPTION = Deluge is a cross platform BitTorrent client, based on libtorrent rasterbar. This package integrates both the deluge deamon \(deluged\), as well as its web counterpart \(deluge-web\), which serves the deluge web UI.
DESCRIPTION_FRE = Deluge est un client BitTorrent multi-plateforme, basé sur libtorrent rasterbar. Ce paquet intègre à la fois le démon deluge \(deluged\) ainsi que son penchant web \(deluge-web\), desservant l\'interface utilisateur web deluge.
STARTABLE = yes
CHANGELOG = "1. Update to v2.1.1<br/>2. Update to libtorrent DSM7-2.0.7 and DSM6-1.2.17<br/>3. Update to Python 3.10<br/>4. Update to OpenSSL 1.1.1q<br/>5. Fix Tracker Status Error certificate verify failed and Unspecified system error<br/>6. Enforce listen ports 6881-6891 like previously"
DISPLAY_NAME = Deluge

HOMEPAGE = https://deluge-torrent.org
LICENSE  = GPL
HELPURL  = https://dev.deluge-torrent.org/wiki/UserGuide

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_WIZARD_SHARE = wizard_download_dir
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8112
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = deluge_extra_install

# [rencode]
PYTHON_LIMITED_API=cp37

include ../../mk/spksrc.common.mk

# [libtorrent] - generic
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)
DEPENDS += cross/openssl
DEPENDS += cross/boost_1.78
DEPENDS += cross/geoip
BOOST_LIBRARIES += system python chrono random
BOOST_BUILD_PATH=$(WORK_DIR)/boost_1_78_0
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"
ENV += BOOST_BUILD_PATH="$(BOOST_BUILD_PATH)"
ENV += PATH=$(BOOST_BUILD_PATH):$(PATH)
WHEELS_BUILD_ARGS += [libtorrent]
WHEELS_BUILD_ARGS += build_ext
WHEELS_BUILD_ARGS += --b2-args=libtorrent-python-pic=on
ifeq ($(findstring $(ARCH),$(32bit_ARCHS)),$(ARCH))
WHEELS_BUILD_ARGS += --b2-args=address-model=32 --no-autoconf=address-model
endif

include ../../mk/spksrc.spk.mk

# [libtorrent]
ifeq ($(call version_ge, ${TC_GCC}, 7.5),1)
# [libtorrent] 2.0.7
# DSM7 only due to c++14 minimal requirement
# Unless c++1y is fixed: https://github.com/arvidn/libtorrent/issues/6868
# archs lacking C++14 compiler (88f6281, hi3535, PPC and comcerto2k)
UNSUPPORTED_ARCHS += comcerto2k
WHEELS += src/requirements-crossenv-DSM7.txt
# Ensure build arguments matches boost_1.78
WHEELS_CXXFLAGS += [libtorrent]
WHEELS_CXXFLAGS += -D_GLIBCXX_USE_C99_MATH
WHEELS_CXXFLAGS += -D_GLIBCXX_HAVE_OBSOLETE_ISNAN
WHEELS_CXXFLAGS += -D_GLIBCXX_HAVE_OBSOLETE_ISINF
else
# [libtorrent] 1.2.17
WHEELS += src/requirements-crossenv-DSM6.txt
DEPENDS += cross/libiconv
# Ensure build arguments matches boost
WHEELS_BUILD_ARGS += --b2-args=cxxstd=11
endif

.NOTPARALLEL:
.PHONY: deluge_extra_install
deluge_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/logs
	install -m 644 src/core.conf $(STAGING_DIR)/var/core.conf
	install -m 644 src/autoadd.conf $(STAGING_DIR)/var/autoadd.conf
