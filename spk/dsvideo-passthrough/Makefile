SPK_NAME = dsvideo-passthrough
SPK_VERS = 0.1.1
SPK_REV = 1
SPK_ICON = src/dsvideo-passthrough.png

DEPENDS = cross/dsvideo-passthrough

# rust edition 2024 required (see Cargo.toml)
MIN_RUSTC_VERSION = 1.85

REQUIRED_MIN_DSM = 7.0

MAINTAINER = holg
DESCRIPTION = Proxy in front of Video Station that lets the DS Video app play HEVC files via raw passthrough instead of transcoding. Point DS Video at this NAS on the proxy port (default 5080).
DISPLAY_NAME = DS Video HEVC Passthrough
CHANGELOG = "Initial package release of DS Video HEVC Passthrough 0.1.1."

HOMEPAGE = https://github.com/holg/ds-video-hevc
HELPURL = https://github.com/holg/ds-video-hevc
LICENSE = MIT

SPK_DEPENDS = "VideoStation"

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 5080
SERVICE_PORT_TITLE = DS Video HEVC Passthrough
NO_SERVICE_SHORTCUT = true

WIZARDS_DIR = src/wizard/

include ../../mk/spksrc.spk.mk
