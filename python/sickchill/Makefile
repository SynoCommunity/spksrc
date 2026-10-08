PKG_NAME = sickchill
PKG_VERS = 2026.10.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/SickChill/SickChill/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://sickchill.github.io/
COMMENT  = Automatic Video Library Manager for TV Shows.
LICENSE  = GPLv3+

# Upstream publishes GitHub tags only (no PyPI release since 2024.3.1),
# so the wheel is built here and consumed via DEPENDS in spk/sickchill.
include ../../mk/spksrc.python-wheel.mk
