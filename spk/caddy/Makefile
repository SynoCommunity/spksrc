SPK_NAME = caddy
SPK_VERS = 2.11.4
SPK_REV = 4
SPK_ICON = src/caddy.png

DEPENDS = cross/caddy

REQUIRED_MIN_DSM = 7.0

# Keep in sync with cross/caddy: no 32-bit x86 or classic PowerPC/ppc64le
# build is published upstream, and hi3535's ABI match with upstream's armv7
# (hardfloat) build hasn't been verified.
UNSUPPORTED_ARCHS = $(i686_ARCHS) $(PPC_ARCHS) $(ARMv7L_ARCHS)

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

# spksrc's copy/strip/icon build stages are gated by one-shot cookie files
# under each work-<arch>-<tcversion>/ directory: once created, nothing
# but `make clean`/`smart-clean` clears them - there's no reverse
# dependency on this package's own src/ files or this Makefile, so an
# edited Caddyfile or icon is silently ignored by a plain `make` (the
# staging/ copy it feeds was already made, once, and is never touched
# again). Since the "does the cookie already exist" check that decides
# whether the real rebuild rule even gets defined happens at
# Makefile-parse time (inside the spksrc.spk.mk include below),
# invalidation has to happen earlier still: drop the strip/icon cookies
# here whenever what actually feeds them is newer, so a plain `make`
# picks up such a change instead of silently reusing a stale copy.
$(shell for cookie in work-*/.strip_done work-*/.icon_done; do \
	[ -e "$$cookie" ] || continue; \
	for src in src/Caddyfile src/caddy.png Makefile; do \
		[ "$$src" -nt "$$cookie" ] 2>/dev/null && { rm -f "$$cookie"; break; }; \
	done; \
done)

include ../../mk/spksrc.spk.mk

# $(WORK_DIR)/INFO (defined in spksrc.spk.mk) has no prerequisites of its
# own at all - not even a cookie, just a plain file target - so once it
# exists it's permanently "up to date" no matter what changes in this
# Makefile (SPK_REV, DESCRIPTION, ADMIN_PORT, ...). Confirmed the hard
# way: a rebuilt .spk kept shipping an INFO file frozen at SPK_REV 1 long
# after later revisions. Unlike the cookies above there's no parse-time
# gate to work around - Make will happily merge an extra prerequisite
# declared here with the recipe already defined in spksrc.spk.mk.
$(WORK_DIR)/INFO: Makefile

.PHONY: caddy_extra_install
caddy_extra_install:
	@install -d -m 755 $(STAGING_DIR)/var
	@install -m 644 src/Caddyfile $(STAGING_DIR)/var/Caddyfile.default
