SPK_NAME = git
SPK_VERS = 2.26.2
SPK_REV = 13
SPK_ICON = src/git.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = Safihre
DESCRIPTION = Git is a fast, scalable, distributed revision control system with an unusually rich command set that provides both high-level operations and full access to internals.
DESCRIPTION_FRE = Git est un système de gestion de révision rapide, extensible et distribué avec un ensemble de commandes inhabituellement riche qui fournit à la fois des opérations de haut niveau et un accès complet aux structures de bas niveau.
STARTABLE = no
DISPLAY_NAME = Git
CHANGELOG = "1. Update Git to 2.26.2.<br>2. Fix configuration of CA certificates \(use DSM ca-certificates that hopefully will be updated by synology\)."

HOMEPAGE = http://git-scm.com
LICENSE  = GPLv2

SPK_COMMANDS = bin/git bin/git-cvsserver bin/git-receive-pack bin/git-shell bin/git-upload-archive bin/git-upload-pack

# build cross/curl without bundle of ca certificates (cert.pem)
export CURL_SKIP_CA_BUNDLE = true

include ../../mk/spksrc.spk.mk
