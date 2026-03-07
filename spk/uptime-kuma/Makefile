SPK_NAME = uptime-kuma
SPK_VERS = 2.2.0
SPK_REV = 1
SPK_ICON = src/uptime-kuma.png

DEPENDS = cross/uptime-kuma
BUILD_DEPENDS = native/nodejs_22

REQUIRED_MIN_DSM = 7.2
UNSUPPORTED_ARCHS = $(32bit_ARCHS)

SPK_DEPENDS = "Node.js_v22"

MAINTAINER = efren-builder
MAINTAINER_URL = https://github.com/efren-builder

DISPLAY_NAME = Uptime Kuma
DESCRIPTION  = A self-hosted monitoring tool. Monitor HTTP\(s\), TCP, Ping, DNS, Docker containers, game servers, and more with 87+ notification providers.
DESCRIPTION_CHS = 自托管监控工具。监控 HTTP\(s\)、TCP、Ping、DNS、Docker 容器、游戏服务器等，支持 87+ 通知提供商。
DESCRIPTION_FRE = Outil de surveillance auto-hébergé. Surveillez HTTP\(s\), TCP, Ping, DNS, conteneurs Docker, serveurs de jeux et plus avec 87+ fournisseurs de notifications.
DESCRIPTION_GER = Selbst gehostetes Monitoring-Tool. Überwachen Sie HTTP\(s\), TCP, Ping, DNS, Docker-Container, Spieleserver und mehr mit 87+ Benachrichtigungsanbietern.
DESCRIPTION_JPN = セルフホスト型監視ツール。HTTP\(s\)、TCP、Ping、DNS、Dockerコンテナ、ゲームサーバーなどを87以上の通知プロバイダーで監視。
DESCRIPTION_SPN = Herramienta de monitoreo autoalojada. Monitoree HTTP\(s\), TCP, Ping, DNS, contenedores Docker, servidores de juegos y más con 87+ proveedores de notificaciones.
HOMEPAGE = https://uptime.kuma.pet
LICENSE = MIT
CHANGELOG = "Initial package release."

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

SERVICE_PORT = 3001
SERVICE_PORT_TITLE = Uptime Kuma (HTTP)

ADMIN_PORT = $(SERVICE_PORT)
ADMIN_PROTOCOL = http
ADMIN_URL = /

WIZARDS_DIR = src/wizard/

USE_ALTERNATE_TMPDIR = 1

include ../../mk/spksrc.spk.mk
