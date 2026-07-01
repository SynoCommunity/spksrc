### TEMPORARY download-test SPK - demo, to be archived.
#
# Pulls every cross/demodl-* package so CI actually exercises the git download
# method and each mirror family (gnu/sourceforge/gnome/xorg/kernel) plus the
# generic dead-primary -> PKG_DIST_MIRRORS fallback. (svn/hg macros are moved
# verbatim and validated by sh -n; a live test needs a stable repo we lack.)
# No SPK_ICON (icon step skipped) and STARTABLE=no to stay minimal.

SPK_NAME = demodl
SPK_VERS = 1.0
SPK_REV = 1

# noarch: the cross/demodl-* deps use spksrc.cross-install.mk and only download
# then stage a text file, so they need no toolchain (cross-cc.mk leaves TC empty
# for noarch). One build instead of the whole arch matrix.
override ARCH = noarch

DEPENDS  = cross/demodl-git
DEPENDS += cross/demodl-gnu
DEPENDS += cross/demodl-sourceforge
DEPENDS += cross/demodl-gnome
DEPENDS += cross/demodl-xorg
DEPENDS += cross/demodl-kernel
DEPENDS += cross/demodl-fallback

MAINTAINER = SynoCommunity
DESCRIPTION = Temporary download method/mirror test package (remove/archive after CI proof).
DISPLAY_NAME = Download Test
LICENSE = MIT
STARTABLE = no

include ../../mk/spksrc.spk.mk
