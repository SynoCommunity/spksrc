SPK_NAME = git
SPK_VERS = 2.56.0
SPK_REV = 42
SPK_ICON = src/git.png

DEPENDS = cross/git

MAINTAINER = SynoCommunity
DESCRIPTION = Git is a fast, scalable, distributed revision control system with an unusually rich command set that provides both high-level operations and full access to internals.
DESCRIPTION_FRE = Git est un système de gestion de révision rapide, extensible et distribué avec un ensemble de commandes inhabituellement riche qui fournit à la fois des opérations de haut niveau et un accès complet aux structures de bas niveau.
STARTABLE = no
DISPLAY_NAME = Git
CHANGELOG = "1. Update git to v2.56.0."

HOMEPAGE = https://git-scm.com
LICENSE  = GPLv2

SPK_COMMANDS  = bin/git
SPK_COMMANDS += bin/git-cvsserver
SPK_COMMANDS += bin/git-receive-pack
SPK_COMMANDS += bin/git-shell
SPK_COMMANDS += bin/git-upload-archive
SPK_COMMANDS += bin/git-upload-pack
SPK_COMMANDS += bin/scalar

include ../../mk/spksrc.common.mk

# Taken where its own floors admit the arch (cross/git-lfs: Go's); its command follows
# spksrc.spk.mk.
$(call depend,cross/git-lfs,nop)

include ../../mk/spksrc.spk.mk

ifneq ($(filter cross/git-lfs,$(DEPENDS)),)
SPK_COMMANDS += bin/git-lfs
endif
