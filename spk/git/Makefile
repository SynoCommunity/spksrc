SPK_NAME = git
SPK_VERS = 2.48.1
SPK_REV = 34
SPK_ICON = src/git.png

DEPENDS = cross/git
OPTIONAL_DEPENDS = cross/git-lfs

MAINTAINER = SynoCommunity
DESCRIPTION = Git is a fast, scalable, distributed revision control system with an unusually rich command set that provides both high-level operations and full access to internals.
DESCRIPTION_FRE = Git est un système de gestion de révision rapide, extensible et distribué avec un ensemble de commandes inhabituellement riche qui fournit à la fois des opérations de haut niveau et un accès complet aux structures de bas niveau.
STARTABLE = no
DISPLAY_NAME = Git
CHANGELOG = "Update git to v2.48.1 and git-lfs to v3.6.1."

HOMEPAGE = https://git-scm.com
LICENSE  = GPLv2

SPK_COMMANDS  = bin/git
SPK_COMMANDS += bin/git-cvsserver
SPK_COMMANDS += bin/git-receive-pack
SPK_COMMANDS += bin/git-shell
SPK_COMMANDS += bin/git-upload-archive
SPK_COMMANDS += bin/git-upload-pack
SPK_COMMANDS += bin/scalar

include ../../mk/spksrc.spk.mk

ifneq ($(findstring $(ARCH),$(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
DEPENDS += cross/git-lfs
SPK_COMMANDS += bin/git-lfs
endif
