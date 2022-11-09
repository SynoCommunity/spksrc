SPK_NAME = git
SPK_VERS = 2.38.1
SPK_REV = 25
SPK_ICON = src/git.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Git is a fast, scalable, distributed revision control system with an unusually rich command set that provides both high-level operations and full access to internals.
DESCRIPTION_FRE = Git est un système de gestion de révision rapide, extensible et distribué avec un ensemble de commandes inhabituellement riche qui fournit à la fois des opérations de haut niveau et un accès complet aux structures de bas niveau.
STARTABLE = no
DISPLAY_NAME = Git
CHANGELOG = "1. Update git to v2.38.1. This version includes Scalar, a repository manager for large repos.<br/>2. Update openssl to v1.1.1s.<br/>3. Update zlib to v1.2.13 (fixes: CVE-2022-37434).<br/>4. Update curl to v7.86.0 (fixes: CVE-2022-42916, CVE-2022-42915, CVE-2022-35260, CVE-2022-35252, CVE-2022-32221).<br/>5. Update libexpat to v2.5.0."

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
