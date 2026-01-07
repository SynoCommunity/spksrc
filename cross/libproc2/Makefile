PKG_NAME = libproc2
PKG_REALNAME = procps
PKG_VERS = 4.0.4
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_REALNAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gitlab.com/procps-ng/procps/-/archive/v$(PKG_VERS)
# use dedicated folder to build independent of other tools/libraries built from procps (e.d. cross/procps-ng)
PKG_DIR = $(PKG_NAME)/$(PKG_REALNAME)-v$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)

# NOTE:
# PKG_VERS = 4.0.5 does not require the patch for x64-7.2, but breaks the build of cross/intel-gpu-tools (igt-gpu-tools v1.29 and v1.30)
# igt-gpu-tools v1.29: ../lib/igt_aux.c:1361:76: error: macro "PIDS_VAL" passed 4 arguments, but takes just 3
# igt-gpu-tools v1.30: ../lib/igt_aux.c:1361:62: error: macro "PIDS_VAL" passed 4 arguments, but takes just 3

DEPENDS =

HOMEPAGE = https://gitlab.com/procps-ng/procps
COMMENT  = procps is a set of command line and full-screen utilities that provide information out of the pseudo-filesystem most commonly located at /proc.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = procps_pre_configure

CONFIGURE_ARGS  = --disable-static

# Only the library is needed, disable tools
# DSM-7.2: Fails to build ‘__NR_pidfd_open’ undeclared (fixed by patch)
# ref: https://gitlab.com/procps-ng/procps/-/issues/352
# Disable configurable tools
CONFIGURE_ARGS += --disable-pidof
CONFIGURE_ARGS += --disable-pidwait
CONFIGURE_ARGS += --disable-kill
CONFIGURE_ARGS += --disable-w
CONFIGURE_ARGS += --disable-modern-top
# Disable tools needing ncurses (hugetop, slabtop, top, watch)
CONFIGURE_ARGS += --without-ncurses

ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk

.PHONY: procps_pre_configure
procps_pre_configure:
	@$(RUN) ./autogen.sh
