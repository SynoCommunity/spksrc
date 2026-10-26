PKG_NAME = speedketchup
PKG_VERS = 0.5
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/gatispei/speedketchup/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# rust's std links against glibc 2.9 wrappers (pipe2, used to spawn processes)
MIN_GLIBC_VERSION = 2.9

HOMEPAGE = https://speedketchup.com
COMMENT  = Runs periodic internet speed tests, stores the results and shows them with charts in its builtin web page.
LICENSE  = GPLv2

include ../../mk/spksrc.cross-rust.mk
