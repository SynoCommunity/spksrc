PKG_NAME = screen
PKG_VERS = 5.0.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/screen
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw cross/linux-pam

# screen 5 is built with -std=c17, which gcc only accepts from 8:
#   cc1: error: unrecognized command line option '-std=c17'
# Measured on both vendor compilers below that: 4.9.3 (comcerto2k) and 7.5.0
# (every other DSM 7.0 arch) are refused. The arch list named only comcerto2k,
# so DSM 7.0 was attempted and failed; spk/synocli-net now falls back to
# cross/screen there, as it already did for DSM 6 and comcerto2k.
REQUIRED_MIN_DSM = 7.0
MIN_GCC_VERSION = 8
REQUIRED_MIN_SRM = 1.3

HOMEPAGE = https://www.gnu.org/software/screen/
COMMENT  = Screen is a full-screen window manager that multiplexes a physical terminal between several processes, typically interactive shells.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

INSTALL_TARGET = screen_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: screen_install
screen_install:
	@$(MSG) "- Manually install screen (make install fails due to filesystem permissions)"
	@$(RUN) install -c screen $(STAGING_INSTALL_PREFIX)/bin/$(PKG_NAME)
