SPK_NAME = caddy
SPK_VERS = 2.11.4
SPK_REV = 1
SPK_ICON = src/caddy.png

DEPENDS = cross/caddy

REQUIRED_MIN_DSM = 7.0

# Keep in sync with cross/caddy: Go has no 32-bit PowerPC target, and
# hi3535 (ARMv7L) is excluded pending someone actually asking for/testing
# it, not because of any known build or ABI problem.
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv7L_ARCHS)

MAINTAINER = cjheath
DESCRIPTION = Caddy is a powerful, extensible platform for serving your sites, services, and apps, with automatic HTTPS. Configuration lives in a user-editable Caddyfile at /var/packages/caddy/var/Caddyfile. Edit it, then restart the package, or run caddy reload, to apply changes. The default site listens on port 8880. See the comments in the Caddyfile for switching to ports 80 and 443.
DISPLAY_NAME = Caddy
CHANGELOG = "1. Initial package. Caddy 2.11.4."

HOMEPAGE = https://caddyserver.com/
HELPURL = https://caddy.community/
LICENSE = Apache-2.0

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8880
FWPORTS = src/caddy.sc
# No DSM app-menu shortcut: Caddy has no web UI of its own to open - the
# default site is just a health-check placeholder, and once a real site is
# configured, whatever's behind the reverse proxy is a different app's
# concern, not Caddy's (same reasoning spk/postgresql uses to opt out).
NO_SERVICE_SHORTCUT = 1

WIZARDS_DIR = src/wizard

SPK_COMMANDS = bin/caddy

POST_STRIP_TARGET = caddy_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: caddy_extra_install
caddy_extra_install:
	@install -d -m 755 $(STAGING_DIR)/var
	@install -m 644 src/Caddyfile $(STAGING_DIR)/var/Caddyfile.default
