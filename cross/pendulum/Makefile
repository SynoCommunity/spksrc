PKG_NAME = pendulum
PKG_VERS = 3.0.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/b8/fe/27c7438c6ac8b8f8bef3c6e571855602ee784b85d072efddfff0ceb1cd77
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://pendulum.eustace.io
COMMENT  = Python datetimes made easy.
LICENSE  = MIT

# toolchains lacking atomic support
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)

PATCHES_LEVEL = 1

include ../../mk/spksrc.common.mk

ifeq ($(call version_le, $(TC_GCC), 5),1)
ADDITIONAL_CFLAGS = -std=c99
endif

include ../../mk/spksrc.python-wheel.mk
