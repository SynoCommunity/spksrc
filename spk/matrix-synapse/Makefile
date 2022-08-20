SPK_NAME = matrix-synapse
SPK_VERS = 1.64.0
SPK_REV = 1
SPK_ICON = src/$(SPK_NAME).png

BUILD_DEPENDS = cross/python310
DEPENDS =

SPK_DEPENDS = "python310"

WHEELS = src/requirements-abi3.txt src/requirements-crossenv.txt src/requirements-pure.txt

# Additional requirements for cross compiled wheels (abi3 and crossenv):
WHEELS_CFLAGS =
WHEELS_BUILD_ARGS =

# cryptography requires rust build (and setuptools-rust)
WHEELS_RUST_BUILD_ENABLE = TRUE
## hints on cross compiling cryptography with rust:
## https://github.com/pyca/cryptography/issues/5814
## https://github.com/rust-lang/cargo/issues/8147

# [frozendict]
WHEELS_CFLAGS += [frozendict] --std=c11

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

DISPLAY_NAME = Synapse
CHANGELOG = "Initial package release."

HOMEPAGE = https://matrix.org/
LICENSE  = Apache 2.0

STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.spk.mk
