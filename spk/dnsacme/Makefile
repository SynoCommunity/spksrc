SPK_NAME = dnsacme
SPK_VERS = 1.0.3
SPK_REV = 1
SPK_ICON = src/dnsacme.png

DEPENDS = cross/dnsacme

REQUIRED_MIN_DSM = 7.0
REQUIRED_MIN_SRM = 3.0
UNSUPPORTED_ARCHS = $(32bit_ARCHS)

MAINTAINER = mritd
DESCRIPTION = DNS-01 ACME certificate manager with Synology DSM certificate deployment.
DISPLAY_NAME = DNSACME
CHANGELOG = "Initial release."

HOMEPAGE = https://github.com/mritd/dnsacme
LICENSE = Apache-2.0

STARTABLE = yes
SERVICE_USER = auto
SSS_SCRIPT = src/start-stop-status.sh

DSM_UI_DIR = ui
DSM_APP_NAME = SYNO.SDS.DNSACME.Application

include ../../mk/spksrc.spk.mk
