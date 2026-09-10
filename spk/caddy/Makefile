SPK_NAME = caddy
SPK_VERS = 2.11.4
SPK_REV = 1
SPK_ICON = src/caddy.png

DEPENDS = cross/caddy

REQUIRED_MIN_DSM = 7.0

# Keep in sync with cross/caddy: no 32-bit x86 or classic PowerPC/ppc64le
# build is published upstream, and hi3535's ABI match with upstream's armv7
# (hardfloat) build hasn't been verified.
UNSUPPORTED_ARCHS = $(i686_ARCHS) $(PPC_ARCHS) $(ARMv7L_ARCHS)

MAINTAINER = cjheath
DESCRIPTION = Caddy is a powerful, extensible platform for serving your sites, services, and apps, with automatic HTTPS. Configuration lives in a user-editable Caddyfile at /var/packages/caddy/var/Caddyfile; edit it, then restart the package (or run caddy reload) to apply changes. The default site listens on :8080; see the comments in the Caddyfile for switching to :80/:443.
DISPLAY_NAME = Caddy
CHANGELOG = "1. Initial package. Caddy 2.11.4."

HOMEPAGE = https://caddyserver.com/
HELPURL = https://caddy.community/
LICENSE = Apache-2.0

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8080
SERVICE_PORT_TITLE = Caddy (HTTP)
ADMIN_PORT = $(SERVICE_PORT)
FWPORTS = src/caddy.sc

WIZARDS_DIR = src/wizard

SPK_COMMANDS = bin/caddy

POST_STRIP_TARGET = caddy_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: caddy_extra_install
caddy_extra_install:
	@install -d -m 755 $(STAGING_DIR)/var
	@install -m 644 src/Caddyfile $(STAGING_DIR)/var/Caddyfile.default
