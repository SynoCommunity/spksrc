PKG_NAME = powershell
PKG_VERS = 7.7.0
PKG_EXT = tar.gz
# Framework-dependent build: managed code plus native libraries for every
# runtime identifier; runs on the shared .NET 11 runtime (dotnet11-runtime).
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-linux-x64-fxdependent.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/PowerShell/PowerShell/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)

HOMEPAGE = https://microsoft.com/PowerShell
COMMENT  = PowerShell is a cross-platform task automation solution made up of a command-line shell, a scripting language, and a configuration management framework.
LICENSE  = MIT

INSTALL_TARGET = powershell_custom_install

include ../../mk/spksrc.cross-install.mk

.PHONY: powershell_custom_install
powershell_custom_install:
	mkdir -p "$(INSTALL_DIR)/$(INSTALL_PREFIX)/share/powershell/" "$(INSTALL_DIR)/$(INSTALL_PREFIX)/bin/"
	tar -cf - -C $(EXTRACT_PATH) . | tar -xf - -C "$(INSTALL_DIR)/$(INSTALL_PREFIX)/share/powershell/"
	# The bundled apphost is x64-only; the pwsh wrapper starts pwsh.dll with the dotnet11-runtime host instead.
	rm -f "$(INSTALL_DIR)/$(INSTALL_PREFIX)/share/powershell/pwsh"
	install -m 755 src/pwsh "$(INSTALL_DIR)/$(INSTALL_PREFIX)/bin/pwsh"
