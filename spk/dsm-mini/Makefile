SPK_NAME = dsm-mini
SPK_VERS = 1.0.13
SPK_REV = 1
SPK_ICON = src/dsm-mini.png

DEPENDS = cross/dsm-mini

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS)
# not supported by go:
UNSUPPORTED_ARCHS += $(PPC_ARCHS)

# DSM 7 only: the package user, the settings window and the DSM APIs the
# service calls are DSM 7's, and upstream's own package says 7.0 as well.
REQUIRED_MIN_DSM = 7.0

MAINTAINER = alexlnos
DESCRIPTION = Run your Synology NAS from Telegram: send the bot a magnet link or a .torrent file, follow Download Station tasks, browse File Station folders, and check disks, virtual machines and containers from the Mini App. Only the Telegram accounts you list get in.
DESCRIPTION_RUS = Управление NAS Synology из Telegram: пришлите боту magnet-ссылку или файл .torrent, следите за задачами Download Station, открывайте папки File Station и смотрите диски, виртуальные машины и контейнеры в Mini App. Доступ только у перечисленных вами аккаунтов.
DESCRIPTION_GER = Ihr Synology-NAS aus Telegram bedienen: Schicken Sie dem Bot einen Magnet-Link oder eine .torrent-Datei, verfolgen Sie Download-Station-Aufgaben, durchsuchen Sie File-Station-Ordner und prüfen Sie Platten, virtuelle Maschinen und Container in der Mini App. Nur die von Ihnen aufgeführten Konten haben Zugang.
DESCRIPTION_FRE = Piloter votre NAS Synology depuis Telegram : envoyez au bot un lien magnet ou un fichier .torrent, suivez les tâches de Download Station, parcourez les dossiers de File Station et surveillez disques, machines virtuelles et conteneurs dans la Mini App. Seuls les comptes que vous listez y ont accès.
DESCRIPTION_ITA = Governa il NAS Synology da Telegram: manda al bot un link magnet o un file .torrent, segui le attività di Download Station, sfoglia le cartelle di File Station e controlla dischi, macchine virtuali e contenitori nella Mini App. Entrano solo gli account che elenchi.
DESCRIPTION_SPN = Gobierna tu NAS Synology desde Telegram: envía al bot un enlace magnet o un archivo .torrent, sigue las tareas de Download Station, explora las carpetas de File Station y revisa discos, máquinas virtuales y contenedores en la Mini App. Solo entran las cuentas que enumeres.
DESCRIPTION_PTB = Comande seu NAS Synology pelo Telegram: mande ao bot um link magnet ou um arquivo .torrent, acompanhe as tarefas do Download Station, navegue pelas pastas do File Station e confira discos, máquinas virtuais e contêineres no Mini App. Entram apenas as contas que você listar.
DESCRIPTION_PLK = Steruj swoim NAS-em Synology z Telegrama: wyślij botowi link magnet albo plik .torrent, śledź zadania Download Station, przeglądaj foldery File Station i sprawdzaj dyski, maszyny wirtualne i kontenery w Mini App. Wchodzą tylko konta, które wypiszesz.
DESCRIPTION_TRK = Synology NAS\'ınızı Telegram\'dan yönetin: bota bir magnet bağlantısı ya da .torrent dosyası gönderin, Download Station görevlerini izleyin, File Station klasörlerine göz atın ve Mini App\'te diskleri, sanal makineleri ve kapsayıcıları denetleyin. Yalnızca listelediğiniz hesaplar girer.
DISPLAY_NAME = DSM mini — Telegram Mini App
CHANGELOG = "1. Initial release."

HOMEPAGE = https://github.com/alexlnos/dsm-mini
LICENSE = MIT

SERVICE_SETUP = src/service-setup.sh

STARTABLE = yes
SERVICE_USER = auto

# No SERVICE_PORT on purpose. The service listens on loopback only — the DSM
# reverse proxy is what publishes it, because Telegram opens a Mini App over
# HTTPS alone — and SERVICE_PORT would generate a firewall rule for a port
# nobody outside should reach, plus a desktop shortcut to an address a browser
# cannot open. The port is 58080 unless the settings window says otherwise.

# The settings window in the DSM main menu, instead of a generated shortcut.
# Same arrangement as spk/gentoo-chroot: an Ext JS app declared in app/config.
# It is also where the package is set up — there is no install wizard: the
# service starts without settings and waits for the window to save them.
DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config
DSM_APP_NAME = SYNOCOMMUNITY.DsmMini.AppInstance

POST_STRIP_TARGET = dsm-mini_extra_install

include ../../mk/spksrc.spk.mk

# The settings window: a page, its script and dictionary, the Ext JS wrapper
# DSM loads from its menu, and the CGI bridge to the service. DSM serves this
# folder at /webman/3rdparty/dsm-mini/.
.PHONY: dsm-mini_extra_install
dsm-mini_extra_install:
	@install -d -m 755 $(STAGING_DIR)/app/images
	@install -m 644 src/app/index.html src/app/app.js src/app/i18n.js src/app/dsm-mini.js $(STAGING_DIR)/app/
	@install -m 755 src/app/api.cgi $(STAGING_DIR)/app/
	@install -m 644 src/app/images/*.png $(STAGING_DIR)/app/images/
