SPK_NAME = duplicatefinder
SPK_VERS = 1.1.2
SPK_REV = 1
SPK_ICON = src/duplicatefinder.png

DEPENDS = cross/duplicatefinder

# Go has no PPC target; ARMv5 is dropped by the cross package too.
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS)

# The app talks to DSM 7 only: it runs the daemon as the package user
# (conf/privilege run-as package) and gates api.cgi on DSM 7's
# authenticate.cgi, so DSM 6 toolchains are not a target.
REQUIRED_MIN_DSM = 7.0

MAINTAINER = A5HRAJ
DISPLAY_NAME = Duplicate Finder
DESCRIPTION = Find and clean up duplicate files, empty folders, empty files and temporary junk on your DiskStation, and spot conflicting files: copies that share a size and modified time but no longer hold the same content. Duplicates are matched by BLAKE3 content hash. Selected files are moved \(never deleted\) to a folder you choose.
CHANGELOG = "1. Initial package. Duplicate Finder 1.1.2."

HOMEPAGE = https://github.com/A5HRAJ/duplicatefinder
LICENSE  = MIT

STARTABLE = yes
# DSM 7 forces SERVICE_USER=auto anyway; stated for clarity. The daemon,
# api.cgi (exec'd by DSM's web server) and the start script all run as the
# package user, exactly as the hand-built spk did.
SERVICE_USER = auto

# The daemon binds 127.0.0.1:9807 and is reached only through api.cgi, so
# there is deliberately NO SERVICE_PORT: it would generate a firewall rule
# and port-forward entry for a port nothing outside the NAS can use, and it
# would make spksrc generate its own $(DSM_UI_DIR)/config, clobbering the
# app's. The desktop app is declared by the package's own ui/config.
DSM_UI_DIR = ui
DSM_APP_NAME = SYNO.SDS.DuplicateFinder.Application

# The generic start-stop-status backgrounds SERVICE_COMMAND, records $! and
# returns at once. Our daemon can still die during startup (port taken,
# unreadable token file), and a start that reports success before the
# daemon is listening leaves Package Center showing "running" while the UI
# says "service is not running". The hand-built package's script avoids
# that by waiting for the daemon's ready file; that wait needs a custom
# script, which spksrc supports through SSS_SCRIPT.
SSS_SCRIPT = src/start-stop-status

POST_STRIP_TARGET = duplicatefinder_extra_install

include ../../mk/spksrc.spk.mk

# The cross package stages the UI and icons under share/duplicatefinder so
# they travel through the PLIST like any other resource. This target moves
# them to where DSM expects them and applies the cache stamp.
#
# Cache stamp: DSM serves ui/<script> with no Cache-Control under a URL that
# does not change on package upgrade, so browsers keep running a previous
# build's script. The shipped filename therefore carries the script's own
# content hash, and ui/config's single top-level key is rewritten to match
# (that key is the ONLY thing in the package that names the file: a mismatch
# registers the app on the desktop and then 404s on launch). jq is used so
# a malformed config fails the build instead of shipping. The unstamped
# DuplicateFinder.js is not kept: it would re-anchor the cached URL.
.PHONY: duplicatefinder_extra_install
duplicatefinder_extra_install:
	@$(MSG) "Installing DSM desktop UI"
	@rm -rf $(STAGING_DIR)/ui
	@mv $(STAGING_DIR)/share/duplicatefinder/ui $(STAGING_DIR)/ui
	@install -d -m 755 $(STAGING_DIR)/ui/images
	@install -m 644 $(STAGING_DIR)/share/duplicatefinder/icons/icon_*.png $(STAGING_DIR)/ui/images/
	@rm -rf $(STAGING_DIR)/share
	@chmod 755 $(STAGING_DIR)/ui/api.cgi
	@$(MSG) "Stamping UI script with its content hash"
	@set -e; cd $(STAGING_DIR)/ui; \
	  hash=$$(md5sum DuplicateFinder.js | cut -c1-8); \
	  name="DuplicateFinder-$(subst .,-,$(SPK_VERS))-$(SPK_REV)-$$hash.js"; \
	  mv DuplicateFinder.js "$$name"; \
	  jq --arg new "$$name" 'if (keys | length) != 1 or (keys[0]) != "DuplicateFinder.js" then error("ui/config must hold exactly the key DuplicateFinder.js, got " + (keys|tostring)) else {($$new): .["DuplicateFinder.js"]} end' config > config.new; \
	  mv config.new config; \
	  chmod 644 config "$$name"
	@$(MSG) "Checking the staged UI is coherent"
	@set -e; cd $(STAGING_DIR)/ui; \
	  key=$$(jq -r 'keys[0]' config); \
	  [ -f "$$key" ] || { echo "ui/config names '$$key' but no such file was staged" >&2; exit 1; }; \
	  [ ! -f DuplicateFinder.js ] || { echo "unstamped DuplicateFinder.js must not ship" >&2; exit 1; }; \
	  if grep -l '/webman/3rdparty/DuplicateFinder\|/var/packages/DuplicateFinder' "$$key" api.cgi >/dev/null; then \
	    echo "UI still hardcodes the hand-built package's mixed-case id; see spksrc/README.md" >&2; exit 1; \
	  fi
