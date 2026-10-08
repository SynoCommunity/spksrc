SPK_NAME = actual-budget
SPK_VERS = 26.10.0
SPK_REV = 1
SPK_ICON = src/actual-budget.png

DEPENDS = cross/actual-budget
BUILD_DEPENDS = native/nodejs_22

# Node.js_v22 (Synology package) declares os_min_ver="7.2-60085"
REQUIRED_MIN_DSM = 7.2
# better-sqlite3 ships prebuilds for 64-bit Linux only
UNSUPPORTED_ARCHS = $(32bit_ARCHS)
UNSUPPORTED_ARCHS_REASON := no 32-bit better-sqlite3 prebuilds

MAINTAINER = SynoCommunity
DESCRIPTION = "Local-first personal finance, budgeting and expense tracking with a web frontend."
DISPLAY_NAME = Actual Budget
CHANGELOG = "1. Initial release of Actual Budget 26.10.0."
HOMEPAGE = https://actualbudget.org
LICENSE = MIT

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes

# Upstream default is 5006, which is reserved by WebStation HTTPS
SERVICE_PORT = 5007
SERVICE_PORT_TITLE = Actual Budget (HTTP)
ADMIN_PORT = $(SERVICE_PORT)

# The raw HTTP port cannot serve the app (browsers require HTTPS for
# SharedArrayBuffer), so suppress the DSM app icon / shortcut that would
# open it directly. The ADMIN_PORT link on the Package Center page stays.
NO_SERVICE_SHORTCUT = 1

WIZARDS_DIR = src/wizard/

USE_ALTERNATE_TMPDIR = 1

SPK_DEPENDS = "Node.js_v22"

include ../../mk/spksrc.spk.mk
