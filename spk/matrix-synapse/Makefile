SPK_NAME = matrix-synapse
SPK_VERS = 1.74.0
SPK_REV = 1
SPK_ICON = src/matrix-synapse.png

BUILD_DEPENDS = cross/python311
DEPENDS = cross/jemalloc

# cryptography built with rust not supported:
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

SPK_DEPENDS = "python311"

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

# Additional requirements for cross compiled wheels:
WHEELS_CFLAGS =
WHEELS_BUILD_ARGS =

# [bcrypt] and [cryptography]
ENV += PYO3_CROSS_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib/
ENV += PYO3_CROSS_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/

# [Pillow]
DEPENDS += cross/freetype cross/libjpeg cross/zlib
WHEELS_BUILD_ARGS += [Pillow]
WHEELS_BUILD_ARGS += build_ext
WHEELS_BUILD_ARGS += --disable-platform-guessing
WHEELS_BUILD_ARGS += --enable-freetype
WHEELS_BUILD_ARGS += --enable-jpeg
WHEELS_BUILD_ARGS += --enable-zlib

# [PyNaCl]
DEPENDS += cross/libsodium
ENV += SODIUM_INSTALL=system

# [PyYAML]
DEPENDS += cross/libyaml

MAINTAINER = hgy59
DESCRIPTION = Synapse is an open-source Matrix homeserver written and maintained by the Matrix.org Foundation.

DISPLAY_NAME = Synapse homeserver
CHANGELOG = "Initial package release."

HOMEPAGE = https://matrix.org/
LICENSE  = Apache 2.0

WIZARDS_DIR = src/wizard/

STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh
SERVICE_USER = auto
SERVICE_PORT = 8008
NO_SERVICE_SHORTCUT = yes

POST_STRIP_TARGET = matrix-synapse_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: matrix-synapse_extra_install
matrix-synapse_extra_install:
	@$(MSG) Add folder for media
	@install -m 755 -d $(STAGING_DIR)/var/media_store
