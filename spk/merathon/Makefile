SPK_NAME = merathon
SPK_VERS = 2.19.0
SPK_REV = 1
SPK_ICON = src/merathon.png

DEPENDS = cross/merathon cross/merathon_web

# Highest rust-version among the dependencies of the server build
MIN_RUSTC_VERSION = 1.91

MAINTAINER = J-Dudek
DESCRIPTION = Merathon is a Git client with a commit graph, interactive rebase, worktrees and GitHub / GitLab pull requests. This package serves its web interface to your browser, with your repositories staying on the NAS.
DESCRIPTION_FRE = Merathon est un client Git avec graphe de commits, rebase interactif, worktrees et pull requests GitHub / GitLab. Ce paquet sert son interface web à votre navigateur, vos dépôts restant sur le NAS.
DISPLAY_NAME = Merathon
CHANGELOG = "Initial release."

HOMEPAGE = https://github.com/J-Dudek/merathon
LICENSE = MIT

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8765
SERVICE_PORT_TITLE = Merathon
# The wizard asks for the name of the shared folder that holds the repositories: DSM creates it and gives rw access to the service user
SERVICE_WIZARD_SHARENAME = wizard_repos_share

# The DSM menu icon opens a page of the package served by DSM itself (src/app/index.html), which leads to Merathon:
# to the address given in the wizard (a reverse proxy), else to the service port. A plain "port" shortcut cannot be
# reached from a DSM used over HTTPS on an HSTS domain (myds.me), since the service speaks HTTP.
DSM_UI_CONFIG = src/app/config

WIZARDS_DIR = src/wizard/

POST_STRIP_TARGET = merathon_custom_install

include ../../mk/spksrc.spk.mk

.PHONY: merathon_custom_install
merathon_custom_install:
	@$(MSG) "Set library runpath in merathon-server executable."
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/merathon-server
	@$(MSG) "Install the page opened by the DSM menu icon."
	@install -d -m 755 $(STAGING_DIR)/app
	@install -m 644 src/app/index.html src/app/open.js src/app/open.css src/app/address.js $(STAGING_DIR)/app/
